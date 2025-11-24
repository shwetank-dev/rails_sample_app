class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)

    if @user && @user.authenticate(params[:session][:password])
      reset_session
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      log_in @user
      flash[:info] = "Welcome #{@user.name}, you have logged in"
      redirect_to @user
    else
      flash.now[:danger] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    flash[:info] = "You have logged out succesfully"
    redirect_to root_path, status: :see_other
  end
end
