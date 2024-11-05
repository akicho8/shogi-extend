# http://localhost:3000/api/swars/tag_frequency
# https://www.shogi-extend.com/api/swars/tag_frequency
# cap production deploy:upload FILES=app/models/swars/tag_frequency.rb
# Swars::TagFrequency.new.call
module Swars
  class TagFrequency
    SAMPLE_MAX = 50000
    EXPIRES_IN = Rails.env.local? ? 0 : 1.days
    VERSION    = 1
    BATCH_SIZE = 1000

    def initialize(options = {})
      @options = {
      }.merge(options)
    end

    def as_json(*)
      Rails.cache.fetch("tag_frequency/#{VERSION}", expires_in: EXPIRES_IN) do
        counts_hash
      end
    end

    def to_h
      counts_hash
    end

    def call(...)
      as_json(...)
    end

    def counts_hash
      @counts_hash ||= yield_self do
        Bioshogi::Analysis::TacticInfo.each_with_object({}) do |e, m|
          hv = Hash.new(0)
          Swars::Membership.in_batches(of: BATCH_SIZE, order: :desc).each_with_index do |relation, batch|
            if batch >= sample_max.ceildiv(BATCH_SIZE)
              break
            end
            relation.tag_counts_on("#{e.key}_tags", at_least: 1).each do |tag|
              hv[tag.name] += tag.count
            end
          end
          m[e.key] = hv.sort_by { |_, v| -v }.to_h
        end
      end
    end

    def sample_max
      [@options[:sample_max].presence || SAMPLE_MAX, SAMPLE_MAX].min
    end
  end
end
