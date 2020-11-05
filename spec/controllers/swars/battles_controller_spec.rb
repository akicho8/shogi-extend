# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |---------------+------------------+--------------+-------------+-------------------+-------|
# | name          | desc             | type         | opts        | refs              | index |
# |---------------+------------------+--------------+-------------+-------------------+-------|
# | id            | ID               | integer(8)   | NOT NULL PK |                   |       |
# | key           | 対局ユニークキー | string(255)  | NOT NULL    |                   | A!    |
# | battled_at    | 対局日時         | datetime     | NOT NULL    |                   | G     |
# | rule_key      | ルール           | string(255)  | NOT NULL    |                   | B     |
# | csa_seq       | 棋譜             | text(65535)  | NOT NULL    |                   |       |
# | final_key     | 結末             | string(255)  | NOT NULL    |                   | C     |
# | win_user_id   | 勝者             | integer(8)   |             | => Swars::User#id | D     |
# | turn_max      | 手数             | integer(4)   | NOT NULL    |                   | H     |
# | meta_info     | メタ情報         | text(65535)  | NOT NULL    |                   |       |
# | accessed_at   | 最終アクセス日時 | datetime     | NOT NULL    |                   |       |
# | outbreak_turn | Outbreak turn    | integer(4)   |             |                   | E     |
# | created_at    | 作成日時         | datetime     | NOT NULL    |                   |       |
# | updated_at    | 更新日時         | datetime     | NOT NULL    |                   |       |
# | preset_key    | 手合割           | string(255)  | NOT NULL    |                   | F     |
# | start_turn    | 開始局面         | integer(4)   |             |                   | I     |
# | critical_turn | 開戦             | integer(4)   |             |                   | J     |
# | sfen_body     | SFEN形式棋譜     | string(8192) | NOT NULL    |                   |       |
# | image_turn    | OGP画像の局面    | integer(4)   |             |                   |       |
# | sfen_hash     | Sfen hash        | string(255)  | NOT NULL    |                   |       |
# |---------------+------------------+--------------+-------------+-------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# 【警告:リレーション欠如】Swars::Userモデルで has_many :swars/battles されていません
#--------------------------------------------------------------------------------

require 'rails_helper'

RSpec.describe Swars::BattlesController, type: :controller do
  before do
    swars_battle_setup
  end

  let :record do
    Swars::Battle.first
  end

  describe "詳細検索" do
    it "vs:tag" do
      user1, user2 = record.memberships.collect { |e| e.user.key }
      get :index, params: {query: "#{user1} vs:#{user2}"}
      assert { controller.current_scope.count == 1 }
    end

    it "judge:tag" do
      get :index, params: {query: "devuser1 judge:win"}
      assert { controller.current_scope.count == 1 }
    end
  end

  describe "index" do
    it "index" do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it "index + query" do
      get :index, params: {query: "devuser1"}
      expect(response).to have_http_status(:ok)
      assert { assigns(:current_records).size == 1 }
      assert { assigns(:current_records).first.tournament_name == "将棋ウォーズ(10分)" }
    end

    describe "turn_max:>=500" do
      it do
        get :index, params: {query: "devuser1 turn_max:>=500"}
        assert { controller.current_scope.count == 0 }
        expect(response).to have_http_status(:ok)
      end
      it do
        get :index, params: {query: "devuser1 turn_max:<=500"}
        assert { controller.current_scope.count == 1 }
        expect(response).to have_http_status(:ok)
      end
    end

    it "ウォーズの対局キーが含まれるURLで検索" do
      get :index, params: {query: "https://shogiwars.heroz.jp/games/xxx-yyy-20200129_220847?tw=1"}
      assert { controller.current_scope.count == 1 }
      expect(response).to have_http_status(:ok)

      get :index, params: {query: "https://kif-pona.heroz.jp/games/xxx-yyy-20200129_220847?tw=1"}
      assert { controller.current_scope.count == 1 }
      expect(response).to have_http_status(:ok)
    end

    it "ZIPダウンロード" do
      get :index, params: { query: "devuser1", format: "zip" }
      expect(response).to have_http_status(:ok)
      assert { controller.current_scope.count == 1 }
      assert { response["Content-Disposition"].match?(/shogiwars-devuser1-\d+_\d+-kif-utf8-1.zip/) }
      assert { response.media_type == "application/zip" }
    end

    it "KENTO棋譜リストAPI" do
      get :index, params: { query: "devuser1", format: "json", format_type: "kento" }
      expect(response).to have_http_status(:ok)

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
    it "png" do
      get :show, params: {id: record.to_param, format: "png", width: "", turn: 999}
      expect(response).to have_http_status(:ok)
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
        get :show, params: { id: record.to_param, format: "kif", body_encode: "sjis" }
        assert { response.media_type == "text/plain" }
        assert { response.body.encoding == Encoding::Shift_JIS }
        assert { response.header["Content-Type"] == "text/plain; charset=Shift_JIS" }
        assert { response.header["Content-Disposition"] == nil }
      end

      it "ダウンロード(Shift_JIS)" do
        get :show, params: { id: record.to_param, format: "kif", body_encode: "sjis", attachment: "true" }
        assert { response.media_type == "text/plain" }
        assert { response.body.encoding == Encoding::Shift_JIS }
        assert { response.header["Content-Type"] == "text/plain; charset=shift_jis" } # なぜかダウンロードのときだけ小文字に変換される
        assert { response.header["Content-Disposition"].include?("attachment") }
      end
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ............
# >>
# >> Finished in 8.72 seconds (files took 4.93 seconds to load)
# >> 12 examples, 0 failures
# >>
