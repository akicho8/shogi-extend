module ShortUrl
  def self.table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  def self.from(...)
    Component.from(...)
  end

  # rails r 'ShortUrl.setup(reset: true)'
  def self.setup(options = {})
    if options[:reset]
      ShortUrl.destroy_all
    end
    # ShortUrl::League.setup(options)
  end

  def self.destroy_all
    [
      Component,
    ].each do |e|
      e.find_each(&:destroy!)
    end
  end

  def self.reset_all
    destroy_all
    setup
  end
end
