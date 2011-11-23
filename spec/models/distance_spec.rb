require 'spec_helper'

describe Distance do

  context 'associations' do

    it { should belong_to :run }

    it { should have_many :participants }

  end

  context 'conversions' do

    it 'calculates kilometeres and miles correctly' do
      Distance.new(:distance_in_km => 4.5).distance_in_mi.should be_within(0.01).of(2.8)
      Distance.new(:distance_in_mi => 4.5).distance_in_km.should be_within(0.01).of(7.24)
    end

  end
end
