# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tweets', type: :system do
  include Devise::Test::IntegrationHelpers
  let(:user) { FactoryBot.create(:user) }

  before do
    driven_by(:remote_chrome)
  end

  it 'ユーザーは新しいツイートのポストに成功する', js: true do
    sign_in user
    visit tweets_path
    expect(page).to have_content('ホーム')
    expect do
      within('form#tweetPost') do
        fill_in 'いまどうしてる？', with: 'テスト用ツイートです'
      end

      click_button 'tweetPostBtn'

      expect(page).to have_content('テスト用ツイートです')
      sleep 1
    end.to change(user.tweets, :count).by(1)
  end

  it '未ログインではツイート画面へ遷移できない' do
    visit tweets_path

    aggregate_failures do
      expect(page).to have_current_path new_user_session_path, ignore_query: true
      expect(page).to have_content('ja.devise.failure.unauthenticated')
    end
  end
end
