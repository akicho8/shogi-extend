module MinmaxNormalizer
  extend self

  def from_hash_array(rows, key1, key2, method: :zero_to_one)
    values = rows.pluck(key1)
    values = safe_normalize(values, method: method)
    rows.collect.with_index { |e, i| e.merge(key2 => values[i]) }
  end

  def safe_normalize(values, method: :zero_to_one)
    min, max = values.compact.minmax
    min ||= 0
    max ||= 0
    size = max - min

    if size.zero?
      return Array.new(values.size)
    end

    values.collect do |e|
      if e
        case method
        when :zero_to_one
          (e - min).fdiv(size)
        when :minus_one_to_plus_one
          2.0 * (e - min).fdiv(size) - 1.0
        else
          raise "must not happen"
        end
      end
    end
  end
end
