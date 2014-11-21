class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def active_page(page)
    @page = page
  end

  def active_page?(page)
    @page == page
  end
  helper_method :active_page?

  def home
    active_page :home
  end
end
