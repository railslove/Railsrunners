require 'spec_helper'

describe RunsController do
  render_views

  describe '#index' do

    before :each do
      @run = Factory(:run)
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
      @run = Factory.build(:past_run)
      @run.save(:validate => false)
    end

    it 'should render successfully the page' do
      get :results
      response.should be_success
    end

    it 'shows the visual_name of runs' do
      get :results
      response.body.should include(@run.visual_name)
    end

    it 'renders the right template' do
      get :results
      response.should render_template :results      
    end
  end

  describe '#new' do

    context "user signed in" do

      before :each do
        @user = Factory(:user)
        sign_in :user, @user      
        controller.stubs(:current_user).returns(@user)
      end

      it 'renders successfully the page' do
        get :new
        response.should be_success
      end

      it 'renders the right template' do
        get :new
        response.should render_template :new      
      end
    end

    context "user not signed in" do

      it 'renders successfully the page' do
        get :new
        response.should redirect_to(new_user_session_url)
      end

    end
  end

  describe '#create' do

    context "user signed in" do

      context "params valid" do

        before :each do
          @user = Factory(:user)
          sign_in :user, @user
          @run = Factory.build(:run)
          controller.stub!(:current_user).and_return(@user)          
          @user.stub_chain(:runs, :build).and_return(@run)
        end

        it 'should create a new run' do
          lambda { post :create }.should change(Run, :count).by(1)
        end

        it 'redirects to a run' do
          post :create
          response.should redirect_to runs_url
        end

      end

      context "params invalid" do

        before :each do
          @user = Factory(:user)
          sign_in :user, @user
          @run = Factory.build(:run)
          controller.stub!(:current_user).and_return(@user)          
          @user.stub_chain(:runs, :build).and_return(@run)
          @run.stubs(:save).returns(false)
        end

        it 'should create a new run' do
          lambda { post :create }.should change(Run, :count).by(0)
        end

        it 'redirects to a run' do
          post :create
          response.should render_template(:new)
        end      
      
      end

    end 

    context "user not signed in" do

      it 'renders successfully the page' do
        get :new
        response.should redirect_to(new_user_session_url)
      end

    end

  end

  describe "#edit" do

    context "signed in" do
      
      context "as owner" do

        before :each do
          @user = Factory(:user)
          @run = Factory(:run, :user => @user)
          controller.stub!(:current_user).and_return(@user)      
          @user.stub_chain(:runs, :find).and_return(@run)          
          sign_in :user, @user
        end

        it 'renders successfully the page' do
          get :edit, :id => @run.id
          response.should be_success
        end

        it 'renders the right template' do
          get :edit, :id => @run.id
          response.should render_template :edit      
        end

      end

      context "not as an owner" do

        before :each do
          @user = Factory(:user)
          @run = Factory(:run)
          controller.stub!(:current_user).and_return(@user)      
          sign_in :user, @user
        end

        it 'is not successful' do
          lambda{ 
            get :edit, :id => @run.id 
          }.should raise_error(ActiveRecord::RecordNotFound)
        end

      end

    end

    context "not signed in" do

      before :each do
        @run = Factory(:run)
      end

      it 'renders successfully the page' do
        get :edit, :id => @run.id
        response.should redirect_to(new_user_session_url)
      end

    end

  end

  describe '#update' do

    context "signed in" do

      context "as owner" do

        context "params valid" do

          before(:each) do
            @user = Factory(:user)
            @run = Factory(:run, :user => @user)
            controller.stub!(:current_user).and_return(@user)      
            sign_in :user, @user
            @user.stub_chain(:runs, :find).and_return(@run)                    
          end
    
          it 'should update the name' do
            put :update, :id => @run.id, :run => {:name => 'Run to the Hills Railscamp Spanish'}
            @run.name.should == "Run to the Hills Railscamp Spanish"
          end

          it 'should be redirected to runs_url' do
            put :update, :id => @run.id, :run => {:name => 'Run to the Hills Railscamp Spanish'}
            response.should(redirect_to(runs_url))
          end

        end

        context "params invalid" do

          before(:each) do
            @user = Factory(:user)
            @run = Factory(:run, :user => @user)
            controller.stub!(:current_user).and_return(@user)      
            sign_in :user, @user
          end
    
          it 'should not be udpated' do
            put :update, :id => @run.id, :run => {:name => ''}
            response.should render_template :edit
          end

          it 'should be successful' do
            put :update, :id => @run.id, :run => {:name => ''}
            response.should be_success
          end

        end

      end

      context "not as an owner" do

        before(:each) do
          @user = Factory(:user)
          @run = Factory(:run)
          controller.stub!(:current_user).and_return(@user)      
          sign_in :user, @user
        end
    
        it 'is not successful' do
          lambda{ 
            get :update, :id => @run.id 
          }.should raise_error(ActiveRecord::RecordNotFound)
        end

      end

    end

    context "not signed in" do

      it 'renders successfully the page' do
        @run = Factory(:run)
        get :update, :id => @run.id
        response.should redirect_to(new_user_session_url)
      end

    end

  end

end
