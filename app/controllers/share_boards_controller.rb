# 指し継ぎリレー将棋盤
#
# entry
#   app/controllers/share_boards_controller.rb
#
# vue
#   app/javascript/share_board.vue
#
# model
#   app/models/share_board_mod.rb
#
# view
#   app/views/share_boards/show.html.slim
#
# test
#   spec/controllers/share_boards_controller_spec.rb
#
# url
#   http://localhost:3000/share-board
#
class ShareBoardsController < ApplicationController
  include EncodeMod
  include ShogiErrorRescueMod

  def show
    current_record.update_columns(accessed_at: Time.current)

    if request.format.json?
      create
      return
    end

    # http://localhost:3000/share-board.png?body=position+sfen+lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1+moves+2g2f
    if request.format.png?
      png = current_record.to_dynamic_png(params.merge(turn: initial_turn, flip: current_flip))
      send_data png, type: Mime[:png], disposition: current_disposition, filename: "#{current_record.to_param}-#{initial_turn}.png"
      return
    end

    # 棋譜の内容は最初に渡している
    # # http://localhost:3000/share-board.kif?body=position+sfen+lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1+moves+2g2f
    # if request.format.kif?
    #   text_body = current_record.to_cached_kifu(:kif)
    #   headers["Content-Type"] = current_type
    #   render plain: text_body
    #   return
    # end
  end

  def create
    render json: { record: current_json }
  end

  def current_vue_args
    { record: current_json }
  end

  def twitter_card_options
    {
      title: "#{current_title} #{initial_turn}手目".squish,
      image: current_image_path,
      description: params[:description] || "",
    }
  end

  def current_title
    params[:title].presence || "指し継ぎリレー将棋"
  end

  private

  def behavior_after_rescue(message)
    redirect_to controller_name.singularize.to_sym, danger: message
  end

  def current_json
    attrs = current_record.as_json(only: [:sfen_body, :turn_max], methods: [:kento_app_path])
    # attrs[:show_path] = url_for([:share_board, body: current_record.sfen_body, only_path: true])
    attrs[:kif_format_body] = current_record.to_cached_kifu(:kif)
    attrs[:initial_turn] = initial_turn
    attrs[:preset_info] = { name: current_record.preset_info.name, handicap_shift: current_record.preset_info.handicap ? 1 : 0 }
    attrs
  end

  def current_record
    @current_record ||= FreeBattle.same_body_fetch(params)
  end

  def current_image_path
    url_for([:share_board, body: current_record.sfen_body, only_path: false, format: "png"])
  end

  def initial_turn
    v = (params[:turn].presence || current_record.turn_max).to_i
    current_record.adjust_turn(v)
  end

  def current_flip
    if v = params[:flip].presence
      return boolean_cast(v)
    end
    (initial_turn + (current_record.preset_info.handicap ? 1 : 0)).even?
  end
end
