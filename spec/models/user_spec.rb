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

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'コメント' do
    let(:board) { create :board, :with_user }
    let(:post_user) { create :user }
    let(:comment) { Comment.new(body: "Test Body") }
    # コメントを作成できること
    it "create my comment to board" do
      expect {
        post_user.post_comment(board, comment)
      }.to change(post_user.comments, :count).by(1)
    end

    # 他人のコメントを編集できないこと
    it "is not authorized to edit other's comments"
    # 他人のコメントを削除できないこと
    it "is not authorized to delete other's comments"
  end

  describe 'フォロー・アンフォロー' do
    let(:board) { create :board, :with_user }
    let(:user) { create :user }
    # 掲示板をフォローアンフォローできること
    it "follow a board and unfollow a board" do
      user = create :user
      expect(user.following?(board)).to be false
      expect { user.follow(board) }.to change(user.follows, :count).by(1)
      expect(user.following?(board)).to be true

      expect { user.unfollow(board) }.to change(user.follows, :count).by(-1)
      expect(user.following?(board)).to be false
    end

    # 二重にフォローできないこと
    it "fails to follow a one board more than once" do
      user.follow(board)
      expect {
        user.follow(board)
      }.not_to change(user.follows, :count)
    end
  end
end
