class CreateBuoyData < ActiveRecord::Migration
  def change
    create_table :buoy_data do |t|
      t.integer :buoy_id
      t.float :wave_height
      t.float :swell_period
      t.integer :swell_direction
      t.float :water_temp
      t.integer :wind_direction

      t.timestamps
    end
  end
end
