FactoryGirl.define do
  factory :notification do
    user ""
    acting_user ""
    employment ""
    leave_request ""
    identifier ""
    notice_type ""
    read false
  end
end
