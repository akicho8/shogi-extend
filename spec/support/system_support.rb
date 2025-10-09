# スクリーンショット画像がコンソールに吐かれるのを停止
ENV["RAILS_SYSTEM_TESTING_SCREENSHOT"] = "simple"

# 失敗時にHTMLを保存する
ENV["RAILS_SYSTEM_TESTING_SCREENSHOT_HTML"] = "1"

# headありか？
BROWSER_DEBUG = ENV["BROWSER_DEBUG"].to_s.in?(["1", "true"])

if false
  chromedriver_pids = `pgrep -f chromedriver`.split
  if !chromedriver_pids.empty?
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
  # config.automatic_label_click = true # choose("ラベル名") でラジオボタンが押せるようになる
  # config.default_max_wait_time = 5    # 2ぐらいだと chromedriver の転ける確立が高い
  # config.automatic_reload = false      # ←これを入れると安定する ← 関係ない
  # config.threadsafe            = false
end

module Capybara::DSL
  # def __danger_window_zoom__(value)
  #   execute_script("document.body.style.zoom = #{value}")
  # end
  #
  def window_max
    current_window.maximize
  end

  def return_to_current_window(&block)
    window = current_window
    begin
      yield
    ensure
      switch_to_window(window)
    end
  end

  #
  # def confirm_function_kill!
  #   execute_script("window.confirm = () => true")
  # end
  #
  # def switch_to_window_left(windows)
  #   safe_switch_to_window(windows.first)
  # end
  #
  # def safe_switch_to_window(window)
  #   if window
  #     switch_to_window(window)
  #   end
  # end
  #
  # def visit_all(urls, &block)
  #   windows = urls.collect do |e|
  #     switch_to_new_window do
  #       visit(e)
  #       if block
  #         block.call
  #       end
  #     end
  #   end
  #   switch_to_window_left(windows)
  #   windows
  # end
  #
  # def switch_to_windows(windows, &block)
  #   begin
  #     original = current_window
  #     windows.collect do |e|
  #       switch_to_window(e)
  #       block.call
  #     end
  #   ensure
  #     switch_to_window(original)
  #   end
  # end
  #
  # def switch_to_new_window(&block)
  #   open_new_window.tap do |window|
  #     switch_to_window(window)
  #     if block
  #       block.call
  #     end
  #   end
  # end
  #
  # def active_send_keys(...)
  #   current_session.active_element.send_keys(...)
  # end
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

    # driven = ENV["BROWSER_DEBUG"] ? :selenium_chrome : :selenium_chrome_headless
    # driven_by :selenium, using: driven, screen_size: [1400, 1400]
    # driven_by :selenium_chrome

    # ↑ この書き方だと次のコードが実行され、resize_to になっていないのでスクリーンショットを撮ったときのサイズが変わらない
    # driver.browser.manage.window.size = Selenium::WebDriver::Dimension.new(*@screen_size)

    # 設定したいのはこっち
    # これ visit で移動してスクリーンショットを撮る前にリサイズしないと意味がない
    # height = Capybara.page.execute_script("return Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);")
    # p height
    # Capybara.current_session.driver.browser.manage.window.resize_to(1680, 1050)

    # 書き方が変わって現在はこれ
    # https://qiita.com/jnchito/items/c7e6e7abf83598a6516d
    # これにしてテストが落ちなくなったところもある
    # 前の書き方だとサイズが効いていなかったと思われる
    driven_by :selenium, using: (BROWSER_DEBUG ? :chrome : :headless_chrome) # screen_size: [1400, 1400]
  end
end

if true
  RSpec.configure do |config|
    config.before(:example, type: :system) do
      # FIXME: なぜかテスト環境で動かなくなったので開発環境に向けている
      # test環境で動くRailsでdevelopmentのnuxtをテストしているせいでカオスになっている
      # Capybara.app_host = "http://localhost:4000"
      Capybara.app_host = "http://localhost:4000"

      # windowをひとつだけにしておく
      Capybara.windows.drop(1).each(&:close)
      Capybara.switch_to_window(Capybara.windows.first)
    end

    # 明示的に呼んでみる
    config.after(:example, type: :system) do
      Capybara.reset_sessions!
    end
  end
end

if true
  module SystemSupport
    if BROWSER_DEBUG
      # headありの場合はスクショに映っている
    else
      # headless の場合は何も映らないのでスクショを取らない
      # /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.0.7/lib/action_dispatch/system_testing/test_helpers/screenshot_helper.rb
      def take_screenshot
      end
    end

    def pause
      puts "[PAUSE]"
      $stdin.gets
    end

    def debug
      `open #{save_screenshot}`
      `open #{save_page}`
    end

    def global_menu_open
      find(".sidebar_toggle_navbar_item").click
    end

    def global_menu_close
      find(".sidebar_close_handle").click
    end

    def menu_item_click(text)
      find(".b-sidebar li a", text: text, exact_text: true).click
    end

    # サブメニューは左右にスペースがない
    def menu_item_sub_menu_click(text)
      first(:xpath, "//*[text()='#{text}']").click
    end

    def text_click(text)
      first(:xpath, "//*[text()='#{text}']").click
    end

    def login_by(key)
      visit_to("http://localhost:3000/", _login_by_key: key)
    end

    def login
      login_by("admin")
    end

    def logout
      visit_to("http://localhost:3000/", _user_id: 0)
    end

    def eval_code(*code)
      code = Array.wrap(code).flatten.join(";")
      visit "http://localhost:3000/eval?#{code.to_query(:code)}"
    end

    def visit_to(url, params = {})
      params = {
        :__system_test_now__ => true,
      }.merge(params).stringify_keys
      uri = URI(url)                                        # => #<URI::HTTPS https://example.com/?a=1&b=2>
      original_params = Rack::Utils.parse_query(uri.query)  # => {"a"=>"1", "b"=>"2"}
      params = original_params.merge(params)                # => {"a"=>"1", "b"=>"2", "c"=>3}
      uri.query = params.to_query                           # => "a=1&b=2&c=3"
      visit(uri.to_s)
    end

    def current_query
      Rack::Utils.parse_query(URI(current_url).query)
    end

    # これだと引けないものも引ける
    # ただ wait などは指定できない
    # なので assert_selector で止めてから doc.at("...") などとすればいい
    def doc
      Nokogiri::HTML(html)
    end

    # 最後に開いたタブに移動する
    # .kif を開いたときなどはこれを実行しないと切り替わらない
    def switch_to_window_by(&block)
      switch_to_window(window_opened_by(&block))
    end
  end

  RSpec.configure do |config|
    config.include(SystemSupport, type: :system)

    config.before(:example) do |e|
      @__full_description__ = e.full_description
    end
  end
end

RSpec.configure do |config|
  config.before(type: :system) do |example|
    if page.driver.browser.respond_to?(:download_path=)
      page.driver.browser.download_path = Rails.root.join("tmp").to_s
    else
      warn "download_path= が未定義です"
    end
  end
end

# # ダウンロードした ZIP を削除する
# RSpec.configure do |config|
#   config.after(:suite) do
#     Dir.chdir(Rails.root) do
#       system "rm -f *.zip"
#     end
#   end
# end

RSpec.configure do |config|
  config.before(:suite) do
    Rails.root.join("RSPEC_ACTIVE").write("")
  end
  config.after(:suite) do
    file = Rails.root.join("RSPEC_ACTIVE")
    if file.exist?
      file.delete
    end
  end
end

RSpec.configure do |config|
  config.after(:suite) do
    system %(say "テスト完了")
  end
end
