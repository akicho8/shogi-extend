require "rails_helper"

module ShortUrl
  RSpec.describe Component do
    it "基本形" do
      component = Component.fetch(original_url: "http://localhost:3000/")
      component = Component.fetch(key: component.key)
      assert2 { component.compact_url == "http://localhost:3000/url/#{component.key}" }
    end

    it "アクセスログを作る" do
      component = Component.fetch(original_url: "http://localhost:3000/")
      assert2 { component.access_logs.count == 1 }
      assert2 { component.access_logs_count == 1 }
    end

    it "ショートカット" do
      assert2 { ShortUrl.from("http://localhost:3000/") == "http://localhost:3000/url/aae1cf3cb358fab3f0685775655dc000" }
    end
  end
end
