require 'rails_helper'

module Swars
  RSpec.describe Agent, type: :model do
    describe "index" do
      let :value do
        Agent::Index.new.fetch(gtype: "", user_key: "devuser1", page_index: 0)
      end

      let :ret_value do
        [
          { key: "devuser1-Yamada_Taro-20200101_123401" },
          { key: "devuser2-Yamada_Taro-20200101_123402" },
          { key: "devuser3-Yamada_Taro-20200101_123403" },
        ]
      end

      it do
        assert { value == ret_value }
      end
    end

    describe "record" do
      let :value do
        Agent::Record.new.fetch("devuser1-devuser2-20200101_123456")
      end

      it do
        assert { value[:key] == "devuser1-devuser2-20200101_123456" }
        assert { value[:url] == "https://shogiwars.heroz.jp/games/devuser1-devuser2-20200101_123456?locale=ja" }
        assert { value[:battled_at] == "20200101_123456" }
        assert { value[:rule_key] == "" }
        assert { value[:preset_dirty_code] == 0 }
        assert { value[:__final_key] == "SENTE_WIN_TORYO" }
        assert { value[:user_infos] == [{user_key: "devuser1", grade_key: "三段"}, {user_key: "devuser2", grade_key: "四段"}] }
        assert { value[:csa_seq].first == ["+5756FU", 600] }
        assert { value[:fetch_successed] == true }
      end
    end
  end
end
