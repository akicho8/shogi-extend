# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xy record (xy_records as XyRecord)
#
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
# | name              | desc           | type        | opts        | refs                        | index |
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
# | id                | ID             | integer(8)  | NOT NULL PK |                             |       |
# | colosseum_user_id | Colosseum user | integer(8)  |             | :user => Colosseum::User#id | A     |
# | entry_name        | Entry name     | string(255) |             |                             |       |
# | summary           | Summary        | string(255) |             |                             |       |
# | xy_rule_key       | Xy rule key    | string(255) | NOT NULL    |                             | B     |
# | x_count           | X count        | integer(4)  | NOT NULL    |                             |       |
# | spent_sec        | Spent msec     | float(24)   | NOT NULL    |                             |       |
# | created_at        | 作成日時       | datetime    | NOT NULL    |                             |       |
# | updated_at        | 更新日時       | datetime    | NOT NULL    |                             |       |
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

class XyRecordsController < ApplicationController
  helper_method :js_index_options

  class << self
    def command_ranking_rebuild(params)
      XyRuleInfo.rebuild
    end
  end

  def index
  end

  def create
    if command = current_params[:command]
      self.class.send("command_#{command}", current_params[:args] || {})
      render json: { message: command }
      return
    end

    @xy_record = XyRecord.create!(current_params.merge(user: current_user))
    render json: result_attributes
  end

  def update
    id = current_params[:id]
    @xy_record = XyRecord.find(id)
    @xy_record.update!(entry_name: current_params[:entry_name])
    SlackAgent.message_send(key: "符号入力ゲーム", body: "[#{@xy_record.entry_name}] #{@xy_record.summary}")
    render json: result_attributes
  end

  def js_index_options
    {
      xhr_post_path: url_for([:xy_records, format: :json]),
      rule_list: XyRuleInfo.rule_list,
      per_page: XyRuleInfo.per_page,
      rank_max: XyRuleInfo.rank_max,
    }
  end

  private

  def result_attributes
    {
      xhr_put_path: url_for([@xy_record, format: :json]),
      rule_list: XyRuleInfo.rule_list,
      xy_record: @xy_record.as_json(methods: [:rank, :ranking_page]),
    }
  end

  def current_params
    params.permit![:xy_record]
  end
end
