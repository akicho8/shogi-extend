require "#{__dir__}/setup"
MinmaxScaler.rescale([])               # => []
MinmaxScaler.rescale([nil])            # => [nil]
MinmaxScaler.rescale([5])              # => [nil]
MinmaxScaler.rescale([5, nil, 9])      # => [0.0, nil, 1.0]
MinmaxScaler.rescale([9, 7, 5], -1, 1) # => [1.0, 0.0, -1.0]
MinmaxScaler.rescale([9, 7, 5], 1, -1) # => [-1.0, 0.0, 1.0]

MinmaxScaler.merge([{a: 5}, {a: 6}], :a)                               # => [{a: 0.0}, {a: 1.0}]
MinmaxScaler.merge([{a: 5}, {a: 6}], :a, new_key: :b, min: -1, max: 1) # => [{a: 5, b: -1.0}, {a: 6, b: 1.0}]

