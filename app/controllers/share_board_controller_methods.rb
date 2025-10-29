# 共有将棋盤
#
# url
#   http://localhost:3000/share-board
#   http://localhost:3000/share-board?body=position+sfen+ln1g1g1nl%2F1ks2r3%2F1pppp1bpp%2Fp3spp2%2F9%2FP1P1SP1PP%2F1P1PP1P2%2F1BK1GR3%2FLNSG3NL+b+-+1&turn=0&title=%E3%83%AA%E3%83%AC%E3%83%BC%E5%B0%86%E6%A3%8B&viewpoint=black
#   http://localhost:3000/share-board.png?body=position+sfen+ln1g1g1nl%2F1ks2r3%2F1pppp1bpp%2Fp3spp2%2F9%2FP1P1SP1PP%2F1P1PP1P2%2F1BK1GR3%2FLNSG3NL+b+-+1&turn=0&title=%E3%83%AA%E3%83%AC%E3%83%BC%E5%B0%86%E6%A3%8B&viewpoint=black
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

module ShareBoardControllerMethods
  extend ActiveSupport::Concern

  included do
    include EncodeMethods
    include KifShowMethods
    include ShogiErrorRescueMethods
  end

  def show
    # http://localhost:3000/share-board.kif
    # render plain: session.id.to_s
    # return
    # render plain: sb_session_counter
    # return

    # session[:a] ||= 0
    # session[:a] += 1
    # render plain: session[:a].inspect
    # return

    # raise params.inspect

    # nginx の設定で /share-board.\w+ は Rails 側にリクエストが来る
    # そこで format の指定がなかったり HTML だったりする場合にのみ Nuxt 側に飛ばす
    # 本当は Rails 側を経由したくないがこれまでの互換性を考慮するとこうするしかない
    #
    #   /share-board.html → /share-board
    #   /share-board.png  → Rails側で処理
    #
    if params[:format].blank? || request.format.html?
      query = params.permit!.to_h.except(:controller, :action, :format).to_query.presence
      redirect_to UrlProxy.url_for(["/share-board", query].compact.join("?")), allow_other_host: true
      return
    end

    # http://localhost:3000/share-board.png?color_theme_key=is_color_theme_real&color_theme_preview_image_use=true
    if request.format.png?
      if params[:color_theme_preview_image_use].to_s == "true"
        color_theme_key = params[:color_theme_key].presence || "is_color_theme_modern"
        path = Gem.find_files("bioshogi/assets/images/color_theme_preview/#{color_theme_key}.png").first || Rails.root.join("app/assets/images/fallback.png")
        if stale?(last_modified: Pathname(path).mtime, public: true)
          send_file path, type: Mime[:png], disposition: :inline
          # send_data Pathname(path).read, type: Mime[:png], disposition: :inline
        end
        return
      end
    end

    # アクセスがあれば「上げて」消さないようにするため
    current_record.update_columns(:accessed_at => Time.current)

    if request.format.json?
      render json: config_params
      return
    end

    # Twitter画像
    # http://localhost:3000/share-board.png?body=position+sfen+lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1+moves+2g2f
    # パラメータで画像が変化するためキャッシュは危険
    # Rails側でレコードを作ってキャッシュするときに見ているのはSFENだけ
    if request.format.png?
      # リダイレクトすると Twitter Card が不安定になり、Card Validator では実際警告が出ているため、
      # Twitter では og:image のパスは直接画像を返さないといけない
      # Developer Tool でキャッシュOFFでリロードすると確認すると2回目が 302 で返され send_file がスキップされていることがわかる
      # params2 = params.slice(*Bioshogi::BinaryFormatter.all_options.keys)
      params2 = params.merge(recipe_key: :is_recipe_png, turn: initial_turn, viewpoint: viewpoint)
      params2[:color_theme_key] ||= "is_color_theme_modern"
      media_builder = MediaBuilder.new(current_record, params2)
      path = media_builder.to_real_path
      if stale?(last_modified: path.mtime, public: true)
        send_file path, type: Mime[media_builder.recipe_info.real_ext], disposition: current_disposition, filename: current_filename
      end

      return
    end

    # http://localhost:3000/share-board.kif
    # http://localhost:3000/share-board.ki2
    # http://localhost:3000/share-board.sfen
    # http://localhost:3000/share-board.csa
    # params[:title] ||= current_title ← これを入れると「共有将棋盤」がかならず表示される
    kif_data_send
  end

  def config_params
    {
      record: current_json,
      twitter_card_options: twitter_card_options,
    }
  end

  def twitter_card_options
    {
      :title       => current_page_title,
      :image       => current_og_image_path,
      :description => params[:description].presence || current_record.simple_versus_desc || "",
    }
  end

  def current_title
    params[:title].presence || "共有将棋盤"
  end

  def current_page_title
    [current_title, turn_full_message].compact.join(" ")
  end

  # これは JS 側で作る手もある。そうすればリアルタイムに更新できる。が、og:image なのでリアルタイムな必要がない。迷う。
  # API 単体として使う場合は API の方で作っておいた方が都合がよい
  # ので、こっちで作るのであってる
  # http://localhost:3000/api/share_board.json?turn=1&title=%E3%81%82%E3%81%84%E3%81%88%E3%81%86%E3%81%8A
  def current_og_image_path
    # ../../nuxt_side/components/ShareBoard/ShareBoardApp.vue の permalink_for と一致させること
    args = params.to_unsafe_h.except(:action, :controller, :format)
    args = args.merge({
        :turn      => initial_turn,
        :title     => current_title,
        :body      => current_record.sfen_body,
        :viewpoint => viewpoint,
      })
    "/share-board.png?#{args.to_query}"
  end

  private

  def current_filename
    basename = params[:title].presence || current_record.to_param
    "#{basename}-#{initial_turn}.#{params[:format]}"
  end

  def turn_full_message
    if initial_turn.nonzero?
      "#{initial_turn}手目"
    end
  end

  # HTMLはリダイレクトしてしまうのでそのまま表示する
  def behavior_after_rescue(message)
    # redirect_to controller_name.singularize.to_sym, danger: message
    # render html: message.html_safe
    render html: message.html_safe
  end

  def current_json
    attrs = current_record.as_json(only: [:sfen_body, :turn_max])
    attrs = attrs.merge({
        :initial_turn    => initial_turn,
        :viewpoint       => viewpoint,
        :title           => current_title,
      })

    # リアルタイム共有
    attrs = attrs.merge({
        # :room_key => params[:room_key] || "",
        :connection_id   => StringSupport.secure_random_urlsafe_base64_token,
        :client_token      => sb_client_token,
        :session_counter => sb_session_counter,
        :API_VERSION     => AppConfig[:share_board_api_version], # これとActionCableで返すバージョンを比較する
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

  def viewpoint_info
    ViewpointInfo.fetch(viewpoint)
  end

  def viewpoint
    key = params[:viewpoint]
    key ||= params[:abstract_viewpoint] # 誰かがブックマークしているかもしれないため過去のキーも使えるようにしておく
    ViewpointInfo.lookup_key(key, :black)
  end

  # 駒落ちを考慮した擬似ターン数
  def number_of_turns_in_consideration_of_the_frame_dropping
    current_record.sfen_info.location.code + initial_turn
  end

  def sb_client_token
    session[:sb_client_token] ||= SecureRandom.hex
  end

  def sb_session_counter
    session[:sb_session_counter] ||= 0
    session[:sb_session_counter] += 1
  end
end
