class AddResultTokenToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :result_token, :string
  end
end
