class ApplicationController < ActionController::Base
  before_action :ensure_user_token
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def hello
    render html: "hello, world!"
  end

  private
  def ensure_user_token
    return if session[:user_token].present?

    cookies.signed[:user_token] = {
      value: SecureRandom.uuid,
      expires: 20.years.from_now,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax,
    }
  end
end  
