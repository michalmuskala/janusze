class CreateProjectLocations < ActiveRecord::Migration
  def change
    create_table :project_locations do |t|
      t.string :state
      t.string :city
      t.string :street
      t.string :street_number
      t.float :longitude
      t.float :latitude
      t.references :project, index: true

      t.timestamps
    end
  end
end
