class XmovieSingleJob < ApplicationJob
  queue_as :xmovie_record_only

  def perform(params = {})
    XmovieRecord.process_in_sidekiq
  end
end
