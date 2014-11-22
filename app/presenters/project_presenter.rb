class ProjectPresenter < BasePresenter
  presents :project

  delegate :name, :user, :to => :project

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
    project.cached_weighted_average.round(2)
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

  def attachments
    orbitvu_attachments + image_attachments + video_attachments
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

  def logo_image_url
    project.logo.url
  end

  def logo_image_project_list_url
    project.logo.project_list.url
  end

  private
    def video_attachments
      project.video_attachments.map { |video| h.render video }.join.html_safe
    end

    def orbitvu_attachments
      project.orbitvu_attachments.map { |animation| h.render animation }
        .join.html_safe
    end

    def image_attachments
      project.image_attachments.map { |image| h.render image }.join.html_safe
    end
end
