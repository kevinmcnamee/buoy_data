class RemoveDateFromBuoyData < ActiveRecord::Migration
  def up
    remove_column :buoy_data, :date
  end

  def down
  end
end
