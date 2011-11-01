require 'spec_helper'

describe RunsController do
  render_views

  describe 'GET index' do
    before :each do
      @distance1 = Factory(:distance, :distance_in_km => 3)
      @distance2 = Factory(:distance, :distance_in_km => 4)
      @run = Factory(:run, :distances => [@distance1, @distance2])
      @run.reload
      @distance1.reload
      @distance2.reload
    end

    it 'is successful' do
      get :index
      response.should be_success
    end

    it 'shows runs' do
      get :index
      response.body.should include(@run.visual_name)
    end
  end

  describe 'GET new' do
    before :each do
      @user = Factory(:user)
      sign_in :user, @user
    end

    it 'is successful' do
      get :new
      response.should be_success
    end
  end

  describe 'POST create' do
    before :each do
      @user = Factory(:user)
      sign_in :user, @user
    end

    it 'saves a run' do
      lambda {
        later = 3.days.from_now
        post :create, :run => {:name => 'Run to the Hills', :url => 'http://www.ironmaiden.com/', :charity => 'ChildLine', :charity_url => 'http://www.childline.org.uk/Pages/Home.aspx',
          "start_at(1i)"=>later.year.to_s, #year
          "start_at(2i)"=>later.month.to_s, # month
          "start_at(3i)"=>later.day.to_s, # day
          "start_at(4i)"=>later.hour.to_s, # hour
          "start_at(5i)"=>later.min.to_s, # minutes
          :distances_attributes => [{"distance_in_km"=>"4.4"}]
        }
        response.should redirect_to root_path
      }.should change(Run, :count).by(1)
    end

    it 'returns to the form on missing data' do
      lambda {
        earlier = 3.days.ago
        # missing distances + date in the past (check Run model specs for that)
        post :create, :run => {:name => 'Run to the Hills', :url => 'http://www.ironmaiden.com/', :charity => 'ChildLine', :charity_url => 'http://www.childline.org.uk/Pages/Home.aspx',
          "start_at(1i)"=>earlier.year.to_s, #year
          "start_at(2i)"=>earlier.month.to_s, # month
          "start_at(3i)"=>earlier.day.to_s, # day
          "start_at(4i)"=>earlier.hour.to_s, # hour
          "start_at(5i)"=>earlier.min.to_s} # minutes
        response.should render_template :new
      }.should_not change(Run, :count)
    end
  end
end
