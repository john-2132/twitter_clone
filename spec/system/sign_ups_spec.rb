# frozen_string_literal: true

RSpec.describe 'SignUps', type: :system do
  before do
    driven_by(:rack_test)
    ActionMailer::Base.deliveries.clear
  end

  describe 'ユーザー登録' do
    before { visit new_user_registration_path }

    # ヘルパーメソッドの追加
    def fill_registration_form(options = {})
      fill_in 'Name', with: options.fetch(:name, 'Alice')
      fill_in 'Email', with: options.fetch(:email, 'alice@example.com')
      fill_in 'Phone number', with: options.fetch(:phone, '090-1234-5678')
      select options.fetch(:year, '2000'), from: 'user[profile_attributes][birth_date(1i)]'
      select options.fetch(:month, '1'), from: 'user[profile_attributes][birth_date(2i)]'
      select options.fetch(:day, '1'), from: 'user[profile_attributes][birth_date(3i)]'
      fill_in 'Password', with: options.fetch(:password, 'password123')
      fill_in 'Password confirmation', with: options.fetch(:password_confirmation) {
                                               options.fetch(:password, 'password123')
                                             }
    end

    context '正常系' do
      context '入力値が正常の場合' do
        it 'ユーザーの登録に成功する' do
          perform_enqueued_jobs do
            expect do
              fill_registration_form
              click_button 'Sign up'
            end.to change(User, :count).by(1)

            expect(page).to have_content('サインアップに成功しました。')
            expect(page).to have_current_path new_user_session_path, ignore_query: true
          end

          mail = ActionMailer::Base.deliveries.last
          aggregate_failures do
            expect(mail.to).to eq ['alice@example.com']
            expect(mail.from).to eq ['zumiairhc@gmail.com']
            expect(mail.subject).to eq 'Confirmation instructions'
            expect(mail.body).to match 'Confirm my account'
            expect(mail.body).to match 'alice@example.com'
          end
        end
      end
    end

    context '異常系' do
      context '名前が未入力の場合' do
        it 'ユーザーの登録に失敗する' do
          expect do
            fill_registration_form(name: nil)
            click_button 'Sign up'
          end.not_to change(User, :count)

          expect(page).to have_content('Profile nameを入力してください')
        end
      end

      context 'メールアドレスが未入力の場合' do
        it 'ユーザーの登録に失敗する' do
          expect do
            fill_registration_form(email: nil)
            click_button 'Sign up'
          end.not_to change(User, :count)

          expect(page).to have_content('Emailを入力してください')
        end
      end

      context '電話番号が未入力の場合' do
        it 'ユーザーの登録に失敗する' do
          fill_registration_form(phone: nil)

          expect do
            fill_registration_form(phone: nil)
            click_button 'Sign up'
          end.not_to change(User, :count)

          expect(page).to have_content('Profile phone numberを入力してください')
        end
      end

      context '電話番号が不正の場合' do
        it 'ユーザーの登録に失敗する' do
          expect do
            fill_registration_form(phone: '000-0000-0000')
            click_button 'Sign up'
          end.not_to change(User, :count)

          expect(page).to have_content('Profile phone numberは不正な値です')
        end
      end

      context 'パスワードが未入力の場合' do
        it 'ユーザーの登録に失敗する' do
          expect do
            fill_registration_form(password: nil)
            click_button 'Sign up'
          end.not_to change(User, :count)

          expect(page).to have_content('Passwordを入力してください')
        end
      end

      context '再確認パスワードが未入力の場合' do
        it 'ユーザーの登録に失敗する' do
          expect do
            fill_registration_form(password_confirmation: nil)
            click_button 'Sign up'
          end.not_to change(User, :count)

          expect(page).to have_content('confirmationとPasswordの入力が一致しません')
        end
      end

      context 'パスワードと再確認パスワードが不一致の場合' do
        it 'ユーザーの登録に失敗する' do
          expect do
            fill_registration_form(password: 'password123', password_confirmation: 'password1234')
            click_button 'Sign up'
          end.not_to change(User, :count)

          expect(page).to have_content('confirmationとPasswordの入力が一致しません')
        end
      end
    end
  end
end
