require "spec_helper"

describe ParticipantMailer do

    before do
      @participant = Factory(:participant)
      @mail = ParticipantMailer.result_insert_link(@participant)
    end

    it 'should set the proper subject' do
      @mail.subject.force_encoding("UTF-8").should == "Your result link for run on #{@participant.run.visual_name}"
    end

end
