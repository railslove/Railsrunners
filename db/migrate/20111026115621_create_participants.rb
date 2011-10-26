class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.integer :run_id
      t.string :name
      t.integer :time
      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
