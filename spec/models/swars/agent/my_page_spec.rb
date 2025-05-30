require "rails_helper"

RSpec.describe Swars::Agent::MyPage, type: :model, swars_spec: true do
  it "development" do
    rule_grade_list = Swars::Agent::MyPage.new(user_key: "testarossa00").rule_grade_list
    av = rule_grade_list.list.collect { |e| [e[:rule].to_s, e[:grade].to_s] }
    assert { av == [["10分", "10000級"], ["3分", "1級"], ["10秒", "十段"]] }
  end

  it "production" do
    my_page = Swars::Agent::MyPage.new(user_key: "TESTAROSSA00", remote_run: true)
    assert { my_page.real_user_key == "testarossa00" }
    av = my_page.rule_grade_list.list.collect { |e| [e[:rule].to_s, e[:grade].to_s] }
    assert { av == [["10分", "10000級"], ["3分", "10000級"], ["10秒", "10000級"]] }
  end

  it "page_not_found?" do
    assert { Swars::Agent::MyPage.new(user_key: "UNKNOWN_USER_", remote_run: true).page_not_found? }
  end
end
