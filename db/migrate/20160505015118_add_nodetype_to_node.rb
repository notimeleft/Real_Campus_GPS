class AddNodetypeToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :nodetype, :integer
  end
end
