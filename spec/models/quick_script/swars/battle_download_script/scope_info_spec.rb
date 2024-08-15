require "rails_helper"

module QuickScript
  module Swars
    RSpec.describe BattleDownloadScript::ScopeInfo, type: :model do
      def case1(scope_key)
        current_user = User.create!
        swars_user = ::Swars::User.find_or_create_by!(key: "SWARS_USER_KEY")
        ::Swars::Battle.create! do |e|
          e.memberships.build(user: swars_user)
        end
        params = {query: "SWARS_USER_KEY", scope_key: scope_key}
        options = {current_user: current_user}
        instance = BattleDownloadScript.new(params, options)
        instance.main_scope.count == 1
      end

      it "前回の続きから" do
        assert { case1(:continue) }
      end

      it "本日" do
        assert { case1(:today) }
      end

      it "直近" do
        assert { case1(:recent) }
      end
    end
  end
end
