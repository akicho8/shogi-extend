module MinmaxScaler
  extend self

  # MinmaxScaler.rescale([])               # => []
  # MinmaxScaler.rescale([nil])            # => [nil]
  # MinmaxScaler.rescale([5])              # => [nil]
  # MinmaxScaler.rescale([5, nil, 9])      # => [0.0, nil, 1.0]
  # MinmaxScaler.rescale([9, 7, 5], -1, 1) # => [1.0, 0.0, -1.0]
  # MinmaxScaler.rescale([9, 7, 5], 1, -1) # => [-1.0, 0.0, 1.0]
  def rescale(values, out_min = nil, out_max = nil)
    out_min ||= 0
    out_max ||= 1

    in_min, in_max = values.compact.minmax
    in_min ||= 0
    in_max ||= 0
    size = in_max - in_min

    if size.zero?
      return Array.new(values.size)
    end

    values.collect do |value|
      if value
        GeomCraft::Range2.map_range(value, in_min, in_max, out_min, out_max)
      end
    end
  end

  # MinmaxScaler.merge([{a: 5}, {a: 6}], :a)                               # => [{a: 0.0}, {a: 1.0}]
  # MinmaxScaler.merge([{a: 5}, {a: 6}], :a, new_key: :b, min: -1, max: 1) # => [{a: 5, b: -1.0}, {a: 6, b: 1.0}]
  def merge(records, key, options = {})
    new_key = options[:new_key] || key
    values = records.pluck(key)
    values = rescale(values, options[:min], options[:max]).each
    records.collect { |e| e.merge(new_key => values.next) }
  end
end
