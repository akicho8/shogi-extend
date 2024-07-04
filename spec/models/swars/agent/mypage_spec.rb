require "rails_helper"

module Swars
  module Agent
    RSpec.describe Mypage, type: :model, swars_spec: true do
      it "development" do
        mypage_grade = Mypage.new(user_key: "testarossa00").mypage_grade
        av = mypage_grade.list.collect { |e| [e[:rule].to_s, e[:grade].to_s] }
        assert { av == [["10分", "10000級"], ["3分", "1級"], ["10秒", "十段"]] }
      end

      it "production" do
        mypage = Mypage.new(user_key: "TESTAROSSA00", remote_run: true)
        assert { mypage.real_user_key == "testarossa00" }
        av = mypage.mypage_grade.list.collect { |e| [e[:rule].to_s, e[:grade].to_s] }
        assert { av == [["10分", "10000級"], ["3分", "10000級"], ["10秒", "10000級"]] }
      end

      it "user_missing?" do
        assert { Mypage.new(user_key: "_UNKNOWN_USER_", remote_run: true).user_missing? }
      end
    end
  end
end
