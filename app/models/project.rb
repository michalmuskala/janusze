# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Project < ActiveRecord::Base
  include Elasticsearch::Model

  acts_as_taggable
  acts_as_commentable

  has_one :map_marker, class_name: "ProjectLocation"
  has_many :video_attachments
  has_many :image_attachments
  has_many :orbitvu_attachments

  def address
    map_marker.try(:address) || "None"
  end

  mapping do
    indexes :id,                :type => :integer, :index => 'not_analyzed'
    indexes :name,              :type => :string
    indexes :tags,              :type => :string
    indexes :description_blurb, :type => :string
    indexes :rating,            :type => :float
    indexes :created_at,        :type => :date
    indexes :updated_at,        :type => :date
  end

  def as_indexed_json(options={})
    presenter = ProjectPresenter.new(self, ActionController::Base.helpers)

    {
      :id                => self.id,
      :name              => self.name,
      :tags              => presenter.tag_names,
      :description_blurb => presenter.description_first_paragraph,
      :rating            => presenter.rating,
      :created_at        => self.created_at,
      :updated_at        => self.updated_at
    }
  end
end
