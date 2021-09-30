require "rails_helper"

module Swars
  RSpec.describe Agent, type: :model do
    describe "index" do
      let :result do
        Agent::Index.fetch(gtype: "", user_key: "devuser1", page_index: 0)
      end

      let :ret_value do
        [
          "devuser1-Yamada_Taro-20200101_123401",
          "devuser2-Yamada_Taro-20200101_123402",
          "devuser3-Yamada_Taro-20200101_123403",
        ]
      end

      it do
        assert { result == ret_value }
      end
    end

    describe "run_remote" do
      it do
        # Agent::Index.new(run_remote: true).fetch(gtype: "", user_key: "kinakom0chi", page_index: 0)
      end
    end

    describe "record" do
      let :result do
        Agent::Record.fetch(key: "devuser1-devuser2-20200101_123456")
      end

      it do
        assert { result[:key] == "devuser1-devuser2-20200101_123456" }
        assert { result[:battled_at] == "20200101_123456" }
        assert { result[:rule_key] == "" }
        assert { result[:preset_dirty_code] == 0 }
        assert { result[:__final_key] == "SENTE_WIN_TORYO" }
        assert { result[:user_infos] == [{user_key: "devuser1", grade_key: "三段"}, {user_key: "devuser2", grade_key: "四段"}] }
        assert { result[:csa_seq].first == ["+5756FU", 600] }
        assert { result[:fetch_successed] == true }
      end
    end
  end
end
