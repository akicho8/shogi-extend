require "rails_helper"

module Swars
  module Agent
    RSpec.describe Mypage, type: :model, swars_spec: true do
      it "development" do
        mypage_result = Mypage.new(user_key: "testarossa00").fetch
        av = mypage_result.list.collect { |e| [e[:rule].to_s, e[:grade].to_s] }
        assert2 { av == [["10分", "10000級"], ["3分", "10000級"], ["10秒", "10000級"]] }
      end
      it "production" do
        mypage_result = Mypage.new(user_key: "testarossa00", remote_run: true).fetch
        av = mypage_result.list.collect { |e| [e[:rule].to_s, e[:grade].to_s] }
        assert2 { av == [["10分", "10000級"], ["3分", "10000級"], ["10秒", "10000級"]] }
      end
    end
  end
end
