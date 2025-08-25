# -*- coding: utf-8 -*-

# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |-------------------+-------------------+----------------+---------------------+-------------------+-------|
# | name              | desc              | type           | opts                | refs              | index |
# |-------------------+-------------------+----------------+---------------------+-------------------+-------|
# | id                | ID                | integer(8)     | NOT NULL PK         |                   |       |
# | key               | 対局ユニークキー  | string(255)    | NOT NULL            |                   | A!    |
# | battled_at        | 対局日時          | datetime       | NOT NULL            |                   | C     |
# | csa_seq           | 棋譜              | text(16777215) | NOT NULL            |                   |       |
# | win_user_id       | 勝者              | integer(8)     |                     | => Swars::User#id | B     |
# | turn_max          | 手数              | integer(4)     | NOT NULL            |                   | D     |
# | meta_info         | メタ情報          | text(16777215) | NOT NULL            |                   |       |
# | created_at        | 作成日時          | datetime       | NOT NULL            |                   | M     |
# | updated_at        | 更新日時          | datetime       | NOT NULL            |                   |       |
# | start_turn        | 開始局面          | integer(4)     |                     |                   |       |
# | critical_turn     | 開戦              | integer(4)     |                     |                   | E     |
# | sfen_body         | SFEN形式棋譜      | text(65535)    | NOT NULL            |                   |       |
# | image_turn        | OGP画像の局面     | integer(4)     |                     |                   |       |
# | outbreak_turn     | Outbreak turn     | integer(4)     |                     |                   | F     |
# | accessed_at       | 最終アクセス日時  | datetime       | NOT NULL            |                   | G     |
# | sfen_hash         | Sfen hash         | string(255)    |                     |                   |       |
# | xmode_id          | Xmode             | integer(8)     | NOT NULL            |                   | H     |
# | preset_id         | Preset            | integer(8)     | NOT NULL            | => Preset#id      | I     |
# | rule_id           | Rule              | integer(8)     | NOT NULL            |                   | J     |
# | final_id          | Final             | integer(8)     | NOT NULL            |                   | K     |
# | analysis_version  | Analysis version  | integer(4)     | DEFAULT(0) NOT NULL |                   |       |
# | starting_position | Starting position | string(255)    |                     |                   |       |
# | imode_id          | Imode             | integer(8)     | NOT NULL            |                   | L     |
# |-------------------+-------------------+----------------+---------------------+-------------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# Preset.has_many :swars_battles
# 【警告:リレーション欠如】Swars::Userモデルで has_many :swars/battles されていません
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Swars::BattlesController, type: :controller, swars_spec: true do
  include SwarsSupport1

  let :record do
    Swars::Battle.first
  end

  describe "ERROR" do
    def case_ng(params)
      get :index, params: { query: "DevUser1", x_destroy_all: true, throttle_cache_clear: true, format: :json, **params }
      assert { response.status != 200 }
    end

    def case_ok(params)
      get :index, params: { query: "DevUser1", x_destroy_all: true, throttle_cache_clear: true, format: :json, **params }
      assert { response.status == 200 }
      json = JSON.parse(response.body, symbolize_names: true)
      assert { json[:xnotice][:infos][0][:message] }
    end

    it "本家の構造が変わった" do
      case_ng(SwarsFormatIncompatible: true)
    end

    it "本家に一時的にアクセスできない" do
      case_ng(RaiseConnectionFailed: true)
    end

    it "棋譜の不整合" do
      case_ok(query: "DevUser1", bs_error_capture_fake: true)
    end

    it "ウォーズIDの形式が異なる" do
      case_ok(query: "__UNKNOWN_USER")
    end

    it "ウォーズIDはあっているが本家でユーザーが存在しない" do
      case_ok(query: "UNKNOWN_USER", SwarsUserNotFound: true)
    end
  end

  describe "並び替え" do
    def case_ng(sort_column)
      get :index, params: { query: "DevUser1", sort_column: sort_column }
      assert { response.status == 200 }
    end

    it "works" do
      case_ng "xmode_id"
      case_ng "rule_id"
      case_ng "final_id"
      case_ng "preset_id"
      case_ng "membership.judge_id"
      case_ng "membership.location_id"
      case_ng "membership.grade_diff"
    end

    it "membership内カラムで並び替えかつ存在しないIDときエラーにならない" do
      get :index, params: { query: "__unknown__", sort_column: "membership.judge_id" }
      assert { response.status == 200 }
    end
  end

  # テストの詳細は search_spec.rb で書いているので簡単でよい
  describe "詳細検索" do
    describe "手合割" do
      it "平手" do
        get :index, params: { query: "DevUser1 手合割:平手" }
        assert { controller.current_scope.count == 1 }
        assert { response.status == 200 }
      end

      it "駒落ち" do
        get :index, params: { query: "DevUser1 手合割:-平手" }
        assert { controller.current_scope.count == 0 }
        assert { response.status == 200 }
      end
    end
  end

  describe "index" do
    it "index" do
      get :index
      assert { response.status == 200 }
    end

    it "index + query" do
      get :index, params: { query: "DevUser1" }
      assert { response.status == 200 }
      assert { assigns(:current_records).size == 1 }
      assert { assigns(:current_records).first.tournament_name == "将棋ウォーズ(10分)" }
    end

    describe "ウォーズの対局キーが含まれるURLで検索" do
      it "レコードあり" do
        get :index, params: { query: "https://shogiwars.heroz.jp/games/DevUser1-YamadaTaro-20200101_123401?tw=1" }
        assert { controller.current_scope.count == 1 }
        assert { response.status == 200 }
      end
      it "レコードなし" do
        get :index, params: { query: "https://kif-pona.heroz.jp/games/xxx-yyy-20200129_220847?tw=1" }
        assert { controller.current_scope.count == 0 }
        assert { response.status == 200 }
      end
    end

    describe "直接パラメータに指定する" do
      it "id" do
        get :index, params: { id: record.id }
        assert { response.status == 200 }
        assert { assigns(:current_records).size == 1 }
      end

      it "key" do
        get :index, params: { key: record.key }
        assert { response.status == 200 }
        assert { assigns(:current_records).size == 1 }
      end
    end

    xdescribe "ZIPダウンロード" do
      before do
        @current_user = user_login
      end

      describe "ダウンロードしたZIPファイルの内容が正しい" do
        def case_ng(body_encode)
          get :index, params: { query: "DevUser1", format: "zip", body_encode: body_encode }
          assert { response.status == 200 }
          assert { controller.current_scope.count == 1 }
          assert { response["Content-Disposition"].match?(/shogiwars.*.zip/) }
          assert { response.media_type == "application/zip" }

          Zip::InputStream.open(StringIO.new(response.body)) do |zis|
            entry = zis.get_next_entry
            assert { entry.name == "DevUser1/2020-01-01/DevUser1-YamadaTaro-20200101_123401.kif" }
            assert { entry.time.to_s == "2020-01-01 12:34:01 +0900" } # 奇数秒が入っていること
            bin = zis.read
            assert { NKF.guess(bin).to_s == body_encode }
          end
        end

        it { case_ng("UTF-8")     }
        it { case_ng("Shift_JIS") }
      end

      it "tagとsort_columnが含まれても正しい結果が返る" do
        get :index, params: { query: "YamadaTaro tag:対振り持久戦", sort_column: "membership.grade_diff", sort_order: "desc", download_config_fetch: "true", format: "json" }
        json = JSON.parse(response.body, symbolize_names: true)
        assert { json[:form_params_default] }
      end

      it "ダウンロード回数制限にひっかかる" do
        assert { @current_user.swars_zip_dl_logs.empty? }

        def case1(status)
          get :index, params: { query: "DevUser1", format: "zip" }
          assert { response.status == status }
        end

        case1(200)
        case1(200)
        case1(200)
        case1(404)

        assert { response.body.match?(/短時間にダウンロードする棋譜の総数が多すぎます/) }
      end
    end

    it "KENTO棋譜リストAPI" do
      get :index, params: { query: "DevUser1", format: "json", format_type: "kento" }
      assert { response.status == 200 }

      body = JSON.parse(response.body)
      assert { body["api_version"]                       == "2020-02-02"                                                  }
      assert { body["api_name"]                          == "将棋ウォーズ(ID:DevUser1)"                                   }
      assert { body["game_list"].size                    == 1                                                             }
      assert { body["game_list"][0]["tag"]               == ["将棋ウォーズ(10分)", "勝ち"]                      }
      assert { body["game_list"][0]["kifu_url"]          == "http://localhost:3000/w/DevUser1-YamadaTaro-20200101_123401.kif" }
      assert { body["game_list"][0]["display_name"]      == "DevUser1 三段 vs YamadaTaro 四段"                           }
      assert { body["game_list"][0]["display_timestamp"] == 1577849641                                                    }
    end
  end

  describe "show" do
    it "BODの場合はturnで示す局面に変化する" do
      get :show, params: { id: record.to_param, format: "bod", turn: 1 }
      response.body.should == <<~EOT
