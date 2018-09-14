class HatugensController < ApplicationController
  def show
    render json: Talkman.new(params[:naiyou])
  end

  def create
    render json: params
  end
end
