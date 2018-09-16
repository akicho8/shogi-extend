class SpeekerController < ApplicationController
  def show
    render json: Speeker.new(params.permit!.to_h.symbolize_keys)
  end
end
