# リレー将棋盤
#
# entry
#   app/controllers/relay_boards_controller.rb
# model
#   app/models/relay_board_mod.rb
# vue
#   app/javascript/relay_board.vue
# view
#   app/views/relay_boards/show.html.slim
# test
#   spec/controllers/relay_boards_controller_spec.rb
# url
#   http://localhost:3000/relay-board
#
class RelayBoardsController < ApplicationController
  include EncodeMod
  include ShogiErrorRescueMod

  def show
    current_record.update_columns(accessed_at: Time.current)

    # http://localhost:3000/relay-board.png?body=position+sfen+lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1+moves+2g2f
    if request.format.png?
      turn = current_record.turn_max
      png = current_record.to_dynamic_png(params.merge(turn: turn))
      turn = current_record.adjust_turn(turn)
      send_data png, type: Mime[:png], disposition: current_disposition, filename: "#{current_record.to_param}-#{turn}.png"
      return
    end

    # http://localhost:3000/relay-board.kif?body=position+sfen+lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1+moves+2g2f
    if request.format.kif?
      text_body = current_record.to_cached_kifu(:kif)
      headers["Content-Type"] = current_type
      render plain: text_body
      return
    end
  end

  def create
    render json: { record: current_json }
  end

  def current_vue_args
    { record: current_json }
  end

  def twitter_card_options
    {
      title: "リレー将棋 #{current_record.turn_max}手目",
      image: current_image_path,
      description: "",
    }
  end

  private

  def behavior_after_rescue(message)
    redirect_to controller_name.singularize.to_sym, danger: message
  end

  def current_json
    attrs = current_record.as_json(only: [:sfen_body, :turn_max], methods: [:kento_app_path])
    attrs[:show_path] = url_for([:relay_board, body: current_record.sfen_body, only_path: true])
    attrs[:kif_format_body] = current_record.to_cached_kifu(:kif)
    attrs
  end

  def current_record
    @current_record ||= FreeBattle.same_body_fetch(params)
  end

  def current_image_path
    url_for([:relay_board, body: current_record.sfen_body, only_path: false, format: "png"])
  end
end
