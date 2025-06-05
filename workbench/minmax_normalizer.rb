require "#{__dir__}/setup"

MinmaxNormalizer.safe_normalize([1, nil, 2]) # => [0.0, nil, 1.0]
MinmaxNormalizer.safe_normalize([1, 1])      # => [nil, nil]

MinmaxNormalizer.safe_normalize([1, nil, 2], method: :minus_one_to_plus_one) # => [-1.0, nil, 1.0]
