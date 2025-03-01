require "./setup"
Swars::Crawler::ActiveUserCrawler.new.call.rows.to_t
