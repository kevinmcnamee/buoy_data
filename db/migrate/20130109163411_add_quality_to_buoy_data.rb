class AddQualityToBuoyData < ActiveRecord::Migration
  def change
    add_column :buoy_data, :quality, :integer
  end
end
