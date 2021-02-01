require 'rails_helper'

# 参考: https://github.com/andrelugomes/hello-ruby-on-rails/blob/dbbbc848d391eee6cf0448f1af695fd9df73cf4e/rails-4-devise-linkedin/spec/controllers/omniauth_callbacks_controller_spec.rb
RSpec.describe OmniauthCallbacksController, type: :controller do
  before do
    Actb.setup
    Emox.setup
    User.destroy_all
  end

  describe "Google" do
    before do
      request.env["devise.mapping"] = Devise.mappings[:xuser]
      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
          "provider" => "google", # これは固定値ではなくこちら側で用意したコールバックメソッド名
          "uid"      => "(uid)",
          "info" => {
            "name"  => "alice", # たまに name もメールアドレスになっていることもある
            "email" => "alice@localhost",
            "image" => "https://www.shogi-extend.com/foo.png",
          },
        })
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      get :google
    end

    let(:record) { User.first }

    it "名前がある" do
      assert { record.name == "alice" }
    end

    it "プロフィール画像を登録している" do
      assert { record.avatar }
    end

    it "メールアドレスを取得している" do
      assert { record.email == "alice@localhost" }
    end

    it "どっかにリダイレクトする" do
      expect(response).to have_http_status(:redirect)
    end

    it "メール" do
      assert { ActionMailer::Base.deliveries.count == 1 }
      assert { ActionMailer::Base.deliveries.last.subject == "[SHOGI-EXTEND][test] aliceさんがgoogleで登録されました" }
    end
  end

  describe "Twitter" do
    before do
      request.env["devise.mapping"] = Devise.mappings[:xuser]
      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
          "provider" => 'twitter',
          "uid"      => '(uid)',
          "info"     => {
            "nickname"    => "(nickname_is_twitter_account)",
            "name"        => "alice",
            "email"       => nil, # ← 注意
            "location"    => "(location)",
            "image"       => "https://www.shogi-extend.com/foo.png",
            "description" => "(description)",
          },
        })
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      get :twitter
    end

    let(:record) { User.first }

    it "名前がある" do
      assert { record.name == "alice" }
    end

    it "プロフィール画像を登録している" do
      assert { record.avatar }
    end

    it "メールアドレスはダミーを入れてある" do
      assert { record.email.match?(/@localhost/) }
    end

    it "ツイッターアカウント" do
      assert { record.twitter_key == "(nickname_is_twitter_account)" }
    end

    it "どっかにリダイレクトする" do
      expect(response).to have_http_status(:redirect)
    end

    it "メール" do
      assert { ActionMailer::Base.deliveries.count == 1 }
      assert { ActionMailer::Base.deliveries.last.subject == "[SHOGI-EXTEND][test] aliceさんがtwitterで登録されました" }
    end
  end

  describe "GitHub" do
    before do
      request.env["devise.mapping"] = Devise.mappings[:xuser]
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
          "provider" => 'github',
          "uid"      => '(uid)',
          "info"     => {
            "nickname" => "(nickname_is_github_account)", # @xxx の部分
            "email"    => "alice@localhost",
            "name"     => "Yamada Taro",
            "image"    => "https://www.shogi-extend.com/foo.png",
          },
        })
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
      get :github
    end

    let(:record) { User.first }

    it "名前がある" do
      assert { record.name == "Yamada Taro" }
    end

    it "プロフィール画像を登録している" do
      assert { record.avatar }
    end

    it "メールアドレスがある" do
      assert { record.email == "alice@localhost" }
    end

    it "ツイッターアカウント" do
      assert { record.twitter_key.blank? }
    end

    it "どっかにリダイレクトする" do
      expect(response).to have_http_status(:redirect)
    end

    it "メール" do
      assert { ActionMailer::Base.deliveries.count == 1 }
      assert { ActionMailer::Base.deliveries.last.subject == "[SHOGI-EXTEND][test] Yamada Taroさんがgithubで登録されました" }
    end
  end
end
