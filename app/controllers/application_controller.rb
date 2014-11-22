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

  public def controller_name(*args)
    format = args[0]
    name = @overriden_controller_name || super()
    case format
      when :css, 'css'
        "#{name.dasherize}-controller"
      else
        name
    end
  end

  public def action_name(*args)
    format = args[0]
    case format
      when :css, 'css'
        "#{super().dasherize}-action"
      else
        super()
    end
  end

  def override_controller_name(name)
    @overriden_controller_name = name
  end
end
