class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password])
      redirect_to root_path, success: t('.success')
    else
      flash.now[:danger] = t('.failed')
      render :new
    end
  end

  def destroy
    logout
    redirect_to login_path, success: t('.success')
  end
end
