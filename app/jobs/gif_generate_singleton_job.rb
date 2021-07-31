class GifGenerateSingletonJob < ApplicationJob
  queue_as :my_gif_generate_queue

  def perform(params = {})
    HenkanRecord.process_in_sidekiq
  end
end
