class AddUrlToBuoys < ActiveRecord::Migration
  def change
    add_column :buoys, :url, :string
  end
end
