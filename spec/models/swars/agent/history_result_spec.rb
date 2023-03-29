require "rails_helper"

module Swars
  module Agent
    RSpec.describe HistoryResult, type: :model, swars_spec: true do
      let(:key) { BattleKey.create("alice-bob-20130531_010024") }

      it "取り込んだかに関係なくすべてのキー" do
        res = HistoryResult.new([key])
        assert2 { res.all_keys == [key] }
      end

      it "まだ取り込んでいない場合はすべて new_keys に入っている" do
        res = HistoryResult.new([key])
        assert2 { res.new_keys == [key] }
      end

      it "すでに取り込んでいる場合は除外している" do
        battle = Battle.create!(key: key.to_s)
        res = HistoryResult.new([key])
        assert2 { res.new_keys == [] }
      end

      it "10件未満なら最後のページと見なす" do
        assert2 { HistoryResult.new([key] * 9).last_page? }
        assert2 { !HistoryResult.new([key] * 10).last_page? }
      end
    end
  end
end
