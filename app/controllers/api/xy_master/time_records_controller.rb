# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Time record (xy_master_time_records as XyMaster::TimeRecord)
#
# |------------+------------+-------------+-------------+--------------+-------|
# | name       | desc       | type        | opts        | refs         | index |
# |------------+------------+-------------+-------------+--------------+-------|
# | id         | ID         | integer(8)  | NOT NULL PK |              |       |
# | user_id    | User       | integer(8)  |             | => ::User#id | A     |
# | rule_id    | Rule       | integer(8)  | NOT NULL    |              | B     |
# | entry_name | Entry name | string(255) | NOT NULL    |              | C     |
# | summary    | Summary    | string(255) |             |              |       |
# | x_count    | X count    | integer(4)  | NOT NULL    |              |       |
# | spent_sec  | Spent sec  | float(24)   | NOT NULL    |              |       |
# | created_at | 作成日時   | datetime    | NOT NULL    |              |       |
# | updated_at | 更新日時   | datetime    | NOT NULL    |              |       |
# |------------+------------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Api
  module XyMaster
    class TimeRecordsController < ApplicationController
      # curl http://0.0.0.0:3000/api/xy_master/time_records?config_fetch=true
      # curl http://0.0.0.0:3000/api/xy_master/time_records?chart_scope_key=chart_scope_recently&chart_rule_key=rule100t
      # curl http://0.0.0.0:3000/api/xy_master/time_records?scope_key=scope_today&entry_name_uniq_p=false
      def index
        if request.format.json?
          if params[:config_fetch]
            render json: config_params
            return
          end

          if params[:chart_rule_key] || params[:chart_scope_key]
            render json: { chartjs_datasets: ::XyMaster::RuleInfo.chartjs_datasets(params) }
            return
          end

          if params[:time_records_hash_fetch]
            render json: ::XyMaster::RuleInfo.time_records_hash(params)
            return
          end
        end
      end

      def create
        if command = params[:command]
          ::XyMaster::RuleInfo.public_send(command)
          render json: { message: command }
          return
        end

        @time_record = ::XyMaster::TimeRecord.create!(record_params.merge(user: current_user))
        @time_record.slack_notify
        render json: result_attributes
      end

      def update
        id = record_params[:id]
        @time_record = ::XyMaster::TimeRecord.find(id)
        @time_record.update!(entry_name: record_params[:entry_name])
        @time_record.slack_notify
        render json: result_attributes
      end

      def config_params
        {
          :rule_info        => ::XyMaster::RuleInfo.as_json,
          :scope_info       => ::XyMaster::ScopeInfo.as_json,
          :chart_scope_info => ::XyMaster::ChartScopeInfo.as_json,
          :per_page         => ::XyMaster::RuleInfo.per_page,
          :rank_max         => ::XyMaster::RuleInfo.rank_max,
          :count_all_gteq   => ::XyMaster::RuleInfo.count_all_gteq,
          :description      => ::XyMaster::RuleInfo.description,
        }
      end

      private

      def result_attributes
        {
          time_records: @time_record.rule.pure_info.time_records(params),
          time_record: @time_record.as_json(methods: [:rank_info, :best_update_info, :rule_key]),
        }
      end

      def record_params
        params.permit![:time_record]
      end
    end
  end
end
