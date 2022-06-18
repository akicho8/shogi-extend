# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |---------------+------------------+-------------+-------------+-------------------+-------|
# | name          | desc             | type        | opts        | refs              | index |
# |---------------+------------------+-------------+-------------+-------------------+-------|
# | id            | ID               | integer(8)  | NOT NULL PK |                   |       |
# | key           | 対局ユニークキー | string(255) | NOT NULL    |                   | A!    |
# | battled_at    | 対局日時         | datetime    | NOT NULL    |                   | B     |
# | csa_seq       | 棋譜             | text(65535) | NOT NULL    |                   |       |
# | win_user_id   | 勝者             | integer(8)  |             | => Swars::User#id | C     |
# | turn_max      | 手数             | integer(4)  | NOT NULL    |                   | D     |
# | meta_info     | メタ情報         | text(65535) | NOT NULL    |                   |       |
# | accessed_at   | 最終アクセス日時 | datetime    | NOT NULL    |                   | E     |
# | sfen_body     | SFEN形式棋譜     | text(65535) | NOT NULL    |                   |       |
# | sfen_hash     | Sfen hash        | string(255) | NOT NULL    |                   |       |
# | start_turn    | 開始局面         | integer(4)  |             |                   | F     |
# | critical_turn | 開戦             | integer(4)  |             |                   | G     |
# | outbreak_turn | Outbreak turn    | integer(4)  |             |                   | H     |
# | image_turn    | OGP画像の局面    | integer(4)  |             |                   |       |
# | created_at    | 作成日時         | datetime    | NOT NULL    |                   |       |
# | updated_at    | 更新日時         | datetime    | NOT NULL    |                   |       |
# | xmode_id      | Xmode            | integer(8)  | NOT NULL    |                   | I     |
# | preset_id     | Preset           | integer(8)  | NOT NULL    | => Preset#id      | J     |
# | rule_id       | Rule             | integer(8)  | NOT NULL    |                   | K     |
# | final_id      | Final            | integer(8)  | NOT NULL    |                   | L     |
# |---------------+------------------+-------------+-------------+-------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Preset.has_many :swars_battles
# 【警告:リレーション欠如】Swars::Userモデルで has_many :swars/battles されていません
#--------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Swars::BattlesController, type: :controller, swars_spec: true do
  include SwarsSupport

  let! :record do
    Swars::Battle.first
  end

  describe "ERROR" do
    def case1(params)
      get :index, params: { query: "devuser1", force: true, format: :json, **params }
      assert { response.status != 200 }
    end

    def case2(params)
      get :index, params: { force: true, format: :json, **params }
      assert { response.status == 200 }
      json = JSON.parse(response.body, symbolize_names: true)
      assert { json[:xnotice][:infos][0][:message] }
    end

    it "本家の構造が変わった" do
      case1(SwarsFormatIncompatible: true)
    end

    it "本家に一時的にアクセスできない" do
      case1(SwarsConnectionFailed: true)
    end

    it "棋譜の不整合" do
      case2(query: "devuser1", error_capture_fake: true)
    end

    it "本家でユーザーが存在しない" do
      case2(query: "__unknown__", SwarsUserNotFound: true, swars_user_destroy_all: true)
    end
  end

  describe "並び替え" do
    def case1(sort_column)
      get :index, params: { query: "devuser1", sort_column: sort_column }
      assert { response.status == 200 }
    end

    it "works" do
      case1 "xmode_id"
      case1 "rule_id"
      case1 "final_id"
      case1 "preset_id"
      case1 "membership.judge_id"
      case1 "membership.location_id"
      case1 "membership.grade_diff"
    end

    it "membership内カラムで並び替えかつ存在しないIDときエラーにならない" do
      get :index, params: {query: "__unknown__", sort_column: "membership.judge_id" }
      assert { response.status == 200 }
    end
  end

  # TODO テストは search_spec.rb で書く
  describe "詳細検索" do
    it "vs" do
      get :index, params: {query: "Yamada_Taro vs:devuser1"}
      assert { controller.current_scope.count == 1 }
    end

    it "judge" do
      get :index, params: {query: "devuser1 judge:win"}
      assert { controller.current_scope.count == 1 }
    end

    it "vs-grade" do
      get :index, params: {query: "devuser1 vs-grade:四段"}
      assert { controller.current_scope.count == 1 }
    end

    it "turn_max:>=500" do
      get :index, params: {query: "devuser1 turn_max:>=500"}
      assert { controller.current_scope.count == 0 }
      assert { response.status == 200 }
    end

    it "turn_max:<=500" do
      get :index, params: {query: "devuser1 turn_max:<=500"}
      assert { controller.current_scope.count == 1 }
      assert { response.status == 200 }
    end

    describe "手合割" do
      it "平手" do
        get :index, params: {query: "devuser1 手合割:平手"}
        assert { controller.current_scope.count == 1 }
        assert { response.status == 200 }
      end

      it "駒落ち" do
        get :index, params: {query: "devuser1 手合割:-平手"}
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
      get :index, params: {query: "devuser1"}
      assert { response.status == 200 }
      assert { assigns(:current_records).size == 1 }
      assert { assigns(:current_records).first.tournament_name == "将棋ウォーズ(10分)" }
    end

    describe "ウォーズの対局キーが含まれるURLで検索" do
      it "レコードあり" do
        get :index, params: {query: "https://shogiwars.heroz.jp/games/devuser1-Yamada_Taro-20200101_123401?tw=1"}
        assert { controller.current_scope.count == 1 }
        assert { response.status == 200 }
      end
      it "レコードなし" do
        get :index, params: {query: "https://kif-pona.heroz.jp/games/xxx-yyy-20200129_220847?tw=1"}
        assert { controller.current_scope.count == 0 }
        assert { response.status == 200 }
      end
    end

    describe "ZIPダウンロード" do
      before do
        user_login
      end

      def case1(body_encode)
        get :index, params: { query: "devuser1", format: "zip", body_encode: body_encode}
        assert { response.status == 200 }
        assert { controller.current_scope.count == 1 }
        assert { response["Content-Disposition"].match?(/shogiwars.*.zip/) }
        assert { response.media_type == "application/zip" }

        Zip::InputStream.open(StringIO.new(response.body)) do |zis|
          entry = zis.get_next_entry
          assert { entry.name == "devuser1/2020-01-01/devuser1-Yamada_Taro-20200101_123401.kif" }
          assert { entry.time.to_s == "2020-01-01 12:34:01 +0900" } # 奇数秒が入っていること
          bin = zis.read
          assert { NKF.guess(bin).to_s == body_encode }
        end
      end

      it { case1("UTF-8")     }
      it { case1("Shift_JIS") }

      it "tagとsort_columnが含まれても正しい結果が返る" do
        get :index, params: {query: "Yamada_Taro tag:対振り持久戦", sort_column: "membership.grade_diff", sort_order: "desc", download_config_fetch: "true", format: "json" }
        json = JSON.parse(response.body, symbolize_names: true)
        assert { json[:form_params_default] }
      end
    end

    it "KENTO棋譜リストAPI" do
      get :index, params: { query: "devuser1", format: "json", format_type: "kento" }
      assert { response.status == 200 }

      body = JSON.parse(response.body)
      assert { body["api_version"]                       == "2020-02-02"                                                  }
      assert { body["api_name"]                          == "将棋ウォーズ(ID:devuser1)"                                   }
      assert { body["game_list"].size                    == 1                                                             }
      assert { body["game_list"][0]["tag"]               == ["将棋ウォーズ(10分)", "勝ち"]                                }
      assert { body["game_list"][0]["kifu_url"]          == "http://test.host/w/devuser1-Yamada_Taro-20200101_123401.kif" }
      assert { body["game_list"][0]["display_name"]      == "devuser1 三段 vs Yamada_Taro 四段"                           }
      assert { body["game_list"][0]["display_timestamp"] == 1577849641                                                    }
    end
  end

  describe "show" do
    it "PNG画像が見れる" do
      get :show, params: { id: record.to_param, format: "png", width: "", turn: 999 }
      assert { response.status == 302 }
    end

    describe "KIF 表示/DL" do
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
      get :show, params: { id: "xxx", format: :json, SwarsBattleNotFound: true }
      assert { response.status != 200 }
      # json = JSON.parse(response.body, symbolize_names: true)
      # assert { json[:xnotice][:infos][0][:message] }
    end
  end
end
