# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Question (actb_questions as Actb::Question)
#
# |-----------------------+-----------------------+-------------+---------------------+-----------------------+-------|
# | name                  | desc                  | type        | opts                | refs                  | index |
# |-----------------------+-----------------------+-------------+---------------------+-----------------------+-------|
# | id                    | ID                    | integer(8)  | NOT NULL PK         |                       |       |
# | user_id               | User                  | integer(8)  | NOT NULL            | => Colosseum::User#id | A     |
# | folder_id             | Folder                | integer(8)  | NOT NULL            |                       | B     |
# | lineage_id            | Lineage               | integer(8)  | NOT NULL            |                       | C     |
# | init_sfen             | Init sfen             | string(255) | NOT NULL            |                       | D     |
# | time_limit_sec        | Time limit sec        | integer(4)  |                     |                       | E     |
# | difficulty_level      | Difficulty level      | integer(4)  |                     |                       | F     |
# | title                 | タイトル              | string(255) |                     |                       |       |
# | description           | 説明                  | string(512) |                     |                       |       |
# | hint_description      | Hint description      | string(255) |                     |                       |       |
# | source_desc           | Source desc           | string(255) |                     |                       |       |
# | other_twitter_account | Other twitter account | string(255) |                     |                       |       |
# | created_at            | 作成日時              | datetime    | NOT NULL            |                       |       |
# | updated_at            | 更新日時              | datetime    | NOT NULL            |                       |       |
# | moves_answers_count   | Moves answers count   | integer(4)  | DEFAULT(0) NOT NULL |                       | G     |
# | endpos_answers_count  | Endpos answers count  | integer(4)  | DEFAULT(0) NOT NULL |                       | H     |
# | o_count               | O count               | integer(4)  | NOT NULL            |                       | I     |
# | x_count               | X count               | integer(4)  | NOT NULL            |                       | J     |
# | bad_count             | Bad count             | integer(4)  | NOT NULL            |                       |       |
# | good_count            | Good count            | integer(4)  | NOT NULL            |                       |       |
# | histories_count       | Histories count       | integer(4)  | DEFAULT(0) NOT NULL |                       |       |
# | favorites_count       | Favorites count       | integer(4)  | DEFAULT(0) NOT NULL |                       |       |
# | good_marks_count      | Good marks count      | integer(4)  | DEFAULT(0) NOT NULL |                       |       |
# | bad_marks_count       | Bad marks count       | integer(4)  | DEFAULT(0) NOT NULL |                       |       |
# | clip_marks_count      | Clip marks count      | integer(4)  | DEFAULT(0) NOT NULL |                       |       |
# | messages_count        | Messages count        | integer(4)  | DEFAULT(0) NOT NULL |                       |       |
# |-----------------------+-----------------------+-------------+---------------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_one :actb_master_xrecord
#--------------------------------------------------------------------------------

require 'rails_helper'

module Actb
  RSpec.describe Question, type: :model do
    include ActbSupportMethods

    it do
      assert { question1.valid? }
    end

    describe "子がエラーなら親を保存しない" do
      let :params do
        {
          question: {
            init_sfen: "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
            moves_answers: [{"moves_str"=>"4c5b"}],
            time_limit_clock: "1999-12-31T15:03:00.000Z",
          },
        }
      end

      it do
        question = user1.actb_questions.build
        question.together_with_params_came_from_js_update(params)
        assert { question.persisted? }

        question = user1.actb_questions.build
        proc { question.together_with_params_came_from_js_update(params) }.should raise_error(ActiveRecord::RecordInvalid)
        assert { question.persisted? == false }
      end
    end

    describe "属性" do
      it do
        assert { question1.lineage.name == "詰将棋" }
      end
    end

    describe "フォルダ" do
      it "初期値" do
        assert { question1.folder_key == "active" }
      end
      it "移動方法1" do
        user1.actb_trash_box.questions << question1
        assert { question1.folder.class == Actb::TrashBox }
      end
      it "移動方法2(フォーム用)" do
        question1.folder_key = :trash
        assert { question1.folder_key == "trash" }
      end
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ......
# >>
# >> Finished in 0.77538 seconds (files took 2.19 seconds to load)
# >> 6 examples, 0 failures
# >>
