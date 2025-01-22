# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SignIns', type: :request do
  let(:user) { FactoryBot.create(:user, password: 'password123') }

  context '正常系' do
    context '有効なユーザー情報の場合' do
      it 'サインインに成功し、ツイート一覧ページに遷移する' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: 'password123'
          }
        }

        aggregate_failures do
          expect(response).to have_http_status(:see_other)
          expect(response).to redirect_to(tweets_path)
        end
      end
    end
  end

  context '異常系' do
    context '無効なユーザー情報の場合' do
      it 'サインインに失敗し、ログイン画面にリダイレクトする' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: 'wrongpassword'
          }
        }

        aggregate_failures do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('Twitterにログイン')
        end
      end
    end
  end
end
