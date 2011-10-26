class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.integer :user_id
      t.string :name
      t.float :distance_in_km
      t.string :url
      t.string :charity
      t.string :charity_url
      t.datetime :when
      t.text :notes

      t.timestamps
    end
  end
end
