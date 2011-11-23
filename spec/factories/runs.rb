FactoryGirl.define do
  factory :run do
    name 'My super duper run'
    user
    url "http://mysuperrun.com"
    charity "lorem ipsum doro"
    charity_url "http://mycharity.com"
    start_at Time.now+3.days
    notes "notes notes notes"
    distances {|distances| [distances.association(:distance)]}  
  end
end
