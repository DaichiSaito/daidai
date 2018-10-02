require 'rails_helper'

RSpec.feature "Boards", type: :feature do
  given(:user) { create :user }
  background do
    login_user(user)
  end
  feature '掲示板のcrud関連' do
    describe '掲示板の作成' do
      background do
        click_link '掲示板作成'
      end

      # ユーザーは新しい掲示板を作成する
      scenario "user creates a new boards" do
        fill_in 'タイトル', with: 'Test Title'
        fill_in '説明', with: 'Test Description'
        file_path = Rails.root.join('spec', 'fixtures', 'example.jpg')
        attach_file('サムネイル', file_path)
        click_button '登録'
        board = Board.last
        expect(current_path).to eq boards_path
        expect(page).to have_content '掲示板の作成が完了しました。'
        expect(find("#product-id-#{board.id}")).to have_content 'Test Title'
        expect(find("#product-id-#{board.id}")).to have_content 'Test Description'
      end

      # ユーザーは新しい掲示板の作成に失敗する
      scenario "user fail to create a new boards" do

        fill_in 'タイトル', with: 'Test Title'
        click_button '登録'
        expect(page).to have_content 'エラーが発生したため、掲示板を作成できません。'
      end
    end

    describe '掲示板の編集' do
      context '自分の掲示板に対する処理' do
        let(:board) { create :board, user: user}
        background do
          visit "boards/#{board.id}/edit"
        end

        # ユーザーは既存の掲示板を編集する
        scenario "user edits a boards" do
          fill_in 'タイトル', with: 'Edited Test Title'
          fill_in '説明', with: 'Edited Test Description'
          file_path = Rails.root.join('spec', 'fixtures', 'example.jpg')
          attach_file('サムネイル', file_path)
          click_button '更新'
          expect(current_path).to eq boards_path
          expect(page).to have_content '掲示板の更新が完了しました。'
          expect(find("#product-id-#{board.id}")).to have_content 'Edited Test Title'
          expect(find("#product-id-#{board.id}")).to have_content 'Edited Test Description'
        end

        # ユーザーは既存の掲示板を編集に失敗する
        scenario "user failes to edit a boards" do
          fill_in 'タイトル', with: ''
          click_button '更新'
          expect(current_path).to eq board_path(board)
          expect(page).to have_content 'エラーが発生したため、掲示板を更新できません。'
        end
      end
    end

    context '掲示板の削除' do
      let(:board) { create :board, user: user }
      # ユーザーは掲示板を削除する
      scenario "user deletes a boards", js: true do
        visit "boards/#{board.id}"
        page.accept_confirm { find('a.btn__delete').click }
        expect(page).to have_content "掲示板:#{board.title}を削除しました。"
        expect(page).not_to have_selector("#product-id-#{board.id}")
      end
    end
  end

  feature '掲示板のアクセス制御' do
    context '他人の掲示板に対する処理' do
      # 他人の掲示板の編集画面へ遷移すると不正アクセスエラーになる
      let(:board) { create :board, :with_user }
      scenario "user failes to access to board edit page" do
        visit "boards/#{board.id}/edit"
        expect(current_path).to eq boards_path
        expect(page).to have_content '不正なアクセスです。'
      end
    end
  end

  feature '掲示板のフォロー関連' do
    let(:board) { create :board, :with_user }
    scenario "user follow and unfollow a board", js: true do
      visit "boards/#{board.id}"

      find('a.btn__follow').click
      expect(current_path).to eq board_path(board)
      expect(page).to have_selector('a.btn__unfollow')

      find('a.btn__unfollow').click
      expect(current_path).to eq board_path(board)
      expect(page).to have_selector('a.btn__follow')
    end

    scenario "user unfollow and no-contents text is shown", js: true do
      visit "boards/#{board.id}"

      find('a.btn__follow').click

      visit "follows"
      expect(page).to have_selector('a.btn__unfollow')
      find('a.btn__unfollow').click
      expect(current_path).to eq follows_path
      expect(page).to have_content 'フォロー中の掲示板はありません。'
    end
  end

  feature '掲示板の検索関連' do
    given!(:boardA) { create :board, :with_user, title: 'タイトルAです', description: '本文Aです' }
    given!(:boardB) { create :board, :with_user, title: 'タイトルBです', description: '本文Bです' }
    scenario "user search boards" do
      visit "boards"
      fill_in "q_title_or_description_cont", with: "タイトルA"
      click_button '検索'
      expect(page).to have_content 'タイトルAです'
      expect(page).not_to have_content 'タイトルBです'

      fill_in "q_title_or_description_cont", with: "タイトルB"
      click_button '検索'
      expect(page).to have_content 'タイトルBです'
      expect(page).not_to have_content 'タイトルAです'

      fill_in "q_title_or_description_cont", with: "本文A"
      click_button '検索'
      expect(page).to have_content 'タイトルAです'
      expect(page).not_to have_content 'タイトルBです'

      fill_in "q_title_or_description_cont", with: "本文B"
      click_button '検索'
      expect(page).to have_content 'タイトルBです'
      expect(page).not_to have_content 'タイトルAです'

      fill_in "q_title_or_description_cont", with: "タイトルC"
      click_button '検索'
      expect(page).not_to have_content 'タイトルAです'
      expect(page).not_to have_content 'タイトルBです'

      expect(page).to have_content '掲示板がありません。'
    end
  end
end
