require 'rails_helper'

module Acns2
  RSpec.describe Question, type: :model do
    let :user do
      Colosseum::User.create!
    end

    let :question do
      user.acns2_questions.create! do |e|
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
        question = user.acns2_questions.build
        question.together_with_params_came_from_js_update(params)
        assert { question.persisted? }

        question = user.acns2_questions.build
        proc { question.together_with_params_came_from_js_update(params) }.should raise_error(ActiveRecord::RecordInvalid)
        assert { question.persisted? == false }
      end
    end
  end
end
