require 'spec_helper'

describe ParticipantsController do
  render_views

  describe '#new' do
    before :each do
      @run = Factory(:run)
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

    context "without a participation" do

      before :each do
        @run = Factory(:run)
        Participant.expects(:find_by_result_token)
      end

      it 'should be redirected to runs url' do
        get :edit, :id =>14, :token =>"antsuansuhanstuhnsathun"
        response.should redirect_to runs_url
      end

    end

    context "a participation for a past run" do

      before :each do
        # TODO maybe we look into the code because the tests doesn't feels to be the right way;) [Jan, 22.11.11]      
        @participant = Factory.build(:participant)
        @participant.stubs(:cannot_participate_in_past_run)
        @participant.save
        Participant.expects(:find_by_result_token).returns(@participant)  
        @participant.stub_chain(:run, :past?).and_return(true) 
      end

      it 'should be successful' do
        get :edit, :id => @participant.id, :token => @participant.result_token
        response.should be_success
      end

      it 'should render the edit template' do
        get :edit, :id => @participant.id, :token => @participant.result_token
        response.should render_template("edit")
      end

    end

    context "a participation for a future run" do

      before :each do
        # TODO maybe we look into the code because the tests doesn't feels to be the right way;) [Jan, 22.11.11]      
        @participant = Factory.build(:participant)
        @participant.stubs(:cannot_participate_in_past_run)
        @participant.save
        Participant.expects(:find_by_result_token).returns(@participant)   
        @participant.run.stubs(:past?).returns(false)                              
      end

      it 'should be redirected to runs url' do
        get :edit, :id => @participant.id, :token => @participant.result_token
        response.should redirect_to runs_url
      end

    end

  end

  describe '#update' do

    before :each do
      # TODO maybe we look into the code because the tests doesn't looks good ;) [Jan, 22.11.11]
      @participant = Factory.build(:participant)
      @participant.stubs(:cannot_participate_in_past_run)
      @participant.save
      Participant.expects(:find_by_result_token).returns(@participant)      
    end

    context "when params valid" do

      context "and run is in the past" do

        before(:each) do
          @participant.run.stubs(:past?).returns(true)   
        end

        it 'updates a participant' do
          put :update, :id => @participant.id, :token => @participant.result_token, :participant => {:time => 3600}
          @participant.time.should be(3600)
        end

        it "redirects to runs_url" do
          put :update, :id => @participant.id, :token => @participant.result_token, :participant => {:time => 360}
          response.should redirect_to runs_url
        end 

      end

      context "and run is in the future" do

        before(:each) do
          @participant.run.stubs(:past?).returns(false)   
        end

        it 'updates a participant' do
          put :update, :id => @participant.id, :token => @participant.result_token, :participant => {:time => 3600}
          @participant.time.should be(0)
        end

        it "redirects to root_url" do
          put :update, :id => @participant.id, :token => @participant.result_token, :participant => {:time => 360}
          response.should redirect_to root_url
        end     

      end
        
    end

    context "when params invalid" do

      before(:each) do
        @participant.run.stubs(:past?).returns(false)   
      end

      it 'updates a participant' do
        put :update, :id => @participant.id, :token => @participant.result_token
        @participant.time.should be(0)
      end

      it "redirects to root_url" do
        put :update, :id => "14", :token => "ahusanuhnstahus"
        response.should redirect_to root_url
      end 
    end

  end

  describe '#create' do

    before :each do
      @run = Factory(:run)
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
