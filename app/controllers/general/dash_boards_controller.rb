class General::DashBoardsController < GeneralController
  def index
    @notifications = Notification.unread_all(current_user)
  end
end
