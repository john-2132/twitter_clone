# frozen_string_literal: true

require 'capybara/rspec'
require 'selenium/webdriver'
Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('headless')
  options.add_argument('disable-gpu')
  options.add_argument('no-sandbox')
  options.add_argument('disable-dev-shm-usage')

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: ENV.fetch('SELENIUM_DRIVER_URL', 'http://chrome:4444/wd/hub'),
    capabilities: options
  )
end
Capybara.server_host = 'web'
Capybara.app_host = 'http://web'
Capybara.javascript_driver = :remote_chrome
# # Capybaraに、remote_chromeという名前のdriverを登録する
# Capybara.register_driver :remote_chrome do |app|
#   options = {
#     browser: :remote,
#     # remote browserが動作しているurlを指定
#     # 今回は`chrome`という名前で`docker-compose.yml`に登録したのでhost名は`chrome`
#     url: 'http://chrome:4444/wd/hub',
#     capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
#       # 各設定はここを参照: https://peter.sh/experiments/chromium-command-line-switches/
#       'goog:chromeOptions': {
#         args: %w[
#           headless
#           disable-gpu
#           window-size=1400,2000
#           no-sandbox
#         ]
#       }
#     )
#   }

#   Capybara::Selenium::Driver.new(app, options)
# end

# # javascript_driverに上で登録したremote_chromeを指定する
# Capybara.javascript_driver = :remote_chrome
# Capybara.server_host = '0.0.0.0'
# Capybara.server_port = '9999'
# Capybara.app_host = "http://#{IPSocket.getaddress(Socket.gethostname)}:#{Capybara.server_port}"
# Capybara.default_max_wait_time = 5  # JavaScriptの動作待機時間
