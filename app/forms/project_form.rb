class ProjectForm < Reform::Form
  property :name,        on: :project, validates: { presence: true }
  property :tag_list,    on: :project
  property :description, on: :project, validates: { presence: true }
  property :logo,        on: :project, validates: { presence: true }

  property :map_marker do
    property :state,         on: :location, validates: { presence: true }
    property :city,          on: :location, validates: { presence: true }
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
