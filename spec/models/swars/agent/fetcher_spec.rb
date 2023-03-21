require "rails_helper"

module Swars
  module Agent
    RSpec.describe Fetcher, type: :model, swars_spec: true do
      let(:url) { "https://shogiwars.heroz.jp/games/history?user_id=kinakom0chi" }

      it "development" do
        is_asserted_by { Fetcher.new.fetch(:history, url).include?("YamadaTaro 対局履歴") }
      end

      it "production" do
        is_asserted_by { Fetcher.new(remote_run: true).fetch(:record, url).include?("kinakom0chi 対局履歴") }
      end
    end
  end
end
