class QueryInfo
  class << self
    def parse(*args)
      new(*args).tap do |e|
        e.parse
      end
    end
  end

  attr_accessor :options
  attr_accessor :query
  attr_accessor :attributes
  attr_accessor :values
  attr_accessor :urls

  def initialize(query, options = {})
    @options = {
      available_keys: nil,
    }.merge(options)

    @query = query

    reset
  end

  def parse
    str = query.to_s.gsub(/\p{Space}+/, " ").strip
    str.split.each do |s|
      parse_one_part(s)
    end
    @attributes = @attributes.transform_values(&:uniq)
  end

  def lookup(key)
    @attributes[key.to_sym]
  end

  def lookup_one(key)
    if v = lookup(key)
      v.first
    end
  end

  private

  def reset
    @attributes = {}
    @values = []
    @urls = []
  end

  def parse_one_part(s)
    case
    when s.match?(/\A(https?:)/i)
      urls << s
    when md = s.match(/\A(?<key>#{available_keys_regexp}):(?<value>\S+)/i)
      key = md["key"].to_sym
      attributes[key] ||= []
      attributes[key].concat(md["value"].split(","))
    else
      values.concat(s.split(","))
    end
  end

  def available_keys_regexp
    if v = @options[:available_keys]
      Regexp.union(v)
    else
      /[\w\-]+/
    end
  end
end
