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
# | entry_name        | Entry name     | string(255) | NOT NULL    |                             | C     |
# | summary           | Summary        | string(255) |             |                             |       |
# | xy_rule_key       | Xy rule key    | string(255) | NOT NULL    |                             | B     |
# | x_count           | X count        | integer(4)  | NOT NULL    |                             |       |
# | spent_sec         | Spent sec      | float(24)   | NOT NULL    |                             |       |
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
    if request.format.json?
      if params[:xy_rule_key2]
        render json: { chartjs_datasets: XyRuleInfo.chartjs_datasets(params) }
        return
      end

      render json: { xy_records_hash: XyRuleInfo.xy_records_hash(params) }
      return
    end
  end

  def create
    if command = current_params[:command]
      self.class.send("command_#{command}", current_params[:args] || {})
      render json: { message: command }
      return
    end

    @xy_record = XyRecord.create!(current_params.merge(user: current_user))
    @xy_record.slack_notify
    render json: result_attributes
  end

  def update
    id = current_params[:id]
    @xy_record = XyRecord.find(id)
    @xy_record.update!(entry_name: current_params[:entry_name])
    @xy_record.slack_notify
    render json: result_attributes
  end

  def js_index_options
    {
      xy_rule_info: XyRuleInfo.as_json,
      xy_scope_info: XyScopeInfo.as_json,
      xhr_post_path: url_for([:xy_records, format: :json]),
      per_page: XyRuleInfo.per_page,
      rank_max: XyRuleInfo.rank_max,
      # chartjs_datasets: {
      #   data: {
      #     datasets: chartjs_datasets,
      #   },
      # },
    }
  end

  private

  def result_attributes
    {
      xhr_put_path: url_for([@xy_record, format: :json]),
      xy_records: XyRuleInfo[@xy_record.xy_rule_key].xy_records(params),
      xy_record: @xy_record.attributes.merge(rank: @xy_record.rank(params), ranking_page: @xy_record.ranking_page(params)).as_json,
    }
  end

  def current_params
    params.permit![:xy_record]
  end
end
