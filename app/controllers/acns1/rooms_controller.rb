# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room (acns1_rooms as Acns1::Room)
#
# |------------+----------+------------+-------------+------+-------|
# | name       | desc     | type       | opts        | refs | index |
# |------------+----------+------------+-------------+------+-------|
# | id         | ID       | integer(8) | NOT NULL PK |      |       |
# | created_at | 作成日時 | datetime   | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime   | NOT NULL    |      |       |
# |------------+----------+------------+-------------+------+-------|

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
