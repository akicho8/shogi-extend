require 'rails_helper'

module Swars
  RSpec.describe type: :model do
    before do
      Swars.setup
    end

    let :user do
      User.create!
    end

    describe "アヒル上級" do
      before do
        Battle.create!(kifu_body_for_test: Bioshogi::TacticInfo.flat_lookup("アヒル囲い").sample_kif_file.read) do |e|
          e.memberships.build(user: user)
        end
      end

      it do
        assert { user.user_info.medal_list.instance_eval(&MedalInfo["アヒル上級"].func) }
      end
    end

    describe "全チェック" do
      before do
        Battle.create! do |e|
          e.memberships.build(user: user)
        end
      end

      let :list do
        MedalInfo.find_all { |e| user.user_info.medal_list.instance_eval(&e.func) }
      end

      it do
        assert { list.collect(&:key) == [:居飛車党, :嬉野流] }
      end
    end
  end
end
