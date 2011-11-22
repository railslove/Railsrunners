require 'spec_helper'

describe RunsController do
  render_views

  describe '#index' do
    before :each do
      @distance1 = Factory(:distance, :distance_in_km => 3)
      @distance2 = Factory(:distance, :distance_in_km => 4)
      @run = Factory(:run, :distances => [@distance1, @distance2])
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

    describe '#results' do
      before :each do
        distance1 = Factory(:distance, :distance_in_km => 3)
        distance2 = Factory(:distance, :distance_in_km => 4)
        @run = Factory.build(:run, :distances => [distance1, distance2], :start_at => Time.now-3.days)
        @run.save(:validate => false)
      end

    it 'is successful' do
      get :results
      response.should be_success
    end

    it 'shows runs' do
      get :results
      response.body.should include(@run.visual_name)
    end
  end

  describe '#new' do
    before :each do
      @user = Factory(:user)
      sign_in :user, @user
    end

    it 'is successful' do
      get :new
      response.should be_success
    end
  end

  describe 'edit as owner' do
    before :each do
      @user = Factory(:user)
      distance = Factory(:distance, :distance_in_km => 3)      
      @run = Factory(:run, :distances => [distance], :user => @user)
      sign_in :user, @user
    end

    it 'is successful' do
      get :edit, :id => @run.id
      response.should be_success
    end

  end
  
  describe 'GET edit not as an owner' do
    before :each do
      @user = Factory(:user)
      distance = Factory(:distance, :distance_in_km => 3)      
      @run = Factory(:run, :distances => [distance])
      sign_in :user, @user
    end

    it 'is not successful' do
      lambda{ 
        get :edit, :id => @run.id 
      }.should raise_error(ActiveRecord::RecordNotFound)
    end

  end

  describe '#update' do
    before :each do
      @user = Factory(:user)
      distance = Factory(:distance, :distance_in_km => 3)      
      @run = Factory(:run, :distances => [distance], :user => @user)
      sign_in :user, @user
    end

    it 'should be udpated' do
      put :update, :id => @run.id, :run => {:name => 'Run to the Hills Railscamp Spanish'}
      @run.reload
      response.should(redirect_to(runs_url))
      @run.name.should == "Run to the Hills Railscamp Spanish"
    end

    it 'should not be udpated' do
      put :update, :id => @run.id, :run => {:name => ''}
      response.should render_template :edit
    end
  end

  describe '#create' do

    before :each do
      @user = Factory(:user)
      sign_in :user, @user
      @run = Factory.build(:run, :distances => [Factory(:distance)])
      controller.stub!(:current_user).and_return(@user)          
      @user.stub_chain(:runs, :build).and_return(@run)
    end

    context "when params valid" do

      it 'saves a run' do
        lambda {
          post :create
        }.should change(Run, :count).by(1)
      end

      it 'redirects to a run' do
        post :create
        response.should redirect_to runs_url
      end
    end

    context "when params invalid" do

      before :each do
        @run.stubs(:save).returns(false)
      end

      it 'returns to the form on missing data' do
        lambda {
          # missing distances + date in the past (check Run model specs for that)
          post :create
        }.should_not change(Run, :count)
      end

      it 'render new' do
        post :create      
        response.should render_template :new      
      end
    end

  end
end
