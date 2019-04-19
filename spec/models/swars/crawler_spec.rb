require 'rails_helper'

module Swars
  RSpec.describe Crawler, type: :model do
    before do
      swars_battle_setup
      Swars::User.find_each { |e| e.search_logs.create! }
    end

    it do
      puts Crawler::RegularCrawler.new.run.rows.to_t
      puts Crawler::ExpertCrawler.new.run.rows.to_t
    end
  end
end
