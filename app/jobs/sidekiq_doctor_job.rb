class SidekiqDoctorJob < ApplicationJob
  queue_as :default

  def perform(params)
    body = eval(params[:code]) rescue $!
    AppLog.info(subject: "sidekiq", body: body.inspect)
  end
end
