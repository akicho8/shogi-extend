RSpec::Rails::SystemExampleGroup.module_eval do
  def doc_image(name)
    page.save_screenshot(Rails.root.join("doc/images/#{name}.png"))
  end
end
