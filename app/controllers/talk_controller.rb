class TalkController < ApplicationController
  def show
    render json: Talk.new(params.permit!.to_h.symbolize_keys)
  end
end
