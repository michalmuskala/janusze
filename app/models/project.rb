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
  has_one :map_marker, class_name: "ProjectLocation"

  acts_as_taggable
  acts_as_commentable

  def address
    map_marker.try(:address) || "None"
  end
end
