module GoogleApi
  module Root
    def table_name_prefix
      @table_name_prefix ||= name.underscore.gsub("/", "_") + "_"
    end
  end
end
