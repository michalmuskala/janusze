class ProjectPresenter < BasePresenter
  presents :project

  delegate :name, to: :project

  def description
    h.simple_format project.description
  end

  def tags
    project.tags.map(&:name).join(', ')
  end

  def comments
    project.root_comments.map { |comment| h.render comment }.join.html_safe
  end

  def show_link
    h.link_to 'Show', project
  end

  def edit_link
    h.link_to 'Edit', h.edit_project_path(project)
  end

  def destroy_link
    h.link_to 'Destroy', project,
              data: { confirm: 'Are you sure?' }, method: :delete
  end
end
