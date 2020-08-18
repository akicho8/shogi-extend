require 'rails_helper'

# 参考: https://github.com/andrelugomes/hello-ruby-on-rails/blob/dbbbc848d391eee6cf0448f1af695fd9df73cf4e/rails-4-devise-linkedin/spec/controllers/omniauth_callbacks_controller_spec.rb
RSpec.describe OmniauthCallbacksController, type: :controller do
  before(:context) do
    Actb.setup
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
            "nickname" => "(nickname_is_github_account)",
            "email"    => "alice@localhost",
            "name"     => "alice",
            "image"    => "https://www.shogi-extend.com/foo.png",
          },
        })
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
      get :github
    end

    let(:record) { User.first }

    it "名前がある" do
      assert { record.name == "alice" }
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
      assert { ActionMailer::Base.deliveries.last.subject == "[SHOGI-EXTEND][test] aliceさんがgithubで登録されました" }
    end
  end
end

# require 'rails_helper'
#
# # confira o do Akita: https://github.com/cidadedemocratica/cidadedemocratica/blob/master/spec/controllers/omniauth_callbacks_controller_spec.rb
#
# RSpec.describe Users::OmniauthCallbacksController, :type => :controller do
#
#   describe "facebook: login" do
#     before do
#       request.env["devise.mapping"] = Devise.mappings[:user]
#       OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
#                                                                         :provider => 'facebook',
#                                                                         :uid => '123545',
#                                                                         :info => { :email => 'igordeoliveirasa@gmail.com',  :name => 'Igor de Oliveira Sá', :image => "image"},
#                                                                     })
#
#       request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
#       get :facebook
#     end
#
#     it {
#       user = User.first
#       expect(user.name).to eq("Igor de Oliveira Sá")
#       expect(user.image).not_to be_nil
#     }
#
#     it { should be_user_signed_in }
#     it { expect(response).to redirect_to(dashboard_index_path) }
#   end
#
#   describe "facebook: do not login unregistered authorization" do
#     before do
#       request.env["devise.mapping"] = Devise.mappings[:user]
#       OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
#                                                                         :provider => 'facebook',
#                                                                         :uid => '123545',
#                                                                         :info => { :name => '', },
#                                                                     })
#       request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
#       get :facebook
#     end
#
#     it { should_not be_user_signed_in }
#     it { expect(response).to redirect_to(new_user_registration_path) }
#
#   end
#
#   # ========================================================
#
#   describe "google_oauth2: login" do
#     before do
#       request.env["devise.mapping"] = Devise.mappings[:user]
#       OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
#                                                                              :provider => 'google_oauth2',
#                                                                              :uid => '123545',
#                                                                              :info => { :email => 'igordeoliveirasa@gmail.com',  :name => 'Igor de Oliveira Sá', :image => "https://lh4.googleusercontent.com/-pyJtgUgrocI/AAAAAAAAAAI/AAAAAAAACDY/tcnl5uSQi4I/photo.jpg?sz=50" },
#                                                                          })
#
#       request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
#       get :google_oauth2
#     end
#
#     it {
#       user = User.first
#       expect(user.name).to eq("Igor de Oliveira Sá")
#       expect(user.image).not_to be_nil
#     }
#
#     it { should be_user_signed_in }
#     it { expect(response).to redirect_to(dashboard_index_path) }
#   end
#
#   describe "google_oauth2: do not login unregistered authorization" do
#     before do
#       request.env["devise.mapping"] = Devise.mappings[:user]
#       OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
#                                                                              :provider => 'google_oauth2',
#                                                                              :uid => '123545',
#                                                                              :info => { :name => '', },
#                                                                          })
#       request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
#       get :google_oauth2
#     end
#
#     it { should_not be_user_signed_in }
#     it { expect(response).to redirect_to(new_user_registration_path) }
#
#   end
#
#
#   # ========================================================
#
#   describe "linkedin: login" do
#     before do
#       request.env["devise.mapping"] = Devise.mappings[:user]
#       OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new({
#                                                                              :provider => 'linkedin',
#                                                                              :uid => '123545',
#                                                                              :info => { :email => 'igordeoliveirasa@gmail.com', :first_name => 'Igor', :last_name => 'de Oliveira Sá', :image => "https://media.licdn.com/mpr/mprx/0_mLnj-OHag98vU9bKukqm-yW701tLRPBK2bCC-gZlhvQzXc8rGiQAyj2xAO-VZNny76NijVogTUnE" },
#                                                                          })
#
#       request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:linkedin]
#       get :linkedin
#     end
#
#     it {
#       user = User.first
#       expect(user.name).to eq("Igor de Oliveira Sá")
#       expect(user.image).not_to be_nil
#     }
#
#     it { should be_user_signed_in }
#     it { expect(response).to redirect_to(dashboard_index_path) }
#   end
#
#   describe "linkedin: do not login unregistered authorization" do
#     before do
#       request.env["devise.mapping"] = Devise.mappings[:user]
#       OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new({
#                                                                         :provider => 'linkedin',
#                                                                         :uid => '123545',
#                                                                         :info => { :first_name => '', :last_name => '' },
#                                                                     })
#       request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:linkedin]
#       get :linkedin
#     end
#
#     it { should_not be_user_signed_in }
#     it { expect(response).to redirect_to(new_user_registration_path) }
#
#   end
#
#   # ========================================================
#
#   describe "twitter: login" do
#     before do
#       request.env["devise.mapping"] = Devise.mappings[:user]
#       OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
#                                                                        :provider => 'twitter',
#                                                                        :uid => '123545',
#                                                                        :info => { :name => 'Igor de Oliveira Sá', :image => "http://pbs.twimg.com/profile_images/481374675625574401/Xs8PuVmT_normal.jpeg" },
#                                                                    })
#
#       request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
#       get :twitter
#     end
#
#     it {
#       user = User.first
#       expect(user.name).to eq("Igor de Oliveira Sá")
#       expect(user.image).not_to be_nil
#     }
#
#     it { should be_user_signed_in }
#     it { expect(response).to redirect_to(dashboard_index_path) }
#   end
#
#
#   describe "twitter: do not login unregistered authorization" do
#     before do
#       request.env["devise.mapping"] = Devise.mappings[:user]
#       OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
#                                                                        :provider => 'twitter',
#                                                                        :uid => nil,
#                                                                        :info => { :name => '', },
#                                                                        :extra => {:raw_info => {}}
#                                                                    })
#       request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
#       get :twitter
#     end
#
#     it { should_not be_user_signed_in }
#     it { expect(response).to redirect_to(new_user_registration_path) }
#
#   end
#
#   # ========================================================
#
#   describe "github: login" do
#     before do
#       request.env["devise.mapping"] = Devise.mappings[:user]
#       OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
#                                                                              :provider => 'github',
#                                                                              :uid => '123545',
#                                                                              :info => { :email => 'igordeoliveirasa@gmail.com',  :name => 'Igor de Oliveira Sá', :image => "https://avatars.githubusercontent.com/u/2123428?v=3"},
#                                                                          })
#
#       request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
#       get :github
#     end
#
#
#     it {
#       user = User.first
#       expect(user.name).to eq("Igor de Oliveira Sá")
#       expect(user.image).not_to be_nil
#     }
#
#     it { should be_user_signed_in }
#     it { expect(response).to redirect_to(dashboard_index_path) }
#   end
#
#   describe "github: do not login unregistered authorization" do
#     before do
#       request.env["devise.mapping"] = Devise.mappings[:user]
#       OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
#                                                                              :provider => 'google_oauth2',
#                                                                              :uid => '123545',
#                                                                              :info => { :name => '', },
#                                                                          })
#       request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
#       get :github
#     end
#
#     it { should_not be_user_signed_in }
#     it { expect(response).to redirect_to(new_user_registration_path) }
#
#   end
#
# end
# >> Run options: exclude {:slow_spec=>true}
# >> ....
# >>
# >> Finished in 1.85 seconds (files took 2.21 seconds to load)
# >> 4 examples, 0 failures
# >>
