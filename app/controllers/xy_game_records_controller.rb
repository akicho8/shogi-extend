class XyGameRecordsController < ApplicationController
  def show
  end

  def create
    if current_params[:id].blank?
      xy_game_record = XyGameRecord.create!(current_params)
    end

    if id = current_params[:id]
      xy_game_record = XyGameRecord.find(id)
      xy_game_record.update!(name: current_params[:name])
    end

    render json: {
      xhr_put_path: url_for([xy_game_record, format: "json"]),
      xy_game_record: xy_game_record.as_json(methods: [:computed_rank]),
      rule_list: XyGameRanking.rule_list,
    }
  end

  helper_method :js_show_options

  let :js_show_options do
    {
      xhr_post_path: url_for([:xy_game_records, format: "json"]),
      rule_list: XyGameRanking.rule_list,
    }
  end

  def current_params
    params.permit![:xy_game_record]
  end
end
