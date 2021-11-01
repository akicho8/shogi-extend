require "rails_helper"

module Swars
  RSpec.describe Crawler, type: :model do
    before do
      swars_battle_setup
      Swars::User.find_each { |e| e.search_logs.create! }
    end

    it "実行" do
      c = Crawler::RegularCrawler.new.run
      tp c.rows if ENV["VERBOSE"]

      c = Crawler::ExpertCrawler.new.run
      tp c.rows.to_t if ENV["VERBOSE"]
    end

    it "model_name" do
      assert { Crawler::RegularCrawler.model_name.human }
    end
  end
end
