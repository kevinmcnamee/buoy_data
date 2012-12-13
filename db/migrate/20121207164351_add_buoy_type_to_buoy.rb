class AddBuoyTypeToBuoy < ActiveRecord::Migration
  def change
    add_column :buoys, :buoy_type, :string
  end
end
