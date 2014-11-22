class AddUserToProject < ActiveRecord::Migration
  def change
    add_reference :projects, :user, index: true

    Project.find_each do |project|
      project.user = User.first
      project.save!
    end
  end
end
