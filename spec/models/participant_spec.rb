require 'spec_helper'

describe Participant do

  context 'associations' do
    it { should belong_to :run }
    it { should belong_to :distance }
  end

  describe 'registration' do
    context "with a past run" do

      before(:each) do
        @participant = Participant.new(Factory(:participant).attributes)
        @participant.run.stubs(:past?).returns(true)
        @participant.valid?        
      end
    
      it 'should build a invalid participant object' do
        @participant.should_not be_valid
      end

      it 'should raise a given error for the participant' do
        @participant.errors.full_messages.should include("Run has already took place. You can only register for upcoming runs.")
      end      

    end

    context "with a future run" do

      before(:each) do
        run = Factory(:run)
        @participant = Participant.new(Factory(:participant).attributes)  
        @participant.valid?              
      end

      it 'should build a valid participant object' do
        @participant.should be_valid
      end

    end
    
  end

  describe "accept" do
    
    before(:each) do
      @participant = Participant.new(Factory(:participant).attributes)  
    end

    it 'the confirmed_at attribute should not be nil' do
      @participant.send(:accept)
      @participant.confirmed_at.should_not be nil
    end

  end

  describe "create_result_token" do

    before(:each) do
      @participant = Participant.new(Factory(:participant).attributes)  
    end

    it "the result_token should not be nil" do
      @participant.send(:create_result_token)
      @participant.result_token.should_not be nil      
    end

  end

  describe "send_a_email" do
    
    before(:each) do
      @participant = Participant.new(Factory(:participant).attributes)        
      @mail = mock("Mail", :deliver => true)
    end

    it "should send an email to the participant" do
      ParticipantMailer.should_receive(:result_insert_link).with(@participant).and_return(@mail)
      @participant.save
    end

  end

end
