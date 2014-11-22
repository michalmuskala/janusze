class ProjectPresenter < BasePresenter
  presents :project

  delegate :name, :to => :project

  def description
    self.class.markdown_render(project.description)
  end

  def description_blurb
    h.truncate_html(description, :length => 512)
  end

  def description_first_paragraph
    Nokogiri::HTML.parse(description).css('p').first.to_s.html_safe
  end

  def link(text = project.name)
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
    project.root_comments.ordered
      .map { |comment| h.render comment }.join.html_safe
  end

  def address
    project.address.blank? ? "None" : project.address
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
