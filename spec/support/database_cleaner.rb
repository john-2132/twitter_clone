# frozen_string_literal: true

# RSpec.configure do |config|
#   config.before(:suite) do
#     DatabaseCleaner.clean_with(:truncation)
#   end

#   config.around do |example|
#     DatabaseCleaner.cleaning do
#       example.run
#     end
#   end
#   config.before do
#     puts "=== Starting test: #{RSpec.current_example.description} ==="
#   end

#   config.after do
#     puts "=== Cleaning up after test: #{RSpec.current_example.description} ==="
#   end
# end

RSpec.configure do |config|
  # 全てのテストケースで使用する基本設定
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # 各テストケースの前に動的に戦略を設定
  config.before do
    DatabaseCleaner.strategy = if RSpec.current_example.metadata[:js]
                                 # `js: true`の場合は`deletion`を使用
                                 :deletion
                               else
                                 # 通常は`transaction`を使用
                                 :transaction
                               end
    DatabaseCleaner.start
  end

  # 各テストケースの後にクリーンアップ
  config.after do
    DatabaseCleaner.clean
  end
end
