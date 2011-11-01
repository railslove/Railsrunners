class MoveWhenToStartAt < ActiveRecord::Migration
  def change
  	rename_column :runs, :when, :start_at
  end
end
