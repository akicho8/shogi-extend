require "rails_helper"

module Swars
  module Importer
    RSpec.describe AllRuleImporter, type: :model, swars_spec: true do
      it "works" do
        assert { Battle.count == 0 }
        AllRuleImporter.new(user_key: "DevUser1").run
        assert { Battle.count == 3 }
        AllRuleImporter.new(user_key: "DevUser1").run
        assert { Battle.count == 3 }
      end

      describe "early_break に対応して hard_crawled_at と soft_crawled_at を更新する" do
        it "全体の場合は hard_crawled_at も更新する" do
          user = Swars::User.create!(user_key: "DevUser1")
          Timecop.freeze("2001-01-01") do
            AllRuleImporter.new(user_key: "DevUser1", early_break: false).run
          end
          assert { Swars::User["DevUser1"].soft_crawled_at == "2001-01-01".to_time }
          assert { Swars::User["DevUser1"].hard_crawled_at == "2001-01-01".to_time }
        end

        it "1ページ目のみの場合は soft_crawled_at のみ" do
          user = Swars::User.create!(user_key: "DevUser1")
          Timecop.freeze("2001-01-01") do
            AllRuleImporter.new(user_key: "DevUser1", early_break: true).run
          end
          assert { Swars::User["DevUser1"].soft_crawled_at == "2001-01-01".to_time }
          assert { Swars::User["DevUser1"].hard_crawled_at == nil                  }
        end
      end
    end
  end
end
