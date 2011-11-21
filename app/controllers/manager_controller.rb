class ManagerController < ApplicationController
  def dashboard
  end

  def promote
    update_status {|status| @template.next_status(status)}
  end
  
  def demote
    update_status {|status| @template.prev_status(status)}
  end
  
  
  def search
    filters = params[:search]
    if (filters && filters[:q])
      @search = TransientSearch.new(filters)
      @results = @search.results
    else
      @search = TransientSearch.new() 
    end
    respond_to do |format|
      if params[:mode] == 'print'
          format.html {render :layout=>'print'}          
        else
          format.html {}
          format.xml {}
      end
    end
  end
  
  
#  def twit
#    client=Grackle::Client.new(:headers=>{'User-Agent' => "STEPS[projectmanager.mograbi.co.il]/#{VERSION} Grackle/#{Grackle::VERSION}"},:auth=>{:type=>:basic,:username=>'guymograbi',:password=>'hotmail1'})
#    client.statuses.update! :status=>'trying grackle once more from my site but with headers now'
#  end
  
  private
  
  def update_status 
    begin
    @project = Step.find(params[:id])
      if (@project.nil?)
        flash[:error] = "Step not found"
        redirect_to_dashboard
      
      elseif !has_write_to_project?(@project)
        flash[:errors] = "No Permissions"
        redirect_to_dashboard # should be logout
      else
        @project.status = yield(@project.status)
        @project.save!
        @project.parent.bubble_status unless @project.parent.nil?
        redirect_to :back # might not succeed
      end
#    redirect_to :action=>'dashboard'
    
  rescue Exception => err
      puts err.inspect
      puts err.backtrace
      redirect_to_dashboard
    end
    
  end
end