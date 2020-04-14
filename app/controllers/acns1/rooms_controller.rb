module Acns1
  class RoomsController < ApplicationController
    def index
      @rooms = Room.all.order(:id)
    end

    def show
      @room = Room.find(params[:id])
      @messages = @room.messages.order(:id).last(10)
    end
  end
end
