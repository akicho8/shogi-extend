# frozen-string-literal: true

module AxiosMethods
  extend ActiveSupport::Concern

  included do
    before_action do
      Rails.logger.info("AxiosProcessType: process.#{axios_process_type}")
    end
  end

  def axios_process_type
    request.headers["AxiosProcessType"].presence&.to_sym # NOTE: アンダースコアを含めると取れない
  end

  def axios_process_server?
    axios_process_type == :server
  end

  def axios_process_client?
    axios_process_type == :client
  end

  def axios_request?
    axios_process_type
  end
end
