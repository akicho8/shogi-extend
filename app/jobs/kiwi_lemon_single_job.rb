class KiwiLemonSingleJob < ApplicationJob
  queue_as :kiwi_lemon_only

  def perform(params = {})
    Kiwi::Lemon.process_in_sidekiq
  end
end
