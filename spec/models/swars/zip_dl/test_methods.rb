require "rails_helper"

module Swars
  module ZipDl
    module TestMethods
      extend ActiveSupport::Concern

      included do
        let(:current_user) { ::User.create!                  }
        let(:user1)        { Swars::User.create!(user_key: "alice") }
        let(:user2)        { Swars::User.create!(user_key: "bob")   }

        let(:base_params) {
          {
            :current_user         => current_user,   # ログインしている人
            :current_index_scope  => user1.battles,  # 対象レコードたち
            :swars_user           => user1,          # 対象者のキー
            :query                => "alice",        # デバッグ用にいれておく。いまのところ user1.name と同一
          }
        }
      end
    end

    RSpec.configure do |config|
      config.include(TestMethods, type: :model, zip_dl_spec: true)
    end
  end
end
