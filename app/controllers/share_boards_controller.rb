# 共有将棋盤
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
#   http://localhost:3000/share-board?body=position+sfen+ln1g1g1nl%2F1ks2r3%2F1pppp1bpp%2Fp3spp2%2F9%2FP1P1SP1PP%2F1P1PP1P2%2F1BK1GR3%2FLNSG3NL+b+-+1&turn=0&title=%E3%83%AA%E3%83%AC%E3%83%BC%E5%B0%86%E6%A3%8B&image_view_point=self
#   http://localhost:3000/share-board.png?body=position+sfen+ln1g1g1nl%2F1ks2r3%2F1pppp1bpp%2Fp3spp2%2F9%2FP1P1SP1PP%2F1P1PP1P2%2F1BK1GR3%2FLNSG3NL+b+-+1&turn=0&title=%E3%83%AA%E3%83%AC%E3%83%BC%E5%B0%86%E6%A3%8B&image_view_point=black
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
  concerning :ShareBoardMod do
    included do
      include EncodeMod
      include KifShowMod
      include ShogiErrorRescueMod
    end

    def show
      # http://localhost:3000/share-board
      if request.format.html?
        query = params.permit!.to_h.except(:controller, :action).to_query.presence
        if Rails.env.development? || Rails.env.test?
          redirect_to UrlProxy.wrap(["/share-board", query].compact.join("?"))
        else
          redirect_to ["/app/share-board", query].compact.join("?")
        end
        # redirect_to UrlProxy.wrap(["/share-board", query].compact.join("?"))
        # redirect_to UrlProxy.wrap(["/app/share-board", query].compact.join("?"))
        return
      end

      # アクセスがあれば「上げて」消さないようにするため
      current_record.update_columns(accessed_at: Time.current)

      if request.format.json?
        if params[:info_fetch]
          render json: info_params
          return
        end
      end

      # Twitter画像
      # http://localhost:3000/share-board.png?body=position+sfen+lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1+moves+2g2f
      if request.format.png?
        png = current_record.to_dynamic_png(params.merge(turn: initial_turn, flip: image_flip))
        send_data png, type: Mime[:png], disposition: current_disposition, filename: current_filename
        return
      end

      # http://localhost:3000/share-board.kif
      # http://localhost:3000/share-board.ki2
      # http://localhost:3000/share-board.sfen
      # http://localhost:3000/share-board.csa
      kif_data_send
    end

    def current_filename
      "#{current_record.to_param}-#{initial_turn}.#{params[:format]}"
    end

    def info_params
      {
        record: current_json,
        twitter_card_options: twitter_card_options,
      }
    end

    def twitter_card_options
      {
        :title       => current_page_title,
        :image       => current_image_path,
        :description => params[:description].presence || current_record.simple_versus_desc,
      }
    end

    def current_title
      params[:title].presence || "共有将棋盤"
    end

    def current_page_title
      [current_title, turn_full_message].compact.join(" ")
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

    def turn_full_message
      if initial_turn.nonzero?
        "#{initial_turn}手目"
      end
    end

    def behavior_after_rescue(message)
      redirect_to controller_name.singularize.to_sym, danger: message
    end

    def current_json
      attrs = current_record.as_json(only: [:sfen_body, :turn_max])
      attrs = attrs.merge({
          :initial_turn     => initial_turn,
          :board_flip       => board_flip,
          :image_view_point => image_view_point,
          :title            => current_title,
        })

      # リアルタイム共有
      attrs = attrs.merge({
          :room_code => params[:room_code] || "",
          :user_code => SecureRandom.hex,
        })

      attrs
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
      ImageViewPointInfo.valid_key(params[:image_view_point], :self)
    end

    # 駒落ちを考慮した擬似ターン数
    def number_of_turns_in_consideration_of_the_frame_dropping
      current_record.sfen_info.location.code + initial_turn
    end
  end
end
