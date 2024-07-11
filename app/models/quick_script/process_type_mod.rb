module QuickScript
  concern :ProcessTypeMod do
    def axios_process_type
      (@options[:axios_process_type] || :server)&.to_sym
    end

    def as_json(*)
      super.merge(axios_process_type: axios_process_type)
    end
  end
end
