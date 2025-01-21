# frozen_string_literal: true

RSpec.describe 'SignIns', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'ユーザーログイン' do
    before { visit new_user_session_path }

    let(:user) { FactoryBot.create(:user) }

    context '正常系' do
      context '登録済ユーザーの場合' do
        it 'ログインに成功する' do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
          click_button 'commit'

          expect(page).to have_content('サインインに成功しました。')
          expect(page).to have_current_path tweets_path, ignore_query: true
        end
      end
    end

    context '異常系' do
      context '登録済ユーザーのEmail入力を誤った場合' do
        it 'ログインに失敗する' do
          fill_in 'Email', with: 'wrong@example.com'
          fill_in 'Password', with: user.password
          click_button 'commit'

          expect(page).to have_content('Alert')
          expect(page).to have_current_path new_user_session_path, ignore_query: true
        end
      end

      context '登録済ユーザーのPassword入力を誤った場合' do
        it 'ログインに失敗する' do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'password112'
          click_button 'commit'

          expect(page).to have_content('Alert')
          expect(page).to have_current_path new_user_session_path, ignore_query: true
        end
      end
    end
  end
end
