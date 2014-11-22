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

class OrbitvuAttachment < UrlAttachment
  IMAGE_URL = "//static.orbitvu.co/001/%s/iproc/img01.png?max_width=%d&height=%d".freeze
  SCRIPT_URL = "//orbitvu.co/001/%s/ov3601/3/script?width=auto&content2=yes&height=auto&viewer_uid=xl%d".freeze

  def orbitvu_id
    URI.parse(url).path.split('/').last
  end

  def image(width: 360, height: 200)
    IMAGE_URL % [orbitvu_id, width, height]
  end

  def script
    SCRIPT_URL % [orbitvu_id, id]
  end
end
