class AddMsidToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :msid, :string
  end
end
