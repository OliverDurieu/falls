 # Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rating do
    to_user_id 1
    from_user_id 1
    star 1
    comment "MyText"
    from_user_type "MyString"
    driving_skill 1
    User
  end
end
