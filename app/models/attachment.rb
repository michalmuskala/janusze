# == Schema Information
#
# Table name: attachments
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  file       :string(255)
#  type       :string(255)
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_attachments_on_project_id  (project_id)
#

class Attachment < ActiveRecord::Base
  belongs_to :project

  def _destroy=(value)
    mark_for_destruction if value == '1'
  end
end
