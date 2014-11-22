class HTMLWithPants < Redcarpet::Render::HTML
  include Redcarpet::Render::SmartyPants
end

class ProjectPresenter < BasePresenter
  presents :project

  delegate :name, :to => :project

  def description
    markdown_render.render(project.description).html_safe
  end

  def description_blurb
    h.truncate_html(description, :length => 512)
  end

  protected def markdown_render
    @markdown_renderer ||= Redcarpet::Markdown.new(HTMLWithPants.new)
  end

  def link(text=nil)
    text ||= project.name
    h.link_to(text, project)
  end

  def user_name
    user.name
  end

  def user_profile_link
    h.link_to(user_name, user)
  end

  def rating
    @rating ||= Random.rand(2.0..6.0).round(2)
  end

  protected def user
    User.first
  end

  def tags
    project.tags
  end

  def tag_names
    tags.map(&:name)
  end

  def comments
    project.root_comments.map { |comment| h.render comment }.join.html_safe
  end

  def show_link
    h.link_to('Show', project)
  end

  def edit_link
    h.link_to('Edit', h.edit_project_path(project))
  end

  def destroy_link
    h.link_to('Destroy', project, :data => { :confirm => 'Are you sure?' }, :method => :delete)
  end
end
