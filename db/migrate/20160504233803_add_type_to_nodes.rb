class AddTypeToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :type, :integer
  end
end
