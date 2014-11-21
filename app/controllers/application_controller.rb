class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def self.active_page(page)
    before_action lambda { @page = page }
  end

  private

  def active_page(page)
    @page = page
  end

  def active_page?(page)
    @page == page
  end
  helper_method :active_page?
end
