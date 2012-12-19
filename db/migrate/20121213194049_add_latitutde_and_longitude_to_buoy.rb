class AddLatitutdeAndLongitudeToBuoy < ActiveRecord::Migration
  def change
    add_column :buoys, :latitude, :float
    add_column :buoys, :longitude, :float
  end
end
