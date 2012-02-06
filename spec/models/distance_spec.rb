require 'spec_helper'

describe Distance do

  context 'associations' do
    it { should belong_to :run }
    it { should have_many :participants }
  end

  context 'conversion to miles' do
    subject { Distance.new(:distance_in_km => 4.5).distance_in_mi }
    it { should be_within(2).of(2.8) }
  end

  context 'conversion to miles' do
    subject { Distance.new(:distance_in_mi => 4.5).distance_in_km }
    it { should be_within(7).of(7.3) }
  end
end
