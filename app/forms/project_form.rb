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
end