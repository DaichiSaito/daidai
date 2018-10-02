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

class Board < ApplicationRecord
  belongs_to :user
  mount_uploader :image, BoardImageUploader
  validates :title, presence: true
  validates :description, presence: true
  has_many :comments, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :users, through: :follows
  include Notifiable
  paginates_per 20
  scope :recent, -> { order(id: :desc) }
  scope :by_others, ->(user) { where.not(user_id: user.id) }
  scope :by_own, ->(user) { where(user_id: user.id) }

  def notification_subject
    I18n.t('activerecord.attributes.board.notification_subject')
  end

  def notification_subject_body
    title
  end

  def notification_body
    I18n.t('activerecord.attributes.board.notification_body')
  end

  def notification_link
    "boards/#{id}"
  end
end
