module ApplicationHelper
  def options_for_searching_notification
    options_for_select(
      NotificationSearchType.all.map do |type|
        [type[:name], type[:code]]
      end
    )
  end
end
