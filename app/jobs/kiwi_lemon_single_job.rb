class KiwiLemonSingleJob < ApplicationJob
  queue_as :kiwi_lemon_only

  def perform(options = {})
    ProcessFork.call { Kiwi::Lemon.background_job(options) }
  end
end
