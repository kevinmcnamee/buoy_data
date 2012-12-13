class AddDateToBuoyData < ActiveRecord::Migration
  def change
    add_column :buoy_data, :date, :string
  end
end
