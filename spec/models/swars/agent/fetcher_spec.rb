require "rails_helper"

module Swars
  module Agent
    RSpec.describe Fetcher, type: :model, swars_spec: true do
      let(:url) { "https://shogiwars.heroz.jp/games/history?user_id=kinakom0chi" }

      it "development" do
        assert { Fetcher.new.fetch("index", url).include?("YamadaTaro 対局履歴") }
      end

      it "production" do
        assert { Fetcher.new(remote_run: true).fetch("index", url).include?("kinakom0chi 対局履歴") }
      end
    end
  end
end
