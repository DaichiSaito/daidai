# == Schema Information
#
# Table name: boards
#
#  id          :integer          not null, primary key
#  title       :string(255)      not null
#  description :text(65535)      not null
#  image       :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :board do
    title "MyString"
    description "MyText"
    image "MyString"

    trait :with_user do
      association :user, factory: :user
    end
    after(:create) do |board|
      board.notifications << create(:notification, notifiable_id: board.id, notifiable_type: 'Board')
    end
  end
end
