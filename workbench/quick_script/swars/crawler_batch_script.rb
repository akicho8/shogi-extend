require "./setup"
Swars::CrawlReservation.destroy_all
current_user = User.admin
json = QuickScript::Swars::CrawlerBatchScript.new({user_key: "alice", attachment_mode: "with_zip"}, {_method: "post", current_user: current_user}).as_json
json[:flash][:notice]                   # => "予約しました"
crawl_reservation = Swars::CrawlReservation.last
crawl_reservation.crawl!
crawl_reservation.reload
p crawl_reservation.processed_at
