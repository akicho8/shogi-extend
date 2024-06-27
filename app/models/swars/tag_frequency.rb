# http://localhost:3000/api/swars/tag_frequency
# https://www.shogi-extend.com/api/swars/tag_frequency
module Swars
  class TagFrequency
    SAMPLE_MAX = 50000
    EXPIRES_IN = Rails.env.local? ? 0 : 1.days

    def initialize(options = {})
      @options = {
      }.merge(options)
    end

    def as_json(*)
      Rails.cache.fetch("tag_frequency", expires_in: EXPIRES_IN) do
        counts_hash
      end
    end

    def to_h
      counts_hash
    end

    def counts_hash
      @counts_hash ||= yield_self do
        count = 0
        hv = Hash.new(0)
        Swars::Membership.in_batches(order: :desc) do |group|
          group.all_tag_counts.each do |tag|
            hv[tag.name] += tag.count
          end
          count += group.count
          if count >= sample_max
            break
          end
        end
        hv.sort_by { |k, v| -v }.to_h
      end
    end

    def sample_max
      [@options[:sample_max].presence || SAMPLE_MAX, SAMPLE_MAX].min
    end
  end
end
