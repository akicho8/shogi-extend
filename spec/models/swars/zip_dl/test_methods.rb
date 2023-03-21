require "rails_helper"

module Swars
  module ZipDl
    module TestMethods
      extend ActiveSupport::Concern

      included do
        let(:current_user) { ::User.create!                         }
        let(:swars_user1)  { Swars::User.create!(user_key: "alice") }
        let(:swars_user2)  { Swars::User.create!(user_key: "bob")   }

        let(:base_params) {
          {
            :current_user         => current_user,        # ログインしている人
            :current_index_scope  => swars_user1.battles, # 対象レコードたち
            :swars_user           => swars_user1,         # 対象者のキー
            :query                => "alice",             # デバッグ用にいれておく。いまのところ swars_user1.name と同一
          }
        }
      end
    end

    # これを入れると他と干渉する
    # RSpec.configure do |config|
    #   config.include(TestMethods, type: :model, zip_dl_spec: true) # zip_dl_spec: true が効いてない？
    # end
  end
end
