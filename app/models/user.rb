# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  email            :string(255)      not null
#  crypted_password :string(255)
#  salt             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  last_name        :string(255)
#  first_name       :string(255)
#  image            :string(255)
#

class User < ApplicationRecord
  authenticates_with_sorcery!
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true

  has_many :boards, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :following_boards, through: :follows, source: :board
  mount_uploader :image, AvatarUploader

  def post_comment(board, comment)
    comment.user_id = id
    comment.board_id = board.id
    comment.save
  end

  def follow(board)
    # createだとバリデーションの成功可否を取得できない
    follow = follows.build(board_id: board.id)
    follow.save
  end

  def unfollow(board)
    follows.find_by(board_id: board.id).destroy!
  end

  def following?(board)
    following_boards.include?(board)
  end

  def has_board?(board)
    boards.include?(board)
  end
end
