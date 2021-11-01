class SidekiqDoctorJob < ApplicationJob
  queue_as :default

  def perform(params)
    body = eval(params[:code]) rescue $!
    AlertLog.notify(subject: "sidekiq", body: body.inspect)
  end
end
