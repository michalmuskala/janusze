class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :html

  active_page :projects

  def index
    binding.pry
    @projects = Project.search(index_search_query)
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
      @project.map_marker || @project.build_map_marker
    end

    def project_params
      params
        .require(:project)
        .permit(:name, :description, :tag_list, map_marker: [:state, :city, :street, :street_number])
    end

    NullSearchOption = Naught.build do |config|
      config.black_hole
      config.predicates_return false
      config.define_implicit_conversions

      def to_s; to_str; end
    end

    def index_search_query
      {}.merge(generate_query) #.merge(generate_filters).merge(generate_facets).merge(generate_highlights)
    end

    class SearchOptionHash < Hash
      def [](idx)
        super(idx) || NullSearchOption.new
      end
    end

    def current_search_options
      @current_search_options ||= SearchOptionHash.new
    end
    helper_method :current_search_options

    def extract_search_options
      current_search_options[:query] = params[:query] if params[:query]
    end

    def generate_query
      @query ||= begin
        if (query = current_search_options[:query]).present?
          { :query => { :fuzzy => { :summary => query } } }
        else
          { :query => { :match_all => {} } }
        end
      end
    end
end
