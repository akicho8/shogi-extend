# -*- frozen_string_literal: true -*-

class QueryInfo
  OPERATORS = {
    ">=" => :gteq,
    ">"  => :gt,
    "==" => :eq,
    "<=" => :lteq,
    "<"  => :lt,
  }
  OPRATOR_KEYS_REGEXP    = Regexp.union(OPERATORS.keys) # />=|>/
  OPERATOR_SYNTAX_REGEXP = /\A(?<oprator>#{OPRATOR_KEYS_REGEXP})(?<value>[-\d]\d*)/o # foo:>=-1 にマッチ  # (?<value>[^<>=].*) でも良い

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
      values = md["value"].split(",")

      values = values.collect do |e|
        if md = e.match(OPERATOR_SYNTAX_REGEXP)
          operator = OPERATORS.fetch(md["oprator"])
          { operator: operator, value: md[:value].to_i }
        else
          e
        end
      end

      attributes[key] ||= []
      attributes[key].concat(values)
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
