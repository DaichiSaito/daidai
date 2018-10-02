require 'rails_helper'

RSpec.feature "Comments", type: :feature do
  given(:board) { create :board, :with_user }
  given(:post_user) { create(:user) }
  given!(:post_user_comment) { create :comment, user: post_user, board: board}
  background do
    login_user(post_user)
  end

  # ユーザーは新しいコメントを投稿する
  scenario "user creates a new comments", js: true do
    visit "boards/#{board.id}"
    fill_in '本文', with: 'Test Comment'
    click_button '投稿'
    within '#comments__table' do
      comment = Comment.last
      expect(first("tr")).to match_selector("#comment#{comment.id}")
      expect(find("#comment#{comment.id}")).to have_content 'Test Comment'
    end
  end

  # ユーザーは新しいコメントの投稿に失敗する
  # js: trueにするとrequired: trueが有効かされるためかそもそもサーバにリクエストがいかずにこのテストができなくなる。

  scenario "user fail to create a new comments", js: true do
    visit "boards/#{board.id}"
    fill_in '本文', with: ' '
    click_button '投稿'
    expect(page).to have_content '本文を入力してください'
  end

  # ユーザーはコメントを削除する
  scenario "user delete a comment", js: true do
    visit "boards/#{board.id}"
    within '#comments__table' do
      expect(find("#comment#{post_user_comment.id}")).to have_content 'MyText'
      expect(find("#comment#{post_user_comment.id}")).to have_selector("a.delete")
      within "#comment#{post_user_comment.id}" do
        find('a.delete').click
      end
      expect(page).not_to have_selector("#comment#{post_user_comment.id}")
    end
  end

  # ユーザーはコメントを編集する
  scenario "user edit a comment", js: true do
    visit "boards/#{board.id}"
    within '#comments__table' do
      expect(find("#comment#{post_user_comment.id}")).to have_content 'MyText'
      expect(find("#comment#{post_user_comment.id}")).to have_selector("button.edit")
      within "#comment#{post_user_comment.id}" do
        find('button.edit').click
      end
      expect(page).not_to have_selector("div#js-comment_text__box#{post_user_comment.id}")
      expect(page).to have_selector("textarea#js-textarea-comment#{post_user_comment.id}")
      within "#comment#{post_user_comment.id}" do
        fill_in "js-textarea-comment#{post_user_comment.id}", with: "MyEditText"
        find('button.edit').click
      end
      expect(find("#comment#{post_user_comment.id}")).to have_content 'MyEditText'
    end
  end
end
