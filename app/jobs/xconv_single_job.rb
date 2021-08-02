class XconvSingleJob < ApplicationJob
  queue_as :my_gif_generate_queue

  def perform(params = {})
    XconvRecord.process_in_sidekiq
  end
end
