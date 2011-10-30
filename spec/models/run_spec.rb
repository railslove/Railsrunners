require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Run do

  before(:each) do
    @distance = Factory(:distance)
    @madrid_run = Factory.build(:run)
    @madrid_run.distances << @distance
    @madrid_run.save

    @distances = []
    5.times do |i|
      @distances << Factory(:distance, :distance_in_km => i+1)
    end
    @hamburg_run =  Factory.build(:run)
    @hamburg_run.distances << @distances
    @hamburg_run.save
  end

  it { should have_many(:participants) }
  it { should have_many(:distances) }
  it { should belong_to(:user) }

  it "should return its visual name" do
    assert "My super duper run 5 km", @madrid_run.visual_name 
  end

  it "should return its visual name if many distances" do
    assert "My super duper run 1 km", @hamburg_run.visual_name 
  end

  it "should return the proper distances in km only with one distance" do
    assert "5 km", @madrid_run.distances_in_km
  end

  it "should return the proper distances in km with more than one distance" do
    assert "1 km - 5 km", @hamburg_run.distances_in_km
  end

end

