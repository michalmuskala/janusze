class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :html

  active_page :projects

  def index
    @projects = Project.all
    respond_with(@projects)
  end

  def show
    @marker = @project.map_marker.coords
    respond_with(@project)
  end

  def new
    @project = Project.new
    @project.build_map_marker
    @form = ProjectForm.new(@project)
    respond_with(@project)
  end

  def edit
    @form = ProjectForm.new(@project)
  end

  def create
    @project = Project.new
    @project.build_map_marker
    @form = ProjectForm.new(@project)

    if @form.validate(params[:project])
      @form.save
      respond_with(@project)
    end
  end

  def update

    @form = ProjectForm.new(@project)

    if @form.validate(params[:project])
      @form.save
      respond_with(@project)
    end
  end

  def destroy
    @project.destroy
    respond_with(@project)
  end

  private

  def set_project
    @project = Project.find(params[:id])
    @project.try(:map_marker) || @project.build_map_marker
  end

  def project_params
    params
      .require(:project)
      .permit(:name, :description, :tag_list, map_marker: [:state, :city, :street, :street_number])
  end
end
