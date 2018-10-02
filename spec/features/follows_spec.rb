require 'rails_helper'

RSpec.feature "Follows", type: :feature do
  given(:user) { create :user }
  given(:other_user) { create :user }
  background do
    login_user(user)
  end

  context 'フォローしている掲示板が存在する' do
    context '20件より多い' do
      scenario 'フォロ一覧が閲覧ができページングが機能していること' do
        21.times do
          board = create :board, user: other_user
          user.follow(board)
        end

        visit "/follows"
        expect(current_path).to eq follows_path
        expect(all('.product-item').size).to eq(20)
        expect(page).not_to have_content 'フォロー中の掲示板はありません。'
        expect(page).to have_selector(".pagination")
        within '.pagination' do
          first('a[rel=next]').click
        end
        expect(page).to have_selector("#product-id-#{Board.first.id}")
      end
    end

    context '20件以下' do
      scenario 'フォロー一覧が閲覧できページングが表示されていないこと' do
        20.times do
          board = create :board, user: other_user
          user.follow(board)
        end

        visit "/follows"
        expect(current_path).to eq follows_path
        expect(all('.product-item').size).to eq(20)
        expect(page).not_to have_content 'フォロー中の掲示板はありません。'
        expect(page).not_to have_selector(".pagination")
      end
    end
  end

  context 'フォローしている掲示板が存在しない' do
    scenario 'フォロー中の掲示板がない旨のメッセージが表示されること' do
      visit "/follows"
      expect(current_path).to eq follows_path
      expect(page).to have_content 'フォロー中の掲示板はありません。'
    end
  end

  feature '掲示板の検索関連' do
    background do
      boardA = create :board, :with_user, title: 'タイトルAです', description: '本文Aです', user: other_user
      user.follow(boardA)
      boardB = create :board, :with_user, title: 'タイトルBです', description: '本文Bです', user: other_user
      user.follow(boardB)
    end
    scenario "user search boards" do
      visit "follows"

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

      expect(page).to have_content 'フォロー中の掲示板はありません。'
    end
  end
end
