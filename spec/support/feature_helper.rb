module FeatureHelper
  def login_user(user)
    visit login_path
    within '#login_form' do
      fill_in I18n.t('activerecord.attributes.user.email'), with: user.email
      fill_in I18n.t('activerecord.attributes.user.password'), with: "password"
      click_button I18n.t('common.login')
    end
  end
end
