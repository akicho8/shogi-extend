class SwarsBanCrawlerJob < ApplicationJob
  queue_as :default

  def perform(params)
    Swars::BanCrawler.new(params.to_options).call
  end
end
