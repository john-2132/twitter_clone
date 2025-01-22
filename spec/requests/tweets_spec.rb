# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tweets', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  context '正常系' do
    context '有効なポスト内容の場合' do
      it 'ツイートに成功する' do
        tweet_params = FactoryBot.attributes_for(:tweet)
        expect do
          post tweets_path, params: { tweet: tweet_params }, headers: { 'ACCEPT' => 'text/vnd.turbo-stream.html' }
          expect(response).to have_http_status '200'
        end.to change(user.tweets, :count).by(1)
      end
    end
  end

  context '異常系' do
    context 'ポスト内容が空であれば' do
      it 'ツイートに失敗する' do
        tweet_params = FactoryBot.attributes_for(:tweet, :without_text)
        expect do
          post tweets_path, params: { tweet: tweet_params }
          expect(response).to have_http_status '422'
        end.to change(user.tweets, :count).by(0)
      end
    end

    context 'ポスト内容が長過ぎであれば' do
      it 'ツイートに失敗する' do
        tweet_params = FactoryBot.attributes_for(:tweet, :with_too_long_text)
        expect do
          post tweets_path, params: { tweet: tweet_params }
          expect(response).to have_http_status '422'
        end.to change(user.tweets, :count).by(0)
      end
    end
  end
end
