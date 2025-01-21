# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:user) { FactoryBot.build(:user) }

    context '正常系' do
      it 'すべての属性が正しい場合に有効である' do
        expect(user).to be_valid
      end
    end

    context '異常系' do
      it 'emailが空の場合は無効である' do
        user.email = nil
        expect(user).to be_invalid
        expect(user.errors[:email]).to include('を入力してください')
      end

      it 'emailがフォーマットに違反している場合は無効である' do
        user.email = 'user_at_example.com'
        expect(user).to be_invalid
        expect(user.errors[:email]).to include('は不正な値です')
      end

      it 'emailが重複している場合は無効である' do
        FactoryBot.create(:user, email: user.email)
        expect(user).to be_invalid
        expect(user.errors[:email]).to include('はすでに存在します')
      end

      it 'passwordが空の場合は無効である' do
        user.password = nil
        expect(user).to be_invalid
        expect(user.errors[:password]).to include('を入力してください')
      end

      it 'passwordが6文字未満の場合は無効である' do
        user.password = 'short'
        expect(user).to be_invalid
        expect(user.errors[:password]).to include('は6文字以上で入力してください')
      end

      it 'passwordとpassword_confirmationが一致しない場合は無効である' do
        user.password_confirmation = 'mismatch'
        expect(user).to be_invalid
        expect(user.errors[:password_confirmation]).to include('とPasswordの入力が一致しません')
      end

      it 'uidが重複している場合は無効である' do
        FactoryBot.create(:user, uid: user.uid, provider: user.provider)
        expect(user).to be_invalid
        expect(user.errors[:uid]).to include('はすでに存在します')
      end
    end
  end
end
