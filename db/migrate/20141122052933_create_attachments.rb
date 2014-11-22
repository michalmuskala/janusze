class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :url
      t.string :file
      t.string :type
      t.references :project, index: true

      t.timestamps
    end
  end
end
