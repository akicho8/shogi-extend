# スクリーンショット画像がコンソールに吐かれるのを停止
ENV["RAILS_SYSTEM_TESTING_SCREENSHOT"] ||= "simple"

if true
  chromedriver_pids = `pgrep -f chromedriver`.split
  unless chromedriver_pids.empty?
    `pkill -f chromedriver`
    sleep(1)
    tp({
        "chromedriver 残骸" => chromedriver_pids,
        "削除" => `pgrep -f chromedriver`.split.empty? ? "OK" : "消えない",
      })
  end
end

Capybara.configure do |config|
  # config.server                = :puma, { Silent: true } #  webrick にするとこける
  # config.server                = :puma, { Threads: "10:10", workers: 1, } # ← ぜんぜんかんけいねぇ
  config.automatic_label_click = true # choose("ラベル名") でラジオボタンが押せるようになる
  config.default_max_wait_time = 10    # 2ぐらいだと chromedriver の転ける確立が高い
  # config.automatic_reload = false      # ←これを入れると安定する ← 関係ない
  # config.threadsafe            = false
end

# 「Selenium::WebDriver::Error::UnknownCommandError: unknown command: Cannot call non W3C standard command while in W3C mode」対策
# https://qiita.com/paranishian/items/17bd7a77dc953f8fbd63
# Capybara.register_driver :headless_chrome do |app|
#   capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(chromeOptions: {args: %w[headless disable-gpu window-size=1680,1050], w3c: false})
#   Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
# end

# Capybara.register_driver :chrome do |app|
#   capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
#     chromeOptions: {'w3c' => false}
#   )
#   Capybara::Selenium::Driver.new(app, :browser => :chrome, desired_capabilities: capabilities)
# end

# https://stackoverflow.com/questions/56111529/cannot-call-non-w3c-standard-command-while-in-w3c-mode-seleniumwebdrivererr
Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(chromeOptions: { args: %w[headless disable-gpu], w3c: false })
  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end

RSpec.configure do |config|
  # Chrome をヘッドレスモードで起動
  # https://qiita.com/jnchito/items/c7e6e7abf83598a6516d
  # 必須ではないが設定すると画面出てこなくなる
  config.before(:example, type: :system) do
    # driven_by :selenium_chrome_headless, screen_size: [1680, 1050]

    # caps = Selenium::WebDriver::Remote::Capabilities.chrome(chromeOptions: {w3c: false})
    # driven_by(:selenium, using: :headless_chrome, screen_size: [1680, 1050], options: { desired_capabilities: caps })

    # caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"w3c" => false})
    # driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400], options: { desired_capabilities: caps }

    # driven_by :headless_chrome

    # driven_by :selenium_chrome
    driven_by env["CHROME_HEAD"] ? :selenium_chrome : :selenium_chrome_headless

    # ↑ この書き方だと次のコードが実行され、resize_to になっていないのでスクリーンショットを撮ったときのサイズが変わらない
    # driver.browser.manage.window.size = Selenium::WebDriver::Dimension.new(*@screen_size)


    # 設定したいのはこっち
    # これ visit で移動してスクリーンショットを撮る前にリサイズしないと意味がない
    # height = Capybara.page.execute_script("return Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);")
    # p height
    Capybara.current_session.driver.browser.manage.window.resize_to(1680, 1050)
  end
end

if true
  module SystemSupport
    def pause
      puts "[PAUSE]"
      $stdin.gets
    end

    def doc_image(name = nil)
      max_resize
      name = [@__full_description__, name].compact.join("_").gsub(/\s+/, "_")
      path = Rails.root.join("doc/images/#{name}.png")
      page.save_screenshot(path)
    end

    def max_resize
      height = Capybara.page.execute_script("return Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);")
      # p [:height, height]
      Capybara.current_session.driver.browser.manage.window.resize_to(1680, 1050) # or 1050
    end

    def debug
      `open #{save_screenshot}`
      `open #{save_page}`
    end
  end

  RSpec.configure do |config|
    config.include(SystemSupport, type: :system)

    config.before(:example) do |ex|
      @__full_description__ = ex.full_description
    end
  end
end
