FactoryGirl.define do
  factory :permission do
    user_id 1
    thing_id 1
    thing_type "MyString"
    action "MyString"
  end
end
