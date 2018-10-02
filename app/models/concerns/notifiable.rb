module Notifiable
  extend ActiveSupport::Concern

  included do
    has_many :notifications, as: :notifiable, inverse_of: :notifiable, dependent: :destroy
  end

  def notification_subject
    # オーバーライドされなかった場合はエラーが上がるようにしておく
    raise NotImplementedError
  end

  def notification_subject_body
    # オーバーライドされなかった場合はエラーが上がるようにしておく
    raise NotImplementedError
  end

  def notification_body
    # オーバーライドされなかった場合はエラーが上がるようにしておく
    raise NotImplementedError
  end

  def notification_link
    # オーバーライドされなかった場合はエラーが上がるようにしておく
    raise NotImplementedError
  end
end
