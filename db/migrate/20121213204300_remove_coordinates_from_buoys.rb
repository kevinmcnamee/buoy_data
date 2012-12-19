class RemoveCoordinatesFromBuoys < ActiveRecord::Migration
  def up
    remove_column :buoys, :coordinates
  end

  def down
    add_column :buoys, :coordinates, :string
  end
end
