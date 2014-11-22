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

class VideoAttachment < UrlAttachment

  def video_id
    Rack::Utils.parse_query(URI.parse(url).query)['v']
  end
end
