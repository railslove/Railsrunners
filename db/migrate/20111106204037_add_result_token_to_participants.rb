class AddResultTokenToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :result_token, :string
    Participant.all.each do |participant|
      participant.send(:create_result_token)
      participant.save(:validate => false)
      participant.send(:send_an_email)
    end
  end
end
