# リレー将棋
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
# experiment
#   experiment/0850_share_board.rb
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
# ・指したら record を nil に設定している→やめ
# ・そうするとメニューで「棋譜コピー」したときに record がないためこちらの create を叩きにくる→やめ
# ・そこで kif_format_body を入れているので、指したあとの棋譜コピーは常に最新になっている→やめ
#
# iPhoneのSafariのみの問題
#  ・1手動かしてURLを更新する
#  ・アドレスバーからコピーしてslackに貼る
#  ・このとき見た目は share-board?body=position だけど
#  ・リンクは         share-board?body%3Dposition になっている
#  ・ので不正なアドレスと認識される。Chrome では問題なし
#
class ShareBoardsController < ApplicationController
  include EncodeMod
  include ShogiErrorRescueMod

  def show
    # アクセスがあれば「上げて」消さないようにするため
    current_record.update_columns(accessed_at: Time.current)

    # デバッグ用
    if request.format.json?
      render json: info_params
      return
    end

    # Twitter画像
    # http://localhost:3000/share-board.png?body=position+sfen+lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1+moves+2g2f
    if request.format.png?
      png = current_record.to_dynamic_png(params.merge(turn: initial_turn, flip: image_flip))
      send_data png, type: Mime[:png], disposition: current_disposition, filename: "#{current_record.to_param}-#{initial_turn}.png"
      return
    end

    # ぴよ将棋用にkifを返す
    # http://localhost:3000/share-board.kif?body=position+sfen+lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1+moves+2g2f
    #
    # TODO: ぴよ将棋に url=http://.../foo.kif?body=position... のように渡せればこの部分は汎用化できる
    if request.format.kif?
      text_body = current_record.fast_parsed_info.to_kif(no_embed_if_time_blank: true)
      headers["Content-Type"] = current_type
      render plain: text_body
      return
    end
  end

  # share_board(:info="#{controller.info_params.to_json}")
  def info_params
    { record: current_json }
  end

  def twitter_card_options
    {
      :title       => [current_title, "#{initial_turn}手目"].compact.join(" "),
      :image       => current_image_path,
      :description => params[:description].presence || current_record.simple_versus_desc,
    }
  end

  def current_title
    params[:title].presence
  end

  def current_image_path
    if false
      # params[:image_flip] が渡せていない
      url_for([:share_board, body: current_record.sfen_body, only_path: false, format: "png", turn: initial_turn, image_view_point: image_view_point])
    else
      # params[:image_flip] をそのまま渡すために params にマージしないといけない
      url_for(params.to_unsafe_h.merge(body: current_record.sfen_body, format: "png"))
    end
  end

  private

  def behavior_after_rescue(message)
    redirect_to controller_name.singularize.to_sym, danger: message
  end

  def current_json
    attrs = current_record.as_json(only: [:sfen_body, :turn_max])
    attrs.merge({
        :initial_turn     => initial_turn,
        :board_flip       => board_flip,
        :image_view_point => image_view_point,
      })
  end

  def current_record
    @current_record ||= FreeBattle.same_body_fetch(params)
  end

  def initial_turn
    v = (params[:turn].presence || current_record.turn_max).to_i
    current_record.adjust_turn(v)
  end

  def board_flip
    if v = params[:board_flip].presence
      return boolean_for(v)
    end
    number_of_turns_in_consideration_of_the_frame_dropping.odd?
  end

  def image_flip
    if v = params[:image_flip].presence
      return boolean_for(v)
    end
    image_view_point_info.image_flip[number_of_turns_in_consideration_of_the_frame_dropping]
  end

  def image_view_point_info
    ImageViewPointInfo.fetch(image_view_point)
  end

  def image_view_point
    (params[:image_view_point].presence || image_view_point_default).to_sym
  end

  def image_view_point_default
    :self
  end

  # 駒落ちを考慮した擬似ターン数
  def number_of_turns_in_consideration_of_the_frame_dropping
    current_record.sfen_info.location.code + initial_turn
  end
end
