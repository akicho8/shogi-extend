module Api
  class BlindfoldsController < ::Api::ApplicationController
    include ShogiErrorRescueMethods

    def show
      render json: { record: current_record.as_json(only: [:sfen_body, :turn_max]) }
    end

    def create
      info = Bioshogi::Parser.parse(params[:sfen])
      SlackAgent.notify(subject: "目隠し詰将棋", body: [info.to_sfen, info.to_yomiage].join(" "))
      render json: { yomiage_body: info.to_yomiage }
    end

    private

    def current_record
      @current_record ||= FreeBattle.same_body_fetch(params)
    end
  end
end
