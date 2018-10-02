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

class Comment < ApplicationRecord
  belongs_to :board
  belongs_to :user
  include Notifiable
  validates :body, presence: true
  paginates_per 20
  scope :recent, -> { order(id: :desc) }

  def notification_subject
    I18n.t('activerecord.attributes.comment.notification_subject')
  end

  def notification_subject_body
    body
  end

  def notification_body
    I18n.t('activerecord.attributes.comment.notification_body')
  end

  def notification_link
    "boards/#{board.id}"
  end
end
