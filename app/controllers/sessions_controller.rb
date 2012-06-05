class SessionsController < ApplicationController
  def new
    @title = "Log in"
    respond_to do |format|
      format.html {}
      format.js { render 'new' }
    end
  end
  
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination"
      @title = "Log in"
      render 'new'
    else
      remember_me = params[:session][:remember_me] == "1"
      sign_in(user, remember_me)
      redirect_to user
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

end
