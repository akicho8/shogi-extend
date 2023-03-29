require "rails_helper"

RSpec.describe "sitemap", type: :system do
  it "works" do
    response = Faraday.get("#{Capybara.app_host}/sitemap.xml")
    node = Nokogiri::XML(response.body)
    assert2 { node.search("loc").present? }
  end
end
