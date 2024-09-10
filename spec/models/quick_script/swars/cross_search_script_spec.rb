require "rails_helper"

module QuickScript
  RSpec.describe Swars::CrossSearchScript, type: :model do
    it "works" do
      battle = ::Swars::Battle.create!(csa_seq: ::Swars::KifuGenerator.ibis_pattern)
      tp battle.info if $0 == "-"
      instance = Swars::CrossSearchScript.new(x_tag: "居飛車", x_judge_keys: "勝ち,負け", x_grade_keys: "30級", xmode_keys: "野良", rule_keys: "10分", _method: "post")
      assert { instance.all_ids == [battle.id] }
      assert { instance.as_json }
      assert { Swars::CrossSearchScript.new(x_tag: "振り飛車", _method: "post").all_ids == [] }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> QuickScript::Swars::CrossSearchScript
# >> |----------+--------------------------------------------|
# >> |       ID | 4415                                       |
# >> |   ルール | 10分                                       |
# >> |     結末 | 投了                                       |
# >> |   モード | 野良                                       |
# >> |   手合割 | 平手                                       |
# >> |     手数 | 2                                          |
# >> |       ▲ | user1 30級 勝ち (居飛車 相居飛車 対居飛車) |
# >> |       △ | user2 30級 負け (居飛車 相居飛車 対居飛車) |
# >> | 対局日時 | 2000-01-01 00:00:00                        |
# >> | 対局秒数 | 0                                          |
# >> | 終了日時 | 2000-01-01 00:00:00                        |
# >> |     勝者 | user1                                      |
# >> | 最終参照 | 2000-01-01 00:00:00                        |
# >> |----------+--------------------------------------------|
# >> 1999-12-31T15:00:00.000Z pid=60141 tid=1e2d INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >>   works
# >> 
# >> Top 1 slowest examples (0.57162 seconds, 21.4% of total time):
# >>   QuickScript::Swars::CrossSearchScript works
# >>     0.57162 seconds -:5
# >> 
# >> Finished in 2.67 seconds (files took 2.14 seconds to load)
# >> 1 example, 0 failures
# >> 
