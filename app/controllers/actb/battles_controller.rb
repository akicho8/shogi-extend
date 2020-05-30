# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle (actb_battles as Actb::Battle)
#
# |--------------+--------------+-------------+-------------+------+-------|
# | name         | desc         | type        | opts        | refs | index |
# |--------------+--------------+-------------+-------------+------+-------|
# | id           | ID           | integer(8)  | NOT NULL PK |      |       |
# | room_id      | Room         | integer(8)  | NOT NULL    |      | A     |
# | parent_id    | Parent       | integer(8)  |             |      | B     |
# | begin_at     | Begin at     | datetime    | NOT NULL    |      | C     |
# | end_at       | End at       | datetime    |             |      | D     |
# | final_key    | Final key    | string(255) |             |      | E     |
# | rule_key     | Rule key     | string(255) | NOT NULL    |      | F     |
# | rensen_index | Rensen index | integer(4)  | NOT NULL    |      | G     |
# | created_at   | 作成日時     | datetime    | NOT NULL    |      |       |
# | updated_at   | 更新日時     | datetime    | NOT NULL    |      |       |
# |--------------+--------------+-------------+-------------+------+-------|

module Actb
  class BattlesController < ApplicationController
    def index
      @battles = Battle.all.order(:id)
    end

    def show
      @battle = Battle.find(params[:id])
      @messages = @battle.messages.order(:id).last(10)
    end
  end
end
