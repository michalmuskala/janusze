class AddCostToProject < ActiveRecord::Migration
  def change
    add_column :projects, :projected_cost, :money
  end
end
