require "rails_helper"

RSpec.describe QuickScript::Swars::CrossSearchScript, type: :model do
  before do
    @current_user = User.create!
    @battle = ::Swars::Battle.create!(csa_seq: ::Swars::KifuGenerator.ibis_pattern)
    tp @battle.info if $0 == "-"
  end

  it "検索にマッチする" do
    condition = {
      :x_tags          => "居飛車",
      :x_judge_keys    => "勝ち,負け",
      :x_location_keys => "black",
      :x_grade_keys    => "30級",
      :xmode_keys      => "野良",
      :imode_keys      => "通常",
      :rule_keys       => "10分",
      :final_keys      => "投了",
      :preset_keys     => "平手"
    }
    instance = QuickScript::Swars::CrossSearchScript.new(exec: "true", **condition)
    assert { instance.found_ids == [@battle.id] }
    assert { instance.as_json }
  end

  it "検索にマッチしない" do
    condition = {
      :x_tags => "振り飛車",
    }
    instance = QuickScript::Swars::CrossSearchScript.new(exec: "true", **condition)
    assert { instance.found_ids == [] }
    assert { instance.as_json }
  end

  it "バックグランドでダウンロードする" do
    instance = QuickScript::Swars::CrossSearchScript.new({ download_key: :on, bg_request_key: :on, exec: true }, { current_user: @current_user })
    assert { instance.as_json[:flash][:notice].match?(/承りました/) }
    assert { ActionMailer::Base.deliveries.count.positive? }
  end

  it "各種メソッド" do
    assert { QuickScript::Swars::CrossSearchScript.new.bookmark_url }
    assert { QuickScript::Swars::CrossSearchScript.new.mail_body    }
    assert { QuickScript::Swars::CrossSearchScript.new.to_zip       }
  end
end
