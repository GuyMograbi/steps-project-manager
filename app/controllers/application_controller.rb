require 'RedCloth'
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout "manager"
  include ExceptionNotifiable
  
  before_filter :authenticate_user! , :except => ['login','index','show']
  before_filter :find_projects
  
  filter_parameter_logging :password, :password_confirmation
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  
  
  
  
  protected   
  
  def current_project_accessible?
    # This project is accessible if it is public or belongs to this logged in user
    @current_project && (@current_project.accessible? || @current_project.user_id == current_user.id)
  end
  
  
  # we find projects asked by user. 
  # This can also be a "read only" operation. so there might not be a logged-in user.
  def find_projects
    begin
      
      ## ok this is ugly. I need to learn how to do this better
      if (params[:controller] == 'registrations' ||
        params[:controller] == 'confirmations' || 
        params[:controller] == 'sessions' || (params[:controller]=='manager' && params[:action] == 'dashboard' && !user_signed_in?))
        return;
      end
      
      # get current project if accessible
      @current_project = Step.find(params[:id]) if (params[:id])
      @current_project = Step.find(params[:parent]) if (params[:parent]) unless @current_project
      
      @current_project = nil unless current_project_accessible?
      
      puts "action = #{params[:action]} , user_signed_in? = #{user_signed_in?} , controller = #{params[:controller]}, current_project.nil? = #{@current_project.nil?},  current_project=#{@current_project}"
      redirect_to_dashboard unless current_project_accessible? 
      
      ## if user is signed in, we get all children.
      @projects = @current_project.children if (@current_project && current_project_accessible?)
      
      ## if user is not signed in, this means we get only public children
      @projects = @current_project.accessible_children if (@current_project && current_project_accessible? && !@projects)
      
      ## if no id is given in the request, or if @projects were simply uninitialized. 
      # we want to show all projects (step where parent_id == null).
      # currently I don't expose users' dashboard to public, however that might be useful in the future.  
#      @projects = (user_signed_in? ? Step.mine(current_user.id).projects  : Step.mine(current_user.id).accessible.projects) unless @projects
      @projects = Step.mine(current_user.id).projects if(@projects.nil? && user_signed_in?)
      
    rescue Exception => err
      puts err.inspect
      puts err.backtrace
      flash[:error] = err.message
      redirect_to_dashboard
    end
  end
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  private 
  
  ## current project is accessible if it belongs to this user
  # if it we don't have a "current_project" than of course it is accessible.
  def current_project_accessible?
    !@current_project || has_read_to_project?
  end
  
  def has_read_to_project?(proj = @current_project)
    has_write_to_project? || proj.inherits_public?
  end
  
  def has_write_to_project?(proj = @current_project)
    user_signed_in? && proj.user_id == current_user.id
  end
  
  def redirect_to_dashboard
    redirect_to(:controller => "manager", :action => "dashboard") 
  end
    
    
end
