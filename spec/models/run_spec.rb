require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Run do

  it { should have_many(:participants) }
  it { should have_many(:distances) }
  it { should belong_to(:user) }

  describe 'maps url encoding' do

    before(:each) do
      @distance = Factory(:distance)
      @future_run = Factory.build(:run, :start_at => Time.now + 3.days)
      @future_run.distances << @distance
      @future_run.msid = "211270727460700862622.0004ae3543b46f1649927"
    end

    it 'should encode the url' do
      @future_run.save      
      # result = 'http://maps.google.com/maps/api/staticmap?sensor=false&size=950x300&path=enc%3Arvh%60DxnxkHha%40cXtGyWcDob%40gFoOub%40aXtMsVeq%40u_%40aWrFePhUxBt%60AgUpw%40_TrLkCfTyi%40ns%40ug%40xRLtNhZqGxB%60K%7B%60%40dMcUdZq%5CuJkSbjAa%5DpHpO%7ERlM%5Er%40jXahApNsCdq%40yd%40fG%60Jd%60%40mTs%40iDtZmNfIdPdu%40k%60%40rr%40sn%40l%5Be_%40nn%40%7DTMgYvPca%40i%40s_AjhAykA%7DJos%40hy%40gh%40%7EO%7BO%60ZuYlFqr%40rxA%7DNr%40gJxTus%40hHmAj%7C%40%7DUfk%40em%40p_Agt%40xs%40cG%7BXdMso%40iMsw%40oZ%7BWuSmy%40_h%40mDy%60%40m%60AcDoiCi%7D%40hi%40%7BwA%7D%5Dqh%40%7EC%7Dw%40a%5BkcAy%40_%60%40oSwc%40%7EC%7Ba%40qKmv%40%7Cu%40e%60DzdBy%7CAvm%40ykAbSkbB%3Fur%40wj%40u%7C%40ehBmb%40o%5DolAk%5DeT%7BeA%7DnA%7DiAud%40_Nae%40FwuAse%40cO%7Dq%40%7DdAaeA%7D%7E%40%7ECer%40vW%7BoBdhBwXeA%7DVyPudA%7EKifBgu%40oSYcx%40pQ%7BYjp%40aq%40pHee%40%7D_%40i%5DvGm%5DgXgg%40eBsOjLkLhh%40ubA%7DXyvBkeC%7BaAwEyfA%7Bs%40q_AlRohHalAuoFpEmc%40vMs%7CHyu%40g%60DvHmiCnc%40eiFer%40ipGmoA%7D%7DAqy%40gpGc%7DEapAc%60%40_DmN&path=enc%3A%60th%60DrlxkHqYtl%40fWng%40ee%40bb%40rHb%7CA%7BTfJ%7DC%7C%7C%40oy%40vMyIz_%40m%5BfUo%40l%5E&markers=-25.714655%2C-49.318077'
      @future_run.map_url.should eql "http://maps.google.com/maps/api/staticmap?sensor=false&size=950x300&path=enc%3A_osuDh%7EwdPko%40zb%40sFpDdUxe%40%60FrPzElTxAda%40rAfk%40iN%7E_%40eJnWcQhYcQvXtVnQ"
      # HTTParty.should_receive(:get).with('http://static-maps-generator.appspot.com/url', :msid=>'211270727460700862622.0004ae3543b46f1649927', :size=>'950x300').and_return(result)      
    end

  end

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

