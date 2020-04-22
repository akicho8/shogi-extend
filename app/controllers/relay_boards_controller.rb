class RelayBoardsController < ApplicationController
  include EncodeMod
  include ShogiErrorRescueMod

  helper_method :relay_board_options
  helper_method :current_record
  helper_method :twitter_card_options

  let :relay_board_options do
    {
      record: current_record_as_json,
    }
  end

  def show
    if request.format.png?
      turn = current_record.turn_max
      png = current_record.to_dynamic_png(params.merge(turn: turn))
      turn = current_record.adjust_turn(turn)
      send_data png, type: Mime[:png], disposition: current_disposition, filename: "#{current_record.to_param}-#{turn}.png"
      return
    end

    if request.format.kif?
      text_body = current_record.to_cached_kifu(:kif)

      headers["Content-Type"] = current_type
      render plain: text_body
      return
    end
  end

  def create
    render json: { record: current_record_as_json }
  end

  def behavior_after_rescue(message)
    redirect_to controller_name.singularize.to_sym, danger: message
  end

  def current_record_as_json
    hash = current_record.as_json({
        only: [
          # :id,
          # :key,
          :sfen_body,
          :turn_max,
          # :image_turn,
          # :start_turn,
          # :critical_turn,
          # :outbreak_turn,
          # :battled_at,
        ],
        methods: [
          # :display_turn,
          # :player_info,
          # :title,
          # :description,
          :kento_app_path,
        ],
      })

    hash[:show_path] = url_for([:relay_board, body: current_record.sfen_body, only_path: true])
    hash[:kif_format_body] = current_record.to_cached_kifu(:kif)
    hash
  end

  def current_record
    @current_record ||= FreeBattle.same_body_fetch(params)
  end

  def current_image_path
    url_for([:relay_board, body: current_record.kifu_body, only_path: false, format: "png"])
  end

  def twitter_card_options
    {
      title: "リレー将棋 #{current_record.turn_max}手目",
      description: "",
      image: current_image_path,
    }
  end
end
