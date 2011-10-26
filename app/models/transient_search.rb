class TransientSearch 
   
  attr_accessor :q,:status,:access,:ownership, :user_id, :important
  
  def initialize(args=nil)
     return if args.nil?
     
     self.q= args[:q]
     self.status= args[:status]
     self.ownership = args[:ownership]
     self.access = args[:access]
     self.user_id = args[:user_id]
     self.important = args[:important]
     
  end
  
  def parent? 
    ownership == 'parent'
  end
  
  def leaf?
    ownership == "leaf"
  end
  
  def project?
    ownership == "project"
  end
  
  
  def important?
    @important
  end
  
  
  def important=(value)
    @important =  [true, "true", "1", "1", "T", "t"].include?(value.class == String ? value.downcase : value)
  end
 
   
  def results 
     @results = Step.mine(user_id).query(q)
     @results = @results.status_scope(status) unless status.blank?
     @results = @results.projects if project?
     @results = @results.leafs if leaf?
     @results = @results.parents if parent?
     @results = @results.important if important?
     @results = @results.select {|item| item.resolved_access == access} unless access.blank?
     @results
  end
  
end