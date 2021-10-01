require "rails_helper"

RSpec.describe "将棋トレーニングバトル", type: :system do
  before do
    Actb.setup
  end

  # from ActbSupport
  let(:user1)     { User.create!                    }
  let(:question1) { user1.actb_questions.create_mock1 }

  xit "トップ(ログインなし)" do
    visit "/training"
    assert_text "LOGIN"
    doc_image
  end

  xit "トップ(ログインあり)" do
    visit "/training?_user_id=#{user1.id}"
    assert_text "対人戦"
    doc_image
  end

  xit "問題詳細(ログインなし)" do
    visit "/training?question_id=#{question1.id}"
    assert_text "配置"
    doc_image
  end

  xit "問題詳細(ログインあり)" do
    visit "/training?question_id=#{question1.id}&_user_id=#{user1.id}"
    assert_text "配置"
    doc_image
  end
end
