class General::NotificationsController < GeneralController
  def index
    @notifications = notifications_searched_by(params[:search], current_user)
    respond_to do |format|
      format.js
    end
  end

  private

  def notifications_searched_by(code, user)
    if code == NotificationSearchType.find_by(search_type: 'ALL').code
      Notification.unread_all(user)
    elsif code == NotificationSearchType.find_by(search_type: 'BOARDS').code
      Notification.unread_boards(user)
    elsif code == NotificationSearchType.find_by(search_type: 'COMMENTS').code
      Notification.unread_comments(user)
    else
      []
    end
  end
end
