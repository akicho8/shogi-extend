class XconvSingleJob < ApplicationJob
  queue_as :xconv_record_only

  def perform(params = {})
    XconvRecord.process_in_sidekiq
  end
end
