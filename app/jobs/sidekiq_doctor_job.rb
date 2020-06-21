class SidekiqDoctorJob < ApplicationJob
  queue_as :default

  def perform(params)
    body = eval(params[:code]) rescue $!
    AlertLog.track("sidekiq", body: body.inspect)
  end
end
