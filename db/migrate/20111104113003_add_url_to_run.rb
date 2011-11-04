class AddUrlToRun < ActiveRecord::Migration
  def change
    add_column :runs, :map_url, :text
  end
end
