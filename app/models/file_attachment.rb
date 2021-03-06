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

class FileAttachment < Attachment
  validate :url, absence: true
  validate :file, presence: true
end
