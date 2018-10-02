class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true
  scope :unread, ->(user) { where('notifications.created_at > ?', user.last_login_at) }

  def self.unread_all(user)
    unread_boards(user) + unread_comments(user)
  end

  def self.unread_boards(user)
    # 全体をjoinしてからunreadで絞り込むか、
    # unreadで絞り込んだものをjoinするかで迷ったけど、
    # 後者の方がDBの負荷が少なさそうだと思い後者にした。
    unread(user)
      .joins("INNER JOIN boards on notifiable_type = 'Board' and notifiable_id = boards.id")
      .merge(Board.by_others(user))
  end

  def self.unread_comments(user)
    unread(user)
      .joins("INNER JOIN comments on notifiable_type = 'Comment' and notifiable_id = comments.id")
      .joins('INNER JOIN boards on comments.board_id = boards.id')
      .merge(Board.by_own(user))
  end
end
