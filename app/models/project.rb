# == Schema Information
#
# Table name: projects
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  description             :text
#  created_at              :datetime
#  updated_at              :datetime
#  projected_cost          :decimal(19, 2)
#  user_id                 :integer
#  logo                    :string(255)
#  cached_votes_total      :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_votes_down       :integer          default(0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#
# Indexes
#
#  index_projects_on_cached_votes_down        (cached_votes_down)
#  index_projects_on_cached_votes_score       (cached_votes_score)
#  index_projects_on_cached_votes_total       (cached_votes_total)
#  index_projects_on_cached_votes_up          (cached_votes_up)
#  index_projects_on_cached_weighted_average  (cached_weighted_average)
#  index_projects_on_cached_weighted_score    (cached_weighted_score)
#  index_projects_on_cached_weighted_total    (cached_weighted_total)
#  index_projects_on_user_id                  (user_id)
#

class Project < ActiveRecord::Base
  include Elasticsearch::Model

  acts_as_taggable
  acts_as_commentable
  acts_as_votable

  has_one :map_marker, class_name: "ProjectLocation"
  has_many :video_attachments, autosave: true
  has_many :image_attachments, autosave: true
  has_many :orbitvu_attachments, autosave: true
  belongs_to :user

  mount_uploader :logo, LogoImageUploader

  def address
    map_marker.try(:address) || "None"
  end

  mapping do
    indexes :id,                :type => :integer, :index => 'not_analyzed'
    indexes :name,              :type => :string

    indexes :tags,              :type => :nested do
      indexes :name, :type => :string

    end
    indexes :description_blurb, :type => :string
    indexes :rating,            :type => :float

    indexes :address,           :type => :nested do
      indexes :state,         :type => :string
      indexes :city,          :type => :string
      indexes :street,        :type => :string
      indexes :street_number, :type => :string
    end

    indexes :created_at,        :type => :date
    indexes :updated_at,        :type => :date
  end

  def as_indexed_json(options={})
    presenter = ProjectPresenter.new(self, ActionController::Base.helpers)

    {
      :id                => self.id,
      :name              => self.name,
      :tags              => self.tags.map { |tag| { :name => tag.name } },
      :description_blurb => presenter.description_first_paragraph,
      :rating            => presenter.rating,
      :created_at        => self.created_at,
      :updated_at        => self.updated_at,
      :address           => (({
        :state             => self.map_marker.state,
        :city              => self.map_marker.city,
        :street            => self.map_marker.street,
        :street_number     => self.map_marker.street_number
      }) if self.map_marker.present?)
    }
  end

  after_commit :index_callback, :if => :persisted?
  after_commit :delete_from_index_callback, :on => :destroy

  def index_callback
    self.__elasticsearch__.index_document
  end

  def delete_from_index_callback
    self.__elasticsearch__.delete_document
  end
end
