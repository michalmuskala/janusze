# == Schema Information
#
# Table name: project_locations
#
#  id            :integer          not null, primary key
#  state         :string(255)
#  city          :string(255)
#  street        :string(255)
#  street_number :string(255)
#  longitude     :float
#  latitude      :float
#  project_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_project_locations_on_project_id  (project_id)
#

class ProjectLocation < ActiveRecord::Base
  belongs_to :project

  geocoded_by :address
  after_validation :geocode

  def address
    [state, city, "#{street} #{street_number}"].reject(&:blank?).join(', ')
  end

  def coords
    {lat: latitude, lng: longitude}
  end
end
