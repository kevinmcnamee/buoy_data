class AddTimeToBuoyData < ActiveRecord::Migration
  def change
    add_column :buoy_data, :time, :string
  end
end
