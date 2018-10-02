class NotificationSearchType < ActiveHash::Base
  self.data = [
    { id: 1, code: '1', search_type: 'ALL', name: I18n.t('activerecord.enum.notification.search_condition.search_all') },
    { id: 2, code: '2', search_type: 'BOARDS', name: I18n.t('activerecord.enum.notification.search_condition.search_boards') },
    { id: 3, code: '3', search_type: 'COMMENTS', name: I18n.t('activerecord.enum.notification.search_condition.search_comments') }
  ]
end
