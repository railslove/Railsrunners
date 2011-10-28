FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

FactoryGirl.define do
  factory :user do
    name 'John'
    email { FactoryGirl.generate(:email) }
    password "testtest"
  end
end
