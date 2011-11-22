require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do

  context "associations" do 
  
    it { should have_many(:runs) }
  
  end

end
