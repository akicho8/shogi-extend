module Tsl
  def self.table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  # rails r 'Tsl.setup(reset: true)'
  def self.setup(options = {})
    if options[:reset]
      Tsl.destroy_all
    end
    Tsl::League.setup(options)
  end

  def self.destroy_all
    [Tsl::League, Tsl::User].each do |e|
      e.find_each(&:destroy!)
    end
  end

  def self.reset_all
    destroy_all
    setup
  end
end
