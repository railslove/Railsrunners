FactoryGirl.define do
  factory :participant do |p|
    p.distance {|p| p.association(:distance)}
    p.run      {|p| p.association(:run)}
    name       'Derp'
  end
end
