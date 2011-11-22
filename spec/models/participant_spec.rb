require 'spec_helper'

describe Participant do

  context 'associations' do

    it { should belong_to :run }

    it { should belong_to :distance }

  end

  describe 'registration' do

    it 'cannot happen for a past race' do
      run = Factory(:run, :distances => [Factory(:distance)])
      # TODO mock the past attribute [Jan, 22.11.2011]
      run.update_attribute(:start_at, 3.days.ago)
      participant = Participant.new(:email => 'combine_072@our.benefacto.rs', :run => run)
      # TODO two assertions - split the tests [Jan, 22.11.2011]
      participant.should_not be_valid
      participant.errors[:run].should_not be_empty
    end

  end
end
