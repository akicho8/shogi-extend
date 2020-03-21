module Swars
  def self.table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  def self.setup(options = {})
    Grade.setup
  end
end
