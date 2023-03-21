require "rails_helper"

module Swars
  RSpec.describe GradeInfo, type: :model, swars_spec: true do
    it "段位を数字で入力する人がいるため仕方なく許容する" do
      is_asserted_by { GradeInfo.lookup("9段") == GradeInfo.fetch("九段") }
      is_asserted_by { GradeInfo.lookup("９段") == GradeInfo.fetch("九段") }
      is_asserted_by { GradeInfo.lookup("１０段") == GradeInfo.fetch("十段") }
    end

    it "段位を省略してもマッチする" do
      is_asserted_by { GradeInfo.fetch("1") == GradeInfo.fetch("1級") }
      is_asserted_by { GradeInfo.fetch("初") == GradeInfo.fetch("初段") }
    end
  end
end
