class CreateDistances < ActiveRecord::Migration
  def change
    create_table :distances do |t|
      t.integer :run_id
      t.float :distance_in_km

      t.timestamps
    end
    
    remove_column :runs, :distance_in_km
    add_column :participants, :distance_id, :integer
  end
end
