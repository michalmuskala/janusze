class HomeController < ApplicationController
  # layout 'homepage_special'
  active_page :home

  def index
    @projects = Project.order(created_at: :desc).first(4)
  end
end
