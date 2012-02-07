FactoryGirl.define do
  factory :run do |r|
    name 'My super duper run'
    r.user {|r| r.association(:user)}
    url "http://mysuperrun.com"
    charity "lorem ipsum doro"
    charity_url "http://mycharity.com"
    start_at Time.now+3.days
    notes "notes notes notes"
  end
end
