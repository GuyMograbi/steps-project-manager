class StepsController < ApplicationController
  
  before_filter :prepare_breadcrumb
  before_filter :has_access?
  
  # GET /steps
  # GET /steps.xml
   def index
    @steps = Step.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @steps }
    end
  end

  # GET /steps/1
  # GET /steps/1.xml
  def show
    begin
      @step = Step.find(params[:id])
      @subtitle = @step.title
      respond_to do |format|
        if params[:mode] == 'print'
          format.html {render :layout=>'print'}          
        else
        format.html # show.html.erb
        end
        format.xml  { render :xml => @step }
      end
    rescue Exception => err
      logger.error err
      flash[:err] = err.message
      redirect_to(:controller => "manager", :action => "dashboard")
    end

  end


  # GET /steps/new
  # GET /steps/new.xml
  def new
    @step = Step.new
    @subtitle = "Create New Project"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @step }
    end
  end

  # GET /steps/1/edit
  def edit
    @step = Step.find(params[:id])
  end

  # POST /steps
  # POST /steps.xml
  def create
    @step = Step.new(params[:step])

    respond_to do |format|
      if @step.save
        @step.parent.bubble_status unless @step.parent.nil?        
        flash[:notice] = 'Step was successfully created.'
        format.html { redirect_to(@step.parent)} if @step.parent && params[:commit] == 'Create And Back'
        format.html { redirect_to(@step) }
        format.xml  { render :xml => @step, :status => :created, :location => @step }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /steps/1
  # PUT /steps/1.xml
  def update
    @step = Step.find(params[:id])

    respond_to do |format|
      if @step.update_attributes(params[:step])
        @step.parent.bubble_status unless @step.parent.nil?
        flash[:notice] = 'Step was successfully updated.'
        format.html { redirect_to(@step) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /steps/1
  # DELETE /steps/1.xml
  def destroy
    @step = Step.find(params[:id])
    parent = @step.parent 
    @step.destroy

    parent.bubble_status unless parent.nil?
    respond_to do |format|
      format.html { parent.nil? ? redirect_to(:controller => "manager", :action => "dashboard") : redirect_to(@template.step_path(parent))  }
      format.xml  { head :ok }
    end
  end
  
  
  def prepare_breadcrumb
    begin
     parent = Step.find(params[:id]) if params[:id]
     parent ||= Step.find(params[:parent]) if params[:parent]
     parent ||= Step.find(params[:step][:parent_id]) if params[:step] && params[:step][:parent_id]
     return unless parent
     bc = params[:action] 
     bc = @template.step_breadcrumb(parent) + bc
     bc = (@template.link_to 'Dashboard', :controller => 'manager', :action => "dashboard") + ">" + bc
   
    @template.content_for(:breadcrumb) { bc }
  rescue Exception => err 
       logger.error err
   end
   end
   
   
   def has_access?
     step = Step.find(params[:id]) if params[:id]
#     puts "step.nil? = #{step.nil?}, userid = #{step.user_id == current_user.id}, public = #{step.inherits_public?}"
     unless (step.nil? || step.inherits_public? || (user_signed_in? && step.user_id == current_user.id))
       flash[:error] = "Record not found"
       redirect_to_dashboard
     end
    
 end
end
