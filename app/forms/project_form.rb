class ProjectForm < Reform::Form
  property :name,        on: :project
  property :tag_list,    on: :project
  property :description, on: :project

  property :map_marker do
    property :state,         on: :location
    property :city,          on: :location
    property :street,        on: :location
    property :street_number, on: :location
  end

  collection :video_attachments, populate_if_empty: VideoAttachment do
    property :url, validates: { presence: true }
    property :_destroy
  end

  collection :image_attachments, populate_if_empty: ImageAttachment do
    property :file, validates: { presence: true }
    property :_destroy
  end

  collection :orbitvu_attachments, populate_if_empty: OrbitvuAttachment do
    property :url, validates: { presence: true }
    property :_destroy
  end
end
