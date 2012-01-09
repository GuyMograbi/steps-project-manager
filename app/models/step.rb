class Step < ActiveRecord::Base
  
      Status = ['new','started','completed','pending update']
      Access = ['public','inherit','private'] 
      Searchable_Access = ['public','private'] # inherit is not really an access..
      Ownership = ['project','leaf','parent']
      
      named_scope :mine, lambda {|user|{:conditions => ["user_id = ?",user]}}
      named_scope :projects , :conditions => ["parent_id is null"]
      named_scope :requires_update , :conditions => {:status => 'pending update'}
      named_scope :leafs, :conditions => ["id not in (select distinct parent_id from steps where parent_id is not null)"]
      named_scope :parents, :conditions => ["id in (select distinct parent_id from steps where parent_id is not null)"] 
      named_scope :accessible , :conditions => ["access = ?", 'public'] # check if used  
      named_scope :recently_added , lambda { |limit| {:limit => limit, :conditions=>["created_at = updated_at"],:order => 'created_at DESC'}} 
      named_scope :recently_updated, lambda { |limit| {:limit => limit , :conditions => ["updated_at > created_at"],  :order => 'updated_at DESC'}}
      named_scope :ownership, lambda { |o|  return {} if o.nil? 
                                            return Step.leafs if o == 'leaf'
                                            return Step.projects if o == "project"
                                            return Step.parents if o == "parent" } 
      named_scope :query, lambda {|query| {:conditions => ["description like ? or title like ?","%#{query}%","%#{query}%"]}}
      named_scope :status_scope, lambda {|s| {:conditions => {:status => s}}}
      named_scope :important, :conditions => { :important => true }
      named_scope :not_completed, :conditions => [" important = 1 and status <> 'completed' "]
      named_scope :started_children, lambda {|p| {:conditions => {:parent_id => p , :status => 'started'}}} 
      named_scope :new_children, lambda {|p| {:conditions => {:parent_id => p , :status => 'new'}}}
      named_scope :completed_children, lambda {|p| {:conditions => {:parent_id => p , :status => 'completed'}}}
      named_scope :pending_children, lambda {|p| {:conditions => {:parent_id => p , :status => 'pending update'}}}
      
      validates_presence_of :title, :description, :status
      validate :child_of_self
      belongs_to :parent,
                  :class_name => 'Step',
                  :foreign_key => :parent_id
                  
      has_many :children, 
               :class_name => 'Step',
               :foreign_key => 'parent_id',
               :dependent => :delete_all
               
               
      def to_s 
        title
    end
    
    def to_param 
      
      "#{id}-#{title.gsub(/[' ','\/','.',':','?','!','@','#','$','%','^','&','*','(',')','{','}','\[','\]']/, '-')}" 
      #"#{id}-#{title.gsub(/[' ','.',':','?','!','@','#','$','%','^','&','*','(',')','{','}','\[','\]']/, '-')}"
      #"#{id}-guy"
    end
    
    def accessible?
      inherits_public?;      
    end

    def children?
      !children.blank?
    end
    
    def pending? 
      status == 'pending update'
    end
    
    def new? 
      status == 'new'
    end
    
    def completed? 
      status == 'completed'
    end
    
    def started? 
      status == 'started'
    end
  
  def accessible_children
    self.children.select {|s| s.accessible?}
  end
    
    def inherits_access?
      return self.access.eql?('inherit')
  end
  
  # This function tried to find out the status of this project
  # after its children's status was modified. 
  # if we discover the status indeed changed, we bubble it up to parent
  def bubble_status
    
    puts "current status is #{status}"
    
    if Step.started_children(id).count  > 0 
      self.status = 'started';
    elsif Step.pending_children(id).count > 0
      self.status = 'pending update'
    elsif Step.new_children(id).count == 0
      self.status = 'completed'
      # there are no new children - all are completed
    elsif Step.completed_children(id).count == 0
      # there are no completed children - all are new
      self.status = 'new'
    else
      self.status = 'pending update'
    end
    
    puts "new status is #{self.status} so this step changed = #{self.changed?}"
      
      puts "project #{title} has a nill status #{status}" if status.nil?
      if (changed?)
        save!
        parent.bubble_status unless parent.nil?
      end
      
    
  end
  
  def public?
    return self.access.eql?('public')
  end
  
  def inherits_public?
    return resolved_access.eql?('public')
  end
  
  def access_resolver
    resolved_access
    @access_resolver
  end
  
  # project - a step with null parent
 
  def resolved_access
    if (self.inherits_access?) # if we inherit, we must resolve the access
      if (@resolved_access.nil?) 
        ## if we have a parent. lets ask it. otherwise, by default, we are private
        @access_resolver = self.parent ? self.parent.access_resolver : 'default'
        @resolved_access = self.parent ? self.parent.resolved_access : 'private'
      else
        return @resolved_access # we already calculated this. lets return what we found
      end
    else
      @access_resolver = self # I am my own access_resolver
      return self.access # we have a defined access. lets return it
    end
  end
  
  
  def child_of_self
    curr = self.parent
    while (curr)     
          errors.add(:parent_id, " : #{curr.title} and #{self.title} are already related. Choose another parent to avoid a loop")  if (curr == self)
          curr =curr.parent
    end
  end
  
  
end
