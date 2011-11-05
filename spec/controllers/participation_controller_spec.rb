require 'spec_helper'

describe ParticipationController do
  render_views

  describe 'GET new' do
    before :each do
      @distance1 = Factory(:distance, :distance_in_km => 3)
      @distance2 = Factory(:distance, :distance_in_km => 4)
      @run = Factory(:run, :distances => [@distance1, @distance2])
      @run.reload
      @distance1.reload
      @distance2.reload
    end

    it 'is successful' do
      get :new
      response.should be_success
    end
  end

  describe 'POST create' do
    before :each do
      @distance = Factory(:distance)
      @run = Factory(:run, :distances => [@distance])
      @run.reload
      @distance.reload
    end

    it 'saves a participant' do
      lambda {
        post :create, :participant => {:run_id => @run.id, :distance_id => @distance.id, :name => 'Twilight Dash'}
        response.should redirect_to runs_url
      }.should change(Participant, :count).by(1)
    end

    it 'returns to the form on missing data' do
      post :create, :participant => {:name => 'Twilight Dash'}
      response.should be_success
      response.should render_template :new
    end
  end
end
