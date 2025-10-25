class ApplicationController < ActionController::Base
  before_action :set_locale
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  def change_locale
    I18n.locale = params[:locale]
    cookies[:locale] = I18n.locale
    redirect_to request.referer || root_path
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def set_locale
    I18n.locale = cookies[:locale] || I18n.default_locale
  end
end