class ShellsController < ApplicationController
  # before_filter :is_founder?, :except => [:new]
  skip_before_filter :shell_authenticate
  
  def new
    @title = "Sign in"
  end
  
  def create
    user = User.authenticate_founder(params[:shell][:email],
                                     params[:shell][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination"
      @title = "Sign in"
      render 'new'
    else
      sign_into_shell user
      redirect_to root_path
    end
  end
  
  def destroy
    shell_sign_out
    redirect_to root_path
  end
end
