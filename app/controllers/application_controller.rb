class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :layout
  add_flash_types :success, :info, :warning, :danger

  protected

  def current_user
    super&.decorate
  end

  private

  def layout
    current_user ? 'application' : 'before_login'
  end
end
