module Colosseum
  class RankingsController < ApplicationController
    let :ranking_cop do
      RankingCop.new
    end

    def index
    end
  end
end
