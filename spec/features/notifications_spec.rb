require 'rails_helper'

RSpec.feature "Notifications", type: :feature do
  given(:user) { create :user }
  given(:other_user) { create :user }
  background do
    login_user(user)
  end

  scenario "user filter notifications", js: true do
    visit "/"
    expect(page).to have_content("お知らせはありません。")
    select "掲示板作成情報のみ表示", from: "js-notification-search-select"
    expect(page).to have_content("お知らせはありません。")
    select "コメント情報のみ表示", from: "js-notification-search-select"
    expect(page).to have_content("お知らせはありません。")
    select "全て表示", from: "js-notification-search-select"
    expect(page).to have_content("お知らせはありません。")

    create :board, :with_user

    select "掲示板作成情報のみ表示", from: "js-notification-search-select"
    expect(page).not_to have_content("お知らせはありません。")
    expect(page).to have_content('新しい掲示板が作成されました')

    board = create :board, user: user
    create :comment, user: other_user, board: board

    select "コメント情報のみ表示", from: "js-notification-search-select"
    expect(page).not_to have_content("お知らせはありません。")
    expect(page).to have_content('あなたの掲示板にコメントがつきました')

    select "全て表示", from: "js-notification-search-select"
    expect(page).not_to have_content("お知らせはありません。")
    expect(page).to have_content('新しい掲示板が作成されました')
    expect(page).to have_content('あなたの掲示板にコメントがつきました')
  end
end
