module MailerSupport
  extend ActiveSupport::Concern

  included do
    include ActiveJob::TestHelper # for perform_enqueued_jobs
  end

  def deliveries_info
    deliveries.collect { |e| { from: e.from, to: e.to, subject: e.subject, body: "#{e.body.decoded.lines.first.strip}..." } }
  end

  def deliveries
    ActionMailer::Base.deliveries
  end
end

RSpec.configure do |config|
  config.include MailerSupport
end
