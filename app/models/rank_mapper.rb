# RankMapper.new([30, 20, 20, 10]).ranks # => [3, 1, 1, 0]
class RankMapper
  class << self
    def ranks(...)
      new(...).ranks
    end
  end

  def initialize(values, options = {})
    @options = {
      base_rank: 0,
    }.merge(options)

    @values = values
  end

  def ranks
    @ranks ||= @values.collect { |v| rank_map[v] }
  end

  def to_a
    ranks
  end

  def to_h
    rank_map
  end

  def rank_map
    @rank_map ||= {}.tap do |rank_map|
      sorted = @values.each_with_index.sort_by { |v, _| v }
      sorted.each_with_index do |(v, _), i|
        rank_map[v] ||= @options[:base_rank] + i
      end
    end
  end
end
