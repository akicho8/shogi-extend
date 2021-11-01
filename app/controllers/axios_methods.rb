module AxiosMethods
  extend ActiveSupport::Concern

  included do
    before_action do
      Rails.logger.info("AxiosRequestFrom: #{axios_request_from}")
    end
  end

  def axios_request_from
    request.headers["AxiosRequestFrom"] # NOTE: アンダースコアを含めると取れない
  end

  def axios_request_from_server?
    axios_request_from == "server"
  end

  def axios_request_from_client?
    axios_request_from == "client"
  end

  def axios_request?
    axios_request_from.present?
  end
end
