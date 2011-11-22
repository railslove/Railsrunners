require 'spec_helper'

describe ParticipantsController do
  render_views

  describe '#new' do
    before :each do
      # TODO [Jan, 22.11.11]      
      # throw it away to run - factory
      # @run = Factory(:run)
      @distance1 = Factory(:distance, :distance_in_km => 3)
      @distance2 = Factory(:distance, :distance_in_km => 4)
      @run = Factory(:run, :distances => [@distance1, @distance2])
    end

    it 'is successful' do
      get :new
      response.should be_success
    end

    it 'render the new template' do
      get :new
      response.should render_template("new")
    end

  end

  describe '#edit' do
    before :each do
      # TODO maybe we look into the code because the tests doesn't looks good ;) [Jan, 22.11.11]      
      @run = Factory(:run, :distances => [Factory(:distance)])
      @run.stubs(:past?).returns(true)
      @participant = Factory.build(:participant, :run => @run, :distance => @run.distances.first)
      @participant.stubs(:cannot_participate_in_past_run)
      @participant.save
      Participant.expects(:find_by_result_token).returns(@participant)    
    end

    it 'is successful' do
      get :edit, :id => @participant.id, :token => @participant.result_token
      response.should be_success
    end

    it 'render the edit template' do
      get :edit, :id => @participant.id, :token => @participant.result_token
      response.should render_template("edit")
    end

  end

  describe '#update' do
    before :each do
      # TODO maybe we look into the code because the tests doesn't looks good ;) [Jan, 22.11.11]
      @distance = Factory(:distance)
      @run = Factory(:run, :distances => [@distance])
      @run.stubs(:past?).returns(true)
      @participant = Factory.build(:participant, :run => @run, :distance => @run.distances.first)
      @participant.stubs(:cannot_participate_in_past_run)
      @participant.save
      Participant.expects(:find_by_result_token).returns(@participant)      
    end

    it 'updates a participant' do
      put :update, :id => @participant.id, :token => @participant.result_token, :participant => {:run_id => @participant.run.id, :distance_id => @distance.id, :name => 'Twilight Dash'}
      response.should redirect_to runs_url
    end

  end

  describe '#create' do

    before :each do
      @run = Factory(:run, :distances => [Factory(:distance)])
    end

    context "when params valid" do
  
      it 'creates a participant' do
        lambda {
          post :create, :participant => {:run_id => @run.id, :distance_id => @run.distances.first.id, :name => 'Twilight Dash'}
        }.should change(Participant, :count).by(1)
      end

      it 'redirects to runs url' do
        post :create, :participant => {:run_id => @run.id, :distance_id => @run.distances.first.id, :name => 'Twilight Dash'}
        response.should redirect_to runs_url
      end

      it 'returns successfuly the new form on missing data' do
        post :create, :participant => {:name => 'Twilight Dash'}
        response.should be_success
      end      

    end

    context "when params valid" do
  
      it 'creates no new participant' do
        lambda {
          post :create, :participant => {:name => 'Twilight Dash'}      
        }.should change(Participant, :count).by(0)
      end

      it 'render the new template on missing data' do
        post :create, :participant => {:name => 'Twilight Dash'}      
        response.should render_template("new")
      end

      it 'returns successfuly the new form on missing data' do
        post :create, :participant => {:name => 'Twilight Dash'}
        response.should be_success
      end      

    end

  end
end
