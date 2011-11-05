require 'spec_helper'

describe Participant do
  describe 'associations' do
    it { should belong_to :run }
    it { should belong_to :distance }
  end

  describe 'registration' do
    it 'cannot happen for a past race' do
      run = Factory(:run, :distances => [Factory(:distance)])
      run.update_attribute(:start_at, 3.days.ago)

      participant = Participant.new(:email => 'combine_072@our.benefacto.rs')
      participant.run = run
      participant.should_not be_valid
      participant.errors[:run].should_not be_empty
    end
  end
end
