module Api
  class ApplicationController < ::ApplicationController
    include ShogiErrorRescueMethods # for bs_error

    def api_login_required
      if !current_user
        render json: { statusCode: 403, message: "ログインしてください" }, status: 403
      end
    end

    def api_log!
      ApiOnelineLogger.new(self).perform
    end
  end
end
