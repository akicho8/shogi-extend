RSpec::Rails::SystemExampleGroup.module_eval do
  def doc_image(name)
    max_resize
    page.save_screenshot(Rails.root.join("doc/images/#{name}.png"))
  end

  def max_resize
    # これまともに動いてない
    height = Capybara.page.execute_script("return Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);")
    p [:height, height]
    Capybara.current_session.driver.browser.manage.window.resize_to(1680, [1050, height].max)
  end
end
