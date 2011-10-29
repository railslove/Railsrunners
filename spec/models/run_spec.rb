require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Run do

  before(:each) do
    @distance = Factory(:distance)
    puts @distance
    @run = Factory(:run)
    @run.distances << @distance
    @run.save
  end

  it { should have_many(:participants) }
  it { should have_many(:distances) }
  it { should belong_to(:user) }

end

