module UserCrawlReservationMod
  extend ActiveSupport::Concern

  # rails r 'tp User.sysop.swars_crawl_reservations'
  included do
    has_many :swars_crawl_reservations, dependent: :destroy, class_name: "Swars::CrawlReservation"
  end
end
