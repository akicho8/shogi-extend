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
      chartjs_params: {
        data: {
          datasets: graph_datasets,
        },
      },
    }
  end

  private

  def graph_datasets
    xy_rule_key = "xy_rule100"
    count_all_gteq = 10
    date_gteq = 6.month.ago

    scope = XyRecord.all

    scope = scope.where(xy_rule_key: xy_rule_key).where(XyRecord.arel_table[:created_at].gteq(date_gteq))
    names_hash = scope.group("entry_name").order("count_all desc").having("count_all >= #{count_all_gteq}").count
    result = scope.select("entry_name, date(convert_tz(created_at, 'UTC', 'Asia/Tokyo')) as created_on, min(spent_sec) as spent_sec").group("entry_name, created_on")

    names_hash.collect.with_index { |(name, _), i|
      palette = PaletteInfo.fetch(i.modulo(PaletteInfo.count))
      v = result.find_all { |e| e.entry_name == name }
      {
        label: name,
        data: v.collect { |e| {x: e.created_on, y: e.spent_sec } },
        backgroundColor: palette.background_color,
        borderColor: palette.border_color,
        fill: false,

        pointRadius: 2,           # 点半径
        borderWidth: 2,           # 点枠の太さ
        pointHoverRadius: 3,      # 点半径(アクティブ時)
        pointHoverBorderWidth: 2, # 点枠の太さ(アクティブ時)
        showLine: true,           # 線で繋げる

      }
    }.compact

    # v = XyRecord.select("date(created_at) as created_on, min(spent_sec) as spent_sec").where(entry_name: "きなこもち").where(xy_rule_key: "xy_rule100").group("date(created_at)")
    # v = v.collect { |e| {x: e.created_on, y: e.spent_sec } }
    # puts v.to_json
    # # >> [{"x":"2019-08-10","y":171.772},{"x":"2019-08-11","y":161.548},{"x":"2019-08-12","y":157.918},{"x":"2019-08-13","y":146.687},{"x":"2019-08-14","y":142.752},{"x":"2019-08-15","y":139.364},{"x":"2019-08-16","y":133.889},{"x":"2019-08-17","y":130.848},{"x":"2019-08-18","y":130.095},{"x":"2019-08-19","y":123.119},{"x":"2019-08-20","y":131.65},{"x":"2019-08-21","y":120.522},{"x":"2019-08-22","y":118.307},{"x":"2019-08-23","y":114.063},{"x":"2019-08-24","y":113.073},{"x":"2019-08-25","y":109.149},{"x":"2019-08-26","y":108.687},{"x":"2019-08-27","y":110.269},{"x":"2019-08-28","y":104.478},{"x":"2019-08-29","y":105.316},{"x":"2019-08-30","y":105.476},{"x":"2019-08-31","y":103.375},{"x":"2019-09-01","y":105.116},{"x":"2019-09-02","y":100.815},{"x":"2019-09-03","y":100.654},{"x":"2019-09-04","y":98.631},{"x":"2019-09-05","y":97.019},{"x":"2019-09-06","y":99.751},{"x":"2019-09-07","y":99.185},{"x":"2019-09-08","y":103.74},{"x":"2019-09-09","y":97.968},{"x":"2019-09-10","y":95.1},{"x":"2019-09-11","y":94.568},{"x":"2019-09-12","y":94.953},{"x":"2019-09-13","y":92.09},{"x":"2019-09-14","y":89.048},{"x":"2019-09-15","y":89.181},{"x":"2019-09-16","y":93.073},{"x":"2019-09-17","y":89.913},{"x":"2019-09-18","y":86.798},{"x":"2019-09-19","y":83.755},{"x":"2019-09-20","y":86.758},{"x":"2019-09-21","y":86.481},{"x":"2019-09-22","y":83.531},{"x":"2019-09-23","y":89.281},{"x":"2019-09-24","y":85.422},{"x":"2019-09-25","y":89.183},{"x":"2019-09-26","y":85.196},{"x":"2019-09-27","y":88.264},{"x":"2019-09-28","y":88.116},{"x":"2019-09-29","y":91.133},{"x":"2019-09-30","y":85.814},{"x":"2019-10-01","y":84.215},{"x":"2019-10-02","y":86.432},{"x":"2019-10-03","y":89.516},{"x":"2019-10-04","y":84.116},{"x":"2019-10-06","y":92.616},{"x":"2019-10-07","y":88.281},{"x":"2019-10-08","y":81.199},{"x":"2019-10-09","y":89.332},{"x":"2019-10-10","y":85.231},{"x":"2019-10-11","y":89.032}]
    #
    # datasets: 1.times.collect { |i|
    #   {
    #     label: wl.name,
    #     data: memberships.find_all { |e| e.judge_key.to_sym == wl.key }.collect { |e| { t: e.battle.battled_at.midnight.to_s(:ymdhms), y: e.battle.battled_at.hour * 1.minute + e.battle.battled_at.min } },
    #     backgroundColor: wl.palette.background_color,
    #     borderColor: wl.palette.border_color,
    #     pointRadius: 4,           # 点半径
    #     borderWidth: 2,           # 点枠の太さ
    #     pointHoverRadius: 5,      # 点半径(アクティブ時)
    #     pointHoverBorderWidth: 3, # 点枠の太さ(アクティブ時)
    #     fill: false,
    #     showLine: false,          # 線で繋げない
    #   }
    # },
  end

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
