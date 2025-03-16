require "rails_helper"

RSpec.describe Swars::Importer::FullHistoryImporter, type: :model, swars_spec: true do
  it "works" do
    assert { Swars::Battle.count == 0 }
    Swars::Importer::FullHistoryImporter.new(user_key: "DevUser1").call
    assert { Swars::Battle.count == 3 }
    Swars::Importer::FullHistoryImporter.new(user_key: "DevUser1").call
    assert { Swars::Battle.count == 3 }
  end

  describe "eager_to_next_page に対応して hard_crawled_at と soft_crawled_at を更新する" do
    it "見ているページに新しい対局がない場合はすぐに終わる (デフォルト)" do
      user = Swars::User.create!(user_key: "DevUser1")
      Timecop.freeze("2001-01-01") do
        Swars::Importer::FullHistoryImporter.new(user_key: "DevUser1").call # オプションなしの場合
      end
      assert { Swars::User["DevUser1"].soft_crawled_at == "2001-01-01".to_time } # ← こっちだけ更新している
      assert { Swars::User["DevUser1"].hard_crawled_at == "2000-01-01".to_time }
    end

    it "全体の場合は hard_crawled_at も更新する" do
      user = Swars::User.create!(user_key: "DevUser1")
      Timecop.freeze("2001-01-01") do
        Swars::Importer::FullHistoryImporter.new(user_key: "DevUser1", eager_to_next_page: true, look_up_to_page_x: 2).call
      end
      assert { Swars::User["DevUser1"].soft_crawled_at == "2001-01-01".to_time } # ← 両方を
      assert { Swars::User["DevUser1"].hard_crawled_at == "2001-01-01".to_time } # ← 更新している
    end
  end
end
