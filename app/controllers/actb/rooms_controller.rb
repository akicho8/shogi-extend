# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room (actb_rooms as Actb::Room)
#
# |------------+-----------+-------------+-------------+------+-------|
# | name       | desc      | type        | opts        | refs | index |
# |------------+-----------+-------------+-------------+------+-------|
# | id         | ID        | integer(8)  | NOT NULL PK |      |       |
# | begin_at   | Begin at  | datetime    | NOT NULL    |      | A     |
# | end_at     | End at    | datetime    |             |      | B     |
# | final_key  | Final key | string(255) |             |      | C     |
# | rule_key   | Rule key  | string(255) |             |      | D     |
# | created_at | 作成日時  | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時  | datetime    | NOT NULL    |      |       |
# |------------+-----------+-------------+-------------+------+-------|

module Actb
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
