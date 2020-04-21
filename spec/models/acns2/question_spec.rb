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
  end
end
