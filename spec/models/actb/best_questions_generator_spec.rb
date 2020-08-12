require 'rails_helper'

module Actb
  RSpec.describe BestQuestionsGenerator, type: :model do
    include ActbSupportMethods

    before do
      question1
    end

    it "works" do
      generator = BestQuestionsGenerator.new(rule_info: RuleInfo.first)
      generator.db_scope.to_sql # => "SELECT `actb_questions`.* FROM `actb_questions` INNER JOIN `actb_folders` ON `actb_folders`.`id` = `actb_questions`.`folder_id` WHERE `actb_folders`.`type` = 'Actb::ActiveBox' ORDER BY rand()"
      generator.generate        # => [{"id"=>3, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1", "time_limit_sec"=>nil, "difficulty_level"=>nil, "title"=>"3fd34e5424388a58544d8221b55190d5", "description"=>nil, "hint_desc"=>nil, "source_author"=>nil, "source_media_url"=>nil, "direction_message"=>nil, "mate_skip"=>nil, "owner_tag_list"=>[], "source_about_key"=>"ascertained", "user"=>{"id"=>4, "key"=>"d056b42b2082308f9d10c569cdfb941b", "name"=>"user1", "avatar_path"=>"/assets/human/0002_fallback_avatar_icon-d651d5f44e2c6e9c8a3e51c6c3ec712598ff69423b512145e4e98a3a3793199d.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>nil}}]

      RuleInfo.each do |rule_info|
        generator = BestQuestionsGenerator.new(rule_info: rule_info)
        assert { generator.generate }
      end
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 1.43 seconds (files took 2.16 seconds to load)
# >> 1 example, 0 failures
# >> 
