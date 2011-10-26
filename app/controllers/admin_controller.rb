class AdminController < ApplicationController
  
  # ~!~ guy - might not be required
#   def login
#   if request.post?
#    if User.count.zero?
#      User.new(:name => params[:name],:password => params[:password], :password_confirmation => params[:password]).save;
#    end
#    user = User.authenticate(params[:name],params[:password])
#    if user
#      session[:user_id]= user.id
#      redirect_to(:action=>"index")
#    else
#      flash.now[:notice] = "Invalid user/password combination"
#    end
#  end
#  end
#
#  def logout
#  session[:user_id]=nil
#  flash[:notice]= "Logged out"
#  redirect_to(:action => "login")
#  end
#
#  def index
#      @total_steps=Step.count
#  end
  
end
