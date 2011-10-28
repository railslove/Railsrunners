require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do

  before(:each) do
    @user = Factory.create(:user)
  end

  it { should have_many(:runs) }

end
