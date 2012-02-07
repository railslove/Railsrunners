require 'spec_helper'

describe Distance do
  describe 'associations' do
    it { should belong_to :run }
    it { should have_many :participants }
  end

  describe 'conversions' do
    it 'calculates kilometers correctly' do
      # 4.5 mi =~ 7.24 km
      Distance.new(:distance_in_mi => 4.5).distance_in_km.should be_within(0.01).of(7.24)
    end

    it 'calculates miles correctly' do
      # 4.5 km =~ 2.8 mi
      Distance.new(:distance_in_km => 4.5).distance_in_mi.should be_within(0.01).of(2.8)
    end
  end
end