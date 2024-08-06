require "rails_helper"

module QuickScript
  module Swars
    RSpec.describe CrawlerBatchScript, type: :model do
      it "works" do
        current_user = User.admin
        swars_user = ::Swars::User.create!
        ::Swars::Battle.create! do |e|
          e.memberships.build(user: swars_user)
        end
        ::Swars::CrawlReservation.destroy_all

        # 棋譜取得の予約
        params = {user_key: swars_user.key, attachment_mode: "with_zip"}
        json = Swars::CrawlerBatchScript.new(params, {_method: "post", current_user: current_user}).as_json
        assert { json[:flash][:notice] == "予約しました" }
        assert { ::Swars::CrawlReservation.active_only.exists? }

        # クロール実行
        crawl_reservation = ::Swars::CrawlReservation.last
        crawl_reservation.crawl!
        crawl_reservation.reload
        assert { crawl_reservation.processed_at }
      end
    end
  end
end
