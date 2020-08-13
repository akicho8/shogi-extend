require 'rails_helper'

module Actb
  RSpec.describe RuleInfo, type: :model do
    include ActbSupportMethods

    before do
      question1
    end

    it "works" do
      RuleInfo.each do |rule_info|
        assert { rule_info.generate([user1, user2]) }
      end
    end

    it "今日解いたものは出題されないけど足らなかったら入れる" do
      Actb::Question.destroy_all
      5.times {
        user1.actb_questions.create_mock1
      }
      # tp RuleInfo[:test_rule].generate([user1, user2])
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> |----+----------------------------------------------------------+----------------+------------------+----------------------------------+-------------+-----------+---------------+------------------+-------------------+-----------+----------------+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------+--------------------------------|
# >> | id | init_sfen                                                | time_limit_sec | difficulty_level | title                            | description | hint_desc | source_author | source_media_url | direction_message | mate_skip | owner_tag_list | source_about_key | user                                                                                                                                                                                                  | moves_answers                                              | ox_record                      |
# >> |----+----------------------------------------------------------+----------------+------------------+----------------------------------+-------------+-----------+---------------+------------------+-------------------+-----------+----------------+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------+--------------------------------|
# >> | 24 | position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1 |                |                  | 226acde355dae551d11e4aae6711c53d |             |           |               |                  |                   |           | []             | ascertained      | {"id"=>11, "key"=>"2510f189cc7bf19095feaab1e7c23c9a", "name"=>"user1", "avatar_path"=>"/assets/human/0000_fallback_avatar_icon-9fae4951044e65f781d23aefc5283c381e271401a491db66138690cec948c841.png"} | [{"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}] | {"ox_total"=>0, "o_rate"=>nil} |
# >> | 20 | position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1 |                |                  | f18b437facfc9f38b05be2a5d7457bdb |             |           |               |                  |                   |           | []             | ascertained      | {"id"=>11, "key"=>"2510f189cc7bf19095feaab1e7c23c9a", "name"=>"user1", "avatar_path"=>"/assets/human/0000_fallback_avatar_icon-9fae4951044e65f781d23aefc5283c381e271401a491db66138690cec948c841.png"} | [{"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}] | {"ox_total"=>0, "o_rate"=>nil} |
# >> | 21 | position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1 |                |                  | faa880854d06eed46a97fbc1aa22f458 |             |           |               |                  |                   |           | []             | ascertained      | {"id"=>11, "key"=>"2510f189cc7bf19095feaab1e7c23c9a", "name"=>"user1", "avatar_path"=>"/assets/human/0000_fallback_avatar_icon-9fae4951044e65f781d23aefc5283c381e271401a491db66138690cec948c841.png"} | [{"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}] | {"ox_total"=>0, "o_rate"=>nil} |
# >> | 23 | position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1 |                |                  | 3a944db315a41ef5be49f80aa0f24d9d |             |           |               |                  |                   |           | []             | ascertained      | {"id"=>11, "key"=>"2510f189cc7bf19095feaab1e7c23c9a", "name"=>"user1", "avatar_path"=>"/assets/human/0000_fallback_avatar_icon-9fae4951044e65f781d23aefc5283c381e271401a491db66138690cec948c841.png"} | [{"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}] | {"ox_total"=>0, "o_rate"=>nil} |
# >> | 22 | position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1 |                |                  | 6d29b18f5d85bacaa22a06dcb874c267 |             |           |               |                  |                   |           | []             | ascertained      | {"id"=>11, "key"=>"2510f189cc7bf19095feaab1e7c23c9a", "name"=>"user1", "avatar_path"=>"/assets/human/0000_fallback_avatar_icon-9fae4951044e65f781d23aefc5283c381e271401a491db66138690cec948c841.png"} | [{"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}] | {"ox_total"=>0, "o_rate"=>nil} |
# >> |----+----------------------------------------------------------+----------------+------------------+----------------------------------+-------------+-----------+---------------+------------------+-------------------+-----------+----------------+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------+--------------------------------|
# >> .
# >> 
# >> Finished in 1.72 seconds (files took 2.83 seconds to load)
# >> 1 example, 0 failures
# >> 
