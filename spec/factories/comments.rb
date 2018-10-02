# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  board_id   :integer
#  user_id    :integer
#  body       :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :comment do
    board nil
    user nil
    body "MyText"

    # trait :with_user do
    #   association :board, factory: :board
    #   association :user, factory: :user
    # end
    after(:create) do |comment|
      comment.notifications << create(:notification, notifiable_id: comment.id, notifiable_type: 'Comment')
    end
  end
end
