# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SignUps', type: :request do
  let(:user) { FactoryBot.create(:user) }

  context '正常系' do
    context '有効なユーザー情報の場合' do
      it 'サインアップに成功し、サインインページに遷移する' do
        user_params = FactoryBot.attributes_for(:user)
        post user_registration_path, params: { user: user_params }

        aggregate_failures do
          expect(response).to have_http_status(:see_other)
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end
  end

  context '異常系' do
    context '名前が空の場合' do
      it 'サインアップに失敗し、画面遷移しない' do
        user_params = FactoryBot.attributes_for(:user, :without_name)
        post user_registration_path, params: { user: user_params }

        aggregate_failures do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('アカウント作成')
        end
      end
    end

    context 'emailが空の場合' do
      it 'サインアップに失敗し、画面遷移しない' do
        user_params = FactoryBot.attributes_for(:user, :without_email)
        post user_registration_path, params: { user: user_params }

        aggregate_failures do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('アカウント作成')
        end
      end
    end

    context '電話番号が未入力の場合' do
      it 'サインアップに失敗し、画面遷移しない' do
        user_params = FactoryBot.attributes_for(:user, :without_phone_number)
        post user_registration_path, params: { user: user_params }

        aggregate_failures do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('アカウント作成')
        end
      end
    end

    context '電話番号が不正の場合' do
      it 'サインアップに失敗し、画面遷移しない' do
        user_params = FactoryBot.attributes_for(:user, :invalid_phone_number)
        post user_registration_path, params: { user: user_params }

        aggregate_failures do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('アカウント作成')
        end
      end
    end

    context 'パスワードが未入力の場合' do
      it 'サインアップに失敗し、画面遷移しない' do
        user_params = FactoryBot.attributes_for(:user, :without_password)
        post user_registration_path, params: { user: user_params }

        aggregate_failures do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('アカウント作成')
        end
      end
    end

    context '再確認パスワードが未入力の場合' do
      it 'サインアップに失敗し、画面遷移しない' do
        user_params = FactoryBot.attributes_for(:user, :without_password_confirmation)
        post user_registration_path, params: { user: user_params }

        aggregate_failures do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('アカウント作成')
        end
      end
    end

    context 'パスワードと再確認パスワードが不一致の場合' do
      it 'サインアップに失敗し、画面遷移しない' do
        user_params = FactoryBot.attributes_for(:user, :mismatch_password)
        post user_registration_path, params: { user: user_params }

        aggregate_failures do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('アカウント作成')
        end
      end
    end
  end
end
