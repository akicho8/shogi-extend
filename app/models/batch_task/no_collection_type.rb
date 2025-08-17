module BatchTask
  module NoCollectionType
    def call
      measure_block do
        process
      end
    end

    def process
      raise NotImplementedError, "#{__method__} is not implemented"
    end
  end
end
