class SwarsBanCrawlerJob < ApplicationJob
  queue_as :low

  def perform(params)
    Swars::BanCrawler.new(params.to_options).call
  end
end
