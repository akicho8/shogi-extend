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
# | battled_at    | 対局日時         | datetime     | NOT NULL    |                   | B     |
# | rule_key      | ルール           | string(255)  | NOT NULL    |                   | C     |
# | csa_seq       | 棋譜             | text(65535)  | NOT NULL    |                   |       |
# | final_key     | 結末             | string(255)  | NOT NULL    |                   | D     |
# | win_user_id   | 勝者             | integer(8)   |             | => Swars::User#id | E     |
# | turn_max      | 手数             | integer(4)   | NOT NULL    |                   | F     |
# | meta_info     | メタ情報         | text(65535)  | NOT NULL    |                   |       |
# | accessed_at   | 最終アクセス日時 | datetime     | NOT NULL    |                   |       |
# | preset_key    | 手合割           | string(255)  | NOT NULL    |                   | G     |
# | sfen_body     | SFEN形式棋譜     | string(8192) | NOT NULL    |                   |       |
# | sfen_hash     | Sfen hash        | string(255)  | NOT NULL    |                   |       |
# | start_turn    | 開始局面         | integer(4)   |             |                   | H     |
# | critical_turn | 開戦             | integer(4)   |             |                   | I     |
# | outbreak_turn | Outbreak turn    | integer(4)   |             |                   | J     |
# | image_turn    | OGP画像の局面    | integer(4)   |             |                   |       |
# | created_at    | 作成日時         | datetime     | NOT NULL    |                   |       |
# | updated_at    | 更新日時         | datetime     | NOT NULL    |                   |       |
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

    describe "ウォーズの対局キーが含まれるURLで検索" do
      it "レコードあり" do
        get :index, params: {query: "https://shogiwars.heroz.jp/games/devuser1-Yamada_Taro-20200101_123401?tw=1"}
        assert { controller.current_scope.count == 1 }
        expect(response).to have_http_status(:ok)
      end
      it "レコードなし" do
        get :index, params: {query: "https://kif-pona.heroz.jp/games/xxx-yyy-20200129_220847?tw=1"}
        assert { controller.current_scope.count == 0 }
        expect(response).to have_http_status(:ok)
      end
    end

    describe "ZIPダウンロード" do
      def test1(body_encode)
        get :index, params: { query: "devuser1", format: "zip", body_encode: body_encode}
        expect(response).to have_http_status(:ok)
        assert { controller.current_scope.count == 1 }
        assert { response["Content-Disposition"].match?(/shogiwars.*.zip/) }
        assert { response.media_type == "application/zip" }

        Zip::InputStream.open(StringIO.new(response.body)) do |zis|
          entry = zis.get_next_entry
          assert { entry.name == "devuser1/2020-01-01/devuser1-Yamada_Taro-20200101_123401.kif" }
          p entry.
          bin = zis.read
          assert { NKF.guess(bin).to_s == body_encode }
        end
      end

      it { test1("UTF-8")     }
      it { test1("Shift_JIS") }
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
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ...............
# >> 
# >> Finished in 12.41 seconds (files took 3.08 seconds to load)
# >> 15 examples, 0 failures
# >> 
