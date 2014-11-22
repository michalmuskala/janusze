# == Schema Information
#
# Table name: projects
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :text
#  created_at     :datetime
#  updated_at     :datetime
#  projected_cost :decimal(19, 2)
#  user_id        :integer
#
# Indexes
#
#  index_projects_on_user_id  (user_id)
#

class Project < ActiveRecord::Base
  include Elasticsearch::Model

  acts_as_taggable
  acts_as_commentable

  has_one :map_marker, class_name: "ProjectLocation"
  has_many :video_attachments, autosave: true
  has_many :image_attachments, autosave: true
  has_many :orbitvu_attachments, autosave: true
  belongs_to :user

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
