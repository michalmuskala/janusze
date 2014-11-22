class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :vote]
  before_action :extract_search_options, :only => [:index]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :vote]

  respond_to :html

  active_page :projects

  def index
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
    @project.video_attachments.build
    @form = ProjectForm.new(@project)
    respond_with(@project)
  end

  def edit
    @form = ProjectForm.new(@project)
  end

  def create
    @project = Project.new
    @project.build_map_marker
    @project.user = current_user
    @form = ProjectForm.new(@project)

    if @form.validate(params[:project])
      @form.save
    end
    respond_with(@project)
  end

  def update
    @form = ProjectForm.new(@project)

    if @form.validate(params[:project])
      @form.save
    end
    respond_with(@project)
  end

  def destroy
    @project.destroy
    respond_with(@project)
  end

  def vote
    @project.vote_by :voter => current_user, :vote_weight => params[:vote].to_f
    redirect_to @project
  end

  def tags
    for_what = :projects # params[:for]
    term = params[:term].chomp(',')

    tags = ::Tags.all_tags_for(for_what, :starting_with => term)
    # unless tags.map{|t| t[:text]}.include? term then
    #   tags = [{
    #     :text => term,
    #     :id => term,
    #     :count => 0
    #   }].concat(tags)
    # end

    render :json => {
      :tags => tags
    }
  end

  private
    def set_project
      @project = Project.find(params[:id])
      @project.map_marker || @project.build_map_marker
    end

    def project_params
      params.require(:project)
            .permit(:name, :description, :tag_list, map_marker: [:state, :city, :street, :street_number])
    end

    NullSearchOption = Naught.build do |config|
      config.black_hole
      config.predicates_return false
      config.define_implicit_conversions

      def to_s; to_str; end
    end

    def index_search_query
      {}.merge(generate_query).merge(generate_filters).merge(generate_facets).merge(generate_highlights)
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
      current_search_options[:tags]  = params[:tags].split(',').map(&:downcase).uniq if params[:tags]
      current_search_options[:state] = params[:state].split(',').map(&:downcase).uniq if params[:state]
    end

    def generate_query
      @query ||= begin
        if (query = current_search_options[:query]).present?
          {
            :query => {
              :bool => {
                :should => [
                  :fuzzy => {
                    :name => query
                  },
                  :fuzzy => {
                    :description_blurb => query
                  }
                ]
              }
            }
          }
        else
          { :query => { :match_all => {} } }
        end
      end
    end

    def generate_filters
      @filters ||= begin
        filters = [tag_filter, state_filter]

        {
          :filter => filters.filter(&:present?).fold({}) do |acc, filter|
                       filter.each do |type, value|
                         acc[type] = (acc[type] || []).concat(Array.wrap(value))
                       end
                       acc
                     end
        }
      end
    end

    def generate_facets
      @facets ||= {
        :facets => {
          :tags => {
            :terms => {
              :field => 'tags.name'
            },
            :nested => 'tags'
          },
          :state => {
            :terms => {
              :field => 'address.state'
            },
            :nested => 'address'
          }
        }
      }
    end

    def generate_highlights
      {}
    end

    def tag_filter
      if (tags = current_search_options[:tags]).present?
        {
          :and => [
            {
              :nested => {
                :path => 'tags',
                :filter => {
                  :terms => { :'tags.name' => tags }
                }
              }
            }
          ]
        }
      end
    end

    def state_filter
      if (states = current_search_options[:state]).present?
        {
          :and => [
            {
              :nested => {
                :path => 'address',
                :filter => {
                  :terms => { :'address.state' => states.map { |code| ProjectLocation.code_to_state_name_downcased(code) } }
                }
              }
            }
          ]
        }
      end
    end
end
