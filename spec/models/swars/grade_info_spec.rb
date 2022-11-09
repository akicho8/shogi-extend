require "rails_helper"

module Swars
  RSpec.describe GradeInfo, type: :model, swars_spec: true do
    it "段は漢字で入力するものなので数字を許容しない" do
      assert { !GradeInfo.lookup("9段") }
      assert { !GradeInfo.lookup("９段") }
    end

    it "段位を省略してもマッチする" do
      assert { GradeInfo.fetch("1") == GradeInfo.fetch("1級") }
      assert { GradeInfo.fetch("初") == GradeInfo.fetch("初段") }
    end
  end
end
