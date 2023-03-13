require "rails_helper"

module Swars
  RSpec.describe type: :model, swars_spec: true do
    describe "カスタム検索からくるパラメータすべて" do
      def case1(key, value1, value2, options = {})
        black = User.create!
        white = User.create!(key: options[:white_key])
        battle = Battle.create_with_members!([black, white], csa_seq: options[:csa_seq])
        assert {  Battle.search(user: black, query_info: QueryInfo.parse("#{key}:#{value1}")).exists? }
        assert { !Battle.search(user: black, query_info: QueryInfo.parse("#{key}:#{value2}")).exists? }
      end

      it "棋風" do
        case1("自分の棋風", "準王道", "準変態")
        case1("相手の棋風", "準変態", "準王道")
        case1("棋風", "準王道", "準変態") # alias
      end

      it "works" do
        case1("日付", "2000-01-01...2000-01-02", "2001")
        case1("持ち時間", "10分", "3分")
        case1("勝敗", "勝ち", "負け")
        case1("結末", "投了", "切断")
        case1("先後", "▲", "△")
        case1("相手の棋力", "30級", "29級")
        case1("力差", ">=0", ">=1")
        case1("対局モード", "野良", "友達")
        case1("手合割", "平手", "角落ち")
        case1("tag", "居飛車", "振り飛車")
        case1("any-tag", "居飛車", "振り飛車")
        case1("exclude-tag", "振り飛車", "居飛車")
        case1("vs-tag", "振り飛車", "居飛車")
        case1("vs-any-tag", "振り飛車", "居飛車")
        case1("vs-exclude-tag", "居飛車", "振り飛車")
        case1("手数", ">=1", "==0", csa_seq: outbreak_csa)
        case1("中盤", ">=1", "==0", csa_seq: outbreak_csa)
        case1("開戦", ">=1", "==0", csa_seq: outbreak_csa)
        case1("最大思考", ">=1", "==0")
        case1("平均思考", ">=1", "==0")
        case1("最終思考", ">=1", "==0")
        case1("中盤以降の平均思考", ">=1", "==0", csa_seq: csa_seq_generate4(10))
        case1("中盤以降の最大連続即指し回数", ">=1", "==0", csa_seq: csa_seq_generate4(10))
        case1("相手", "white_man", "unknown_man", white_key: "white_man")
      end
    end

    describe "手合割" do
      def case1(value)
        black = User.create!
        white = User.create!
        users = [black, white]
        csa_seq = SwarsMedalSupport.csa_seq_generate1(1)
        Battle.create_with_members!(users, preset_key: "平手", csa_seq: csa_seq)
        Battle.create_with_members!(users, preset_key: "角落ち", csa_seq: csa_seq)
        Battle.create_with_members!(users, preset_key: "飛車落ち", csa_seq: csa_seq)
        query_info = QueryInfo.parse("手合割:#{value}")
        scope = Battle.search(user: white, query_info: query_info)
        scope.collect { |e| e.preset_key }
      end

      it "works" do
        assert { case1("平手")              == ["平手"]               }
        assert { case1("!平手")             == ["角落ち", "飛車落ち"] }
        assert { case1("-平手")             == ["角落ち", "飛車落ち"] }
        assert { case1("角落ち")            == ["角落ち"]             }
        assert { case1("角落ち,飛車落ち")   == ["角落ち", "飛車落ち"] }
        assert { case1("-角落ち,-飛車落ち") == ["平手"] }
      end
    end

    describe "Options" do
      it "main_battle_key" do
        key = BattleKeyGenerator.new.generate
        black = User.create!
        white = User.create!
        Battle.create_with_members!([black, white], key: key.to_s)
        battles = Battle.search({
            :query_info         => QueryInfo.parse(""),
            :user => black,
            :main_battle_key => key,
          })
        assert { battles.exists? }
      end
    end
  end
end
