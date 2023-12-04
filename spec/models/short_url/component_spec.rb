require "rails_helper"

module ShortUrl
  RSpec.describe Component do
    it "基本形" do
      record = Component.from("/")
      record = Component.fetch(key: record.key)
      assert { record.compact_url == "http://localhost:3000/u/#{record.key}" }
    end

    it "リダイレクトしたと仮定すると履歴ができる" do
      record = Component.from("/")
      assert { record.access_logs.count == 0 }
      record.access_logs.create!
      assert { record.access_logs.count == 1 }
    end

    it "単にURLから短縮URLに変換する" do
      record = Component.from("/")
      assert { record.compact_url == "http://localhost:3000/u/UaswCQacfXi" }
    end
  end
end
