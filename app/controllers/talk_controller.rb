class TalkController < ApplicationController
  skip_forgery_protection

  def show
    render json: Talk.new(params.permit!.to_h.symbolize_keys)
  end

  def create
    # config.headers.common['foo'] = "bar"
    # request.headers["foo"] # => "bar"
    render json: Talk.new(params.permit!.to_h.symbolize_keys)
  end
end
