# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xy record (xy_records as XyRecord)
#
# |-------------------+----------------+-------------+-------------+------+-------|
# | name              | desc           | type        | opts        | refs | index |
# |-------------------+----------------+-------------+-------------+------+-------|
# | id                | ID             | integer(8)  | NOT NULL PK |      |       |
# | name              | Name           | string(255) |             |      |       |
# | summary           | Summary        | string(255) |             |      |       |
# | rule_key          | Rule key       | string(255) |             |      |       |
# | colosseum_user_id | Colosseum user | integer(8)  |             |      | A     |
# | o_count_max       | O count max    | integer(4)  |             |      |       |
# | o_count           | O count        | integer(4)  |             |      |       |
# | x_count           | X count        | integer(4)  |             |      |       |
# | spent_msec        | Spent msec     | float(24)   |             |      |       |
# | created_at        | 作成日時       | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時       | datetime    | NOT NULL    |      |       |
# |-------------------+----------------+-------------+-------------+------+-------|
#
#- Remarks ----------------------------------------------------------------------
# [Warning: Need to add relation] XyRecord モデルに belongs_to :colosseum_user を追加してください
#--------------------------------------------------------------------------------

class XyRecordsController < ApplicationController
  def index
  end

  def create
    @xy_record = XyRecord.create!(current_params)
    render json: result_attributes
  end

  def update
    id = current_params[:id]
    @xy_record = XyRecord.find(id)
    @xy_record.update!(name: current_params[:name])
    render json: result_attributes
  end

  helper_method :js_index_options

  let :js_index_options do
    {
      xhr_post_path: url_for([:xy_records, format: "json"]),
      rule_list: XyGameRanking.rule_list,
    }
  end

  def result_attributes
    {
      xhr_put_path: url_for([@xy_record, format: "json"]),
      xy_record: @xy_record.as_json(methods: [:computed_rank]),
      rule_list: XyGameRanking.rule_list,
    }
  end

  def current_params
    params.permit![:xy_record]
  end
end
