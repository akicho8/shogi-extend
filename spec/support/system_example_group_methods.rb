Capybara.configure do |config|
  config.automatic_label_click = true # choose("ラベル名") でラジオボタンが押せるようになる
end

RSpec::Rails::SystemExampleGroup.module_eval do
  def doc_image(name)
    max_resize
    page.save_screenshot(Rails.root.join("doc/images/#{name}.png"))
  end

  def max_resize
    height = Capybara.page.execute_script("return Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);")
    p [:height, height]
    Capybara.current_session.driver.browser.manage.window.resize_to(1680, height) # or 1050
  end
end
