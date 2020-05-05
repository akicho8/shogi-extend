# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Question (acns3_questions as Acns3::Question)
#
# |-----------------------+-----------------------+-------------+---------------------+-----------------------+-------|
# | name                  | desc                  | type        | opts                | refs                  | index |
# |-----------------------+-----------------------+-------------+---------------------+-----------------------+-------|
# | id                    | ID                    | integer(8)  | NOT NULL PK         |                       |       |
# | user_id               | User                  | integer(8)  |                     | => Colosseum::User#id | A     |
# | init_sfen             | Init sfen             | string(255) | NOT NULL            |                       | B     |
# | time_limit_sec        | Time limit sec        | integer(4)  |                     |                       | C     |
# | difficulty_level      | Difficulty level      | integer(4)  |                     |                       | D     |
# | title                 | タイトル              | string(255) |                     |                       |       |
# | description           | 説明                  | string(512) |                     |                       |       |
# | hint_description      | Hint description      | string(255) |                     |                       |       |
# | source_desc           | Source desc           | string(255) |                     |                       |       |
# | other_twitter_account | Other twitter account | string(255) |                     |                       |       |
# | created_at            | 作成日時              | datetime    | NOT NULL            |                       |       |
# | updated_at            | 更新日時              | datetime    | NOT NULL            |                       |       |
# | moves_answers_count   | Moves answers count   | integer(4)  | DEFAULT(0) NOT NULL |                       | E     |
# | endpos_answers_count  | Endpos answers count  | integer(4)  | DEFAULT(0) NOT NULL |                       | F     |
# | o_count               | O count               | integer(4)  | NOT NULL            |                       | G     |
# | x_count               | X count               | integer(4)  | NOT NULL            |                       | H     |
# |-----------------------+-----------------------+-------------+---------------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :acns2_memberships
#--------------------------------------------------------------------------------

require 'rails_helper'

module Acns3
  RSpec.describe Question, type: :model do
    let :user do
      Colosseum::User.create!
    end

    let :question do
      user.acns3_questions.create! do |e|
        e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
        e.moves_answers.build(moves_str: "G*5b")
        e.endpos_answers.build(sfen_endpos: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
      end
    end

    it do
      assert { question.valid? }
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
        question = user.acns3_questions.build
        question.together_with_params_came_from_js_update(params)
        assert { question.persisted? }

        question = user.acns3_questions.build
        proc { question.together_with_params_came_from_js_update(params) }.should raise_error(ActiveRecord::RecordInvalid)
        assert { question.persisted? == false }
      end
    end
  end
end
