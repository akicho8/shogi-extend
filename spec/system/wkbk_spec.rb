require "rails_helper"

RSpec.describe "将棋トレーニングバトル", type: :system do
  before do
    Wkbk.setup
  end

  # from WkbkSupportMethods
  let(:user1)     { User.create!                    }
  let(:article1) { user1.wkbk_articles.create_mock1 }

  xit "トップ(ログインなし)" do
    visit "/training"
    expect(page).to have_content "LOGIN"
    doc_image
  end

  xit "トップ(ログインあり)" do
    visit "/training?_user_id=#{user1.id}"
    expect(page).to have_content "対人戦"
    doc_image
  end

  xit "問題詳細(ログインなし)" do
    visit "/training?article_id=#{article1.id}"
    expect(page).to have_content "配置"
    doc_image
  end

  xit "問題詳細(ログインあり)" do
    visit "/training?article_id=#{article1.id}&_user_id=#{user1.id}"
    expect(page).to have_content "配置"
    doc_image
  end
end
