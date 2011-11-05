require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Run do

  it { should have_many(:participants) }
  it { should have_many(:distances) }
  it { should belong_to(:user) }

  describe 'scopes' do

      before(:each) do
        @distance = Factory(:distance)
        @past_run = Factory.build(:run, :start_at => 3.days.ago)
        @future_run = Factory.build(:run, :start_at => Time.now + 3.days)
        @past_run.distances << @distance
        @future_run.distances << @distance
        @past_run.save(:validate => false)
        @future_run.save
      end

    it 'should get runs in the past' do
      Run.past.should include @past_run
      Run.past.should_not include @future_run          
    end

    it 'should get runs in the future' do
      Run.registerable.should include @future_run
      Run.registerable.should_not include @past_run    
    end
  end
  
  describe 'validations' do
    it 'does not allow to create an event in past' do
      run = Run.new(:start_at => 3.days.ago)
      run.valid?
      run.errors.full_messages.should include("You can't add a run in past")
    end

    it 'does not allow missing name, user and distances or start_at' do
      run = Run.new
      run.valid?
      [:user, :name, :distances, :start_at].each do |field|
        run.errors[field].should include "can't be blank"
      end
    end

    it 'does not allow any other values than url for url fields' do
      run = Run.new(:url => "blabla.com", :charity_url => "blubli.com")      
      run.valid?
      [:url, :charity_url].each do |field|
        run.errors[field].should include "is invalid"
      end
    end
 
     it 'should be an google maps' do
      obviously_not_a_maps_url = 'not_a_url just some random string'
      run = Run.new(:url => "http://blabla.com", :charity_url => "http://blubli.com", :map_url => obviously_not_a_maps_url) 
      run.valid?
      run.errors[:map_url].should include "This isn't a google maps url"
     end

     it 'shouldnt be validated if no address is given' do
      run = Run.new(:url => "http://blabla.com", :charity_url => "http://blubli.com") 
      run.valid?
      run.errors[:map_url].should_not include "This isn't a google maps url"
     end

      it 'shouldnt be validated if no address is given' do
        run = Run.new(:url => "http://blabla.com", :charity_url => "http://blubli.com", :map_url => "http://maps.google.com/a_fucking_cool_map") 
        run.valid?
        run.errors[:map_url].should_not include "This isn't a google maps url"
     end
  end

  describe 'integer distances in visual_name' do

    describe 'with only one distance' do
      before(:each) do
        @distance = Factory(:distance)
        @madrid_run = Factory.build(:run)
        @madrid_run.distances << @distance
        @madrid_run.save
      end

      it "should return its visual name" do
        @madrid_run.visual_name.should eq "My super duper run (5 km)"
      end

      it "should return the proper distances in km" do
        @madrid_run.distances_in_km.should eq "5 km"
      end

      it "should return the proper distances in miles" do
        # 5 km =~ 3.11 mi
        @madrid_run.distances_in_mi.should eq "3.11 mi"
      end
    end

    describe 'with many distances' do

      before(:each) do
        @distances = []
        5.times do |i|
          @distances << Factory(:distance, :distance_in_km => i+1)
        end
        @hamburg_run =  Factory.build(:run)
        @hamburg_run.distances << @distances
        @hamburg_run.save
      end

      it "should return its visual name" do
        @hamburg_run.visual_name.should eq("My super duper run (1 km - 5 km)")
      end

      it "should return the proper distances in km" do
        @hamburg_run.distances_in_km.should eq "1 km - 5 km"
      end
    end
  end

  describe 'float distances in visual_name' do

    describe 'with only one distance' do
      before(:each) do
        @distance = Factory(:distance, :distance_in_km => 5.5)
        @madrid_run = Factory.build(:run)
        @madrid_run.distances << @distance
        @madrid_run.save
      end

      it "should return its visual name" do
        @madrid_run.visual_name.should eq "My super duper run (5.5 km)"
        @madrid_run.visual_name('mi').should eq "My super duper run (3.42 mi)"
      end

      it "should return the proper distances" do
        @madrid_run.distances_in_km.should eq "5.5 km"
        # 5.5 km =~ 3.42 mi
        @madrid_run.distances_in_mi.should eq "3.42 mi"
      end
    end

    describe 'with many distances' do

      before(:each) do
        @distances = []
        5.times do |i|
          @distances << Factory(:distance, :distance_in_km => i+1.5)
        end
        @hamburg_run =  Factory.build(:run)
        @hamburg_run.distances << @distances
        @hamburg_run.save
      end

      it "should return its visual name" do
        @hamburg_run.visual_name.should eq("My super duper run (1.5 km - 5.5 km)")
        @hamburg_run.visual_name('mi').should eq("My super duper run (0.93 mi - 3.42 mi)")
      end

      it "should return the proper distances" do
        @hamburg_run.distances_in_km.should eq "1.5 km - 5.5 km"
        # 1.5 km =~ 0.93 mi
        # 5.5 km =~ 3.42 mi
        @hamburg_run.distances_in_mi.should eq "0.93 mi - 3.42 mi"
      end
    end
  end

end

