class ParticipantMailer < ActionMailer::Base
  default from: 'no-reply@railsrunners.org'

  def result_insert_link(participant)
    @participant = participant
    mail(:to => @participant.email, :subject => "Your result link for run on #{@participant.run.visual_name}")
  end
end
