# rails r 'Swars::Battle::Rebuilder.new.perform'
# cap production rails:runner CODE='Swars::Battle::Rebuilder.new.perform'
module Swars
  class Battle
    class Rebuilder
      def initialize(params = {})
        @params = {
          limit: 256,
        }.merge(params)
      end

      def perform
        c = Hash.new(0)
        Battle.order(accessed_at: :desc).limit(params[:limit]).each do |e|
          c[e.remake] += 1
        end
        puts
        p c
      end

      private

      attr_reader :params
    end
  end
end
