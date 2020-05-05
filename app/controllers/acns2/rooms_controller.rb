# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room (acns2_rooms as Acns2::Room)
#
# |------------+-----------+-------------+-------------+------+-------|
# | name       | desc      | type        | opts        | refs | index |
# |------------+-----------+-------------+-------------+------+-------|
# | id         | ID        | integer(8)  | NOT NULL PK |      |       |
# | begin_at   | Begin at  | datetime    | NOT NULL    |      | A     |
# | end_at     | End at    | datetime    |             |      | B     |
# | final_key  | Final key | string(255) |             |      | C     |
# | created_at | 作成日時  | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時  | datetime    | NOT NULL    |      |       |
# |------------+-----------+-------------+-------------+------+-------|

module Acns2
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
