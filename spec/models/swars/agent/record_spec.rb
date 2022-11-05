require "rails_helper"

module Swars
  module Agent
    RSpec.describe Record, type: :model, swars_spec: true do
      it "works" do
        result = Record.fetch(key: "DevUser1-DevUser2-20200101_123456")
        assert { result[:key] == "DevUser1-DevUser2-20200101_123456" }
        assert { result[:battled_at] == "20200101_123456" }
        assert { result[:rule_key] == "" }
        assert { result[:preset_magic_number] == 0 }
        assert { result[:__final_key] == "SENTE_WIN_TORYO" }
        assert { result[:user_infos] == [{user_key: "DevUser1", grade_key: "三段"}, {user_key: "DevUser2", grade_key: "四段"}] }
        assert { result[:csa_seq].first == ["+5756FU", 600] }
        assert { result[:fetch_successed] == true }
      end
    end
  end
end
