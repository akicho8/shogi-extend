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
  # config.server                = :puma
  config.automatic_label_click = true # choose("ラベル名") でラジオボタンが押せるようになる
  config.default_max_wait_time = 5    # 2ぐらいだと chromedriver の転ける確立が高い
  # config.automatic_reload = false      # ←これを入れると安定する ← 関係ない
  # config.threadsafe            = true
end

module SystemSupport
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
  config.after do
    # `pkill -f chromedriver`
  end

  config.before(:example) do |ex|
    @__full_description__ = ex.full_description
  end
end
