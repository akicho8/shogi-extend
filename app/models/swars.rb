module Swars
  def self.table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  def self.setup(*args)
    Grade.setup(*args)
  end
end
