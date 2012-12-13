class CreateBuoys < ActiveRecord::Migration
  def change
    create_table :buoys do |t|
      t.string :name
      t.string :coordinates

      t.timestamps
    end
  end
end
