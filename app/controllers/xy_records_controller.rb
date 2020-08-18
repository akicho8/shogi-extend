# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xy record (xy_records as XyRecord)
#
# |-------------+-------------+-------------+-------------+--------------+-------|
# | name        | desc        | type        | opts        | refs         | index |
# |-------------+-------------+-------------+-------------+--------------+-------|
# | id          | ID          | integer(8)  | NOT NULL PK |              |       |
# | user_id     | User        | integer(8)  |             | => ::User#id | C     |
# | entry_name  | Entry name  | string(255) | NOT NULL    |              | A     |
# | summary     | Summary     | string(255) |             |              |       |
# | xy_rule_key | Xy rule key | string(255) | NOT NULL    |              | B     |
# | x_count     | X count     | integer(4)  | NOT NULL    |              |       |
# | spent_sec   | Spent sec   | float(24)   | NOT NULL    |              |       |
# | created_at  | 作成日時    | datetime    | NOT NULL    |              |       |
# | updated_at  | 更新日時    | datetime    | NOT NULL    |              |       |
# |-------------+-------------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
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
      if params[:xy_chart_rule_key] || params[:xy_chart_scope_key]
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
      xy_chart_scope_info: XyChartScopeInfo.as_json,
      xhr_post_path: url_for([:xy_records, format: :json]),
      per_page: XyRuleInfo.per_page,
      rank_max: XyRuleInfo.rank_max,
      count_all_gteq: XyRuleInfo.count_all_gteq,
      xy_master_custom_mode: AppConfig[:xy_master_custom_mode],
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
      xy_records: XyRuleInfo[@xy_record.xy_rule_key].xy_records(params),
      xy_record: @xy_record.as_json(methods: [:rank_info, :best_update_info]),
    }
  end

  def current_params
    params.permit![:xy_record]
  end
end
