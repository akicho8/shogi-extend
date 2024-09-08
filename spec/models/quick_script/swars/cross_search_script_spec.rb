require "rails_helper"

module QuickScript
  RSpec.describe Swars::CrossSearchScript, type: :model do
    it "works" do
      battle = ::Swars::Battle.create!(csa_seq: ::Swars::KifuGenerator.ibis_pattern)
      instance = Swars::CrossSearchScript.new(tag: "居飛車", _method: "post")
      assert { instance.all_ids == [battle.id] }
      assert { instance.as_json }
      assert { Swars::CrossSearchScript.new(tag: "振り飛車", _method: "post").all_ids == [] }
    end
  end
end
