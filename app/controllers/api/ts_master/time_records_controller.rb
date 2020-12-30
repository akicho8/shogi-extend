# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Time record (ts_master_time_records as TsMaster::TimeRecord)
#
# |------------+------------+-------------+-------------+--------------+-------|
# | name       | desc       | type        | opts        | refs         | index |
# |------------+------------+-------------+-------------+--------------+-------|
# | id         | ID         | integer(8)  | NOT NULL PK |              |       |
# | user_id    | User       | integer(8)  |             | => ::User#id | A     |
# | entry_name | Entry name | string(255) | NOT NULL    |              | B     |
# | summary    | Summary    | string(255) |             |              |       |
# | rule_id    | Rule       | integer(8)  | NOT NULL    |              | C     |
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
  module TsMaster
    class TimeRecordsController < ApplicationController
      # curl http://0.0.0.0:3000/api/ts_master/time_records?questions_fetch=true&rule_key=rule_mate3_type1
      # curl http://0.0.0.0:3000/api/ts_master/time_records?config_fetch=true
      # curl http://0.0.0.0:3000/api/ts_master/time_records?chart_scope_key=chart_scope_recently&chart_rule_key=rule_mate3_type1
      # curl http://0.0.0.0:3000/api/ts_master/time_records?scope_key=scope_today&entry_name_uniq_p=false
      def index
        if request.format.json?
          if params[:config_fetch]
            render json: config_params
            return
          end

          if params[:questions_fetch]
            rule_info = ::TsMaster::RuleInfo.fetch(params[:rule_key])
            questions = rule_info.question_sample
            render json: { questions: questions }
            return
          end

          if params[:chart_rule_key] || params[:chart_scope_key]
            render json: { chartjs_datasets: ::TsMaster::RuleInfo.chartjs_datasets(params) }
            return
          end

          if params[:time_records_hash_fetch]
            render json: ::TsMaster::RuleInfo.time_records_hash(params)
            return
          end
        end
      end

      def create
        if command = params[:command]
          ::TsMaster::RuleInfo.public_send(command)
          render json: { message: command }
          return
        end

        @time_record = ::TsMaster::TimeRecord.create!(record_params.merge(user: current_user))
        @time_record.slack_notify
        render json: result_attributes
      end

      def update
        id = record_params[:id]
        @time_record = ::TsMaster::TimeRecord.find(id)
        @time_record.update!(entry_name: record_params[:entry_name])
        @time_record.slack_notify
        render json: result_attributes
      end

      def config_params
        {
          :rule_info        => ::TsMaster::RuleInfo,
          :scope_info       => ::TsMaster::ScopeInfo,
          :chart_scope_info => ::TsMaster::ChartScopeInfo,
          :per_page         => ::TsMaster::RuleInfo.per_page,
          :rank_max         => ::TsMaster::RuleInfo.rank_max,
          :count_all_gteq   => ::TsMaster::RuleInfo.count_all_gteq,
          :description      => ::TsMaster::RuleInfo.description,
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