*詳細URL：http://localhost:4000/swars/battles/DevUser1-YamadaTaro-20200101_123401
*ぴよ将棋：http://localhost:4000/swars/battles/DevUser1-YamadaTaro-20200101_123401/piyo_shogi
*KENTO：http://localhost:4000/swars/battles/DevUser1-YamadaTaro-20200101_123401/kento
後手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ 歩 ・ ・ ・ ・|六
| 歩 歩 歩 歩 ・ 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
先手の持駒：なし
手数＝1 ▲５六歩(57) まで
後手番
EOT
    end

    it "PNG画像が見れる" do
      get :show, params: { id: record.to_param, format: "png", width: "", turn: 999 }
      assert { response.status == 302 }
    end

    describe "KIF 表示/DL" do
      it "棋譜の上部にリンクを含んでいる" do
        get :show, params: { id: record.to_param, format: "kif" }
        response.body.match?(/詳細URL：.*ぴよ将棋：.*KENTO：/)
      end

      it "表示(UTF-8)" do
        get :show, params: { id: record.to_param, format: "kif" }
        assert { response.media_type == "text/plain" }
        assert { response.body.encoding == Encoding::UTF_8 }
        assert { response.header["Content-Type"] == "text/plain; charset=UTF-8" }
        assert { response.header["Content-Disposition"] == nil }
      end

      it "表示(Shift_JIS)" do
        get :show, params: { id: record.to_param, format: "kif", body_encode: "Shift_JIS" }
        assert { response.media_type == "text/plain" }
        assert { response.body.encoding == Encoding::Shift_JIS }
        assert { response.header["Content-Type"] == "text/plain; charset=Shift_JIS" }
        assert { response.header["Content-Disposition"] == nil }
      end

      it "ダウンロード(Shift_JIS)" do
        get :show, params: { id: record.to_param, format: "kif", body_encode: "Shift_JIS", attachment: "true" }
        assert { response.media_type == "text/plain" }
        assert { response.body.encoding == Encoding::Shift_JIS }
        assert { response.header["Content-Type"] == "text/plain; charset=shift_jis" } # なぜかダウンロードのときだけ小文字に変換される
        assert { response.header["Content-Disposition"].include?("attachment") }
      end
    end

    it "本家で対局が見つからない" do
      get :show, params: { id: "alice-bob-20200101_123403", format: :json, x_destroy_all: true, throttle_cache_clear: true, BattleNotFound: true }
      assert { response.status != 200 }
      # json = JSON.parse(response.body, symbolize_names: true)
      # assert { json[:xnotice][:infos][0][:message] }
    end
  end
end
