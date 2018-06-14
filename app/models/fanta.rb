module Fanta
  def self.table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end
end
