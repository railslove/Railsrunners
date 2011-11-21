require 'spec_helper'

describe ParticipantsController do
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

  describe 'GET edit' do
    before :each do
      @distance = Factory(:distance)
      @run = Factory(:run, :distances => [@distance])
      @run.stubs(:past?).returns(true)
      @participant = Factory.build(:participant, :run => @run, :distance => @distance)
      @participant.stubs(:cannot_participate_in_past_run)
      @participant.save
      Participant.expects(:find_by_result_token).returns(@participant)    
    end

    it 'is successful' do
      get :edit, :id => @participant.id, :token => @participant.result_token
      response.should be_success
    end
  end

  describe 'PUT create' do
    before :each do
      @distance = Factory(:distance)
      @run = Factory(:run, :distances => [@distance])
      @run.stubs(:past?).returns(true)
      @participant = Factory.build(:participant, :run => @run, :distance => @distance)
      @participant.stubs(:cannot_participate_in_past_run)
      @participant.save
      Participant.expects(:find_by_result_token).returns(@participant)      
    end

    it 'updates a participant' do
      put :update, :id => @participant.id, :token => @participant.result_token, :participant => {:run_id => @participant.run.id, :distance_id => @distance.id, :name => 'Twilight Dash'}
      response.should redirect_to runs_url
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
