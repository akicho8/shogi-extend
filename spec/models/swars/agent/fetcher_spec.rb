require "rails_helper"

RSpec.describe Swars::Agent::Fetcher, type: :model, swars_spec: true do
  let(:url) { "https://shogiwars.heroz.jp/games/history?user_id=kinakom0chi" }

  it "development" do
    assert { Swars::Agent::Fetcher.new.fetch(:history, url).include?("YamadaTaro 対局履歴") }
  end

  it "production" do
    assert { Swars::Agent::Fetcher.new(remote_run: true).fetch(:record, url).include?("kinakom0chi 対局履歴") }
  end
end
