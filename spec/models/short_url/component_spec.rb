require "rails_helper"

module ShortUrl
  RSpec.describe Component do
    it "基本形" do
      component = Component.fetch(original_url: "http://localhost:3000/")
      component = Component.fetch(key: component.key)
      assert2 { component.compact_url == "http://localhost:3000/u/#{component.key}" }
    end

    it "アクセスログは実際にリダイレクトしたときに作る" do
      component = Component.fetch(original_url: "http://localhost:3000/")
      assert2 { component.access_logs.count == 0 }
      assert2 { component.access_logs_count == 0 }
    end

    it "リダイレクトしたと仮定すると履歴ができる" do
      component = Component.fetch(original_url: "http://localhost:3000/")
      component.access_logs.create!
      assert2 { component.access_logs.count == 1 }
      assert2 { component.access_logs_count == 1 }
    end

    it "単にURLから短縮URLに変換する" do
      assert2 { ShortUrl.from("http://localhost:3000/") == "http://localhost:3000/u/zZSGrCkrLPo" }
    end
  end
end
