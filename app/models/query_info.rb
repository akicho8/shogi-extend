# -*- frozen_string_literal: true -*-

class QueryInfo
  OPERATORS = {
    ">=" => :gteq,
    ">"  => :gt,
    "==" => :eq,
    "!=" => :not_eq,
    "<=" => :lteq,
    "<"  => :lt,
  }

  OPRATOR_KEYS_REGEXP    = Regexp.union(OPERATORS.keys) # />=|>/
  OPERATOR_SYNTAX_REGEXP = /\A(?<oprator>#{OPRATOR_KEYS_REGEXP})(?<value>[-\d]\d*)/o # foo:>=-1 にマッチ  # (?<value>[^<>=].*) でも良い

  class << self
    def [](...)
      parse(...)
    end

    def parse(...)
      new(...).tap(&:parse).freeze
    end

    def null
      @null ||= parse
    end

    def swars_user_key(...)
      parse(...).swars_user_key
    end
  end

  attr_accessor :options
  attr_accessor :query
  attr_accessor :attributes
  attr_accessor :values
  attr_accessor :urls

  def initialize(query = nil, options = {})
    @options = {
      :available_keys => nil,
    }.merge(options)

    @query = query.to_s
    @cache = {}

    @attributes = {}
    @values = []
    @urls = []
  end

  def parse
    str = query.to_s
    str = BibiRemover.remove(str)
    str = str.gsub(/\p{Space}+/, " ").squish
    str.split.each do |s|
      parse_one_part(s)
    end
    @attributes = @attributes.transform_values(&:uniq)
  end

  def lookup(key)
    @attributes[key.to_sym]
  end

  def lookup_first(keys)
    if Rails.env.local?
      unless keys.kind_of?(Array)
        raise TypeError, keys.inspect
      end
    end
    if e = keys.find { |e| lookup(e) }
      lookup(e)
    end
  end

  def lookup_one(key)
    if v = lookup(key)
      v.first
    end
  end

  def lookup_op(key)
    if v = lookup_one(key)
      if v.kind_of?(Hash)
        v
      end
    end
  end

  ################################################################################

  def swars_user_key_extractor
    @cache[__method__] ||= Swars::UserKeyExtractor.new(self)
  end

  def swars_user_key
    return @cache[__method__] if @cache.has_key?(__method__)
    @cache[__method__] ||= swars_user_key_extractor.extract
  end

  def swars_user
    return @cache[__method__] if @cache.has_key?(__method__)
    @cache[__method__] ||= swars_user_key&.db_record
  end

  ################################################################################

  def item_infos
    @cache[__method__] ||= values.collect { |value| Bioshogi::Analysis::TagIndex.fuzzy_lookup(value) }.compact
  end

  def grade_infos
    @cache[__method__] ||= values.collect { |value| Swars::GradeInfo.lookup(value) }.compact
  end

  def preset_infos
    @cache[__method__] ||= values.collect { |value| PresetInfo.lookup(value) }.compact
  end

  def style_infos
    @cache[__method__] ||= values.collect { |value| Bioshogi::Analysis::StyleInfo.lookup(value) }.compact
  end

  ################################################################################

  private

  def parse_one_part(s)
    case
    when s.match?(/\A(https?:)/i)
      @urls << s
    when md = s.match(/\A(?<key>#{available_keys_regexp}):(?<value>\S+)/io) # foo:>=1
      key = md["key"].to_sym           # :foo
      vals = md["value"].split(",")    # [">=1"]

      vals = vals.collect do |e|
        if md = e.match(OPERATOR_SYNTAX_REGEXP)          # ">=" と "1" に分離
          operator = OPERATORS.fetch(md["oprator"])
          { operator: operator, value: md[:value].to_i } # => { operator: :gteq, value: 1 }
        else
          e
        end
      end

      attributes[key] ||= []
      attributes[key].concat(vals)
    else
      @values.concat(s.split(","))
    end
  end

  def available_keys_regexp
    if v = @options[:available_keys]
      Regexp.union(v)
    else
      /\p{Graph}+/
    end
  end
end
