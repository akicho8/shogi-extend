require "nkf"

module Splitter
  extend self

  mattr_accessor(:sep) { "," }

  def split(s)
    s = NKF.nkf("-w -Z", s.to_s)
    s = s.gsub(/\s+/, "")
    s = s.gsub(/[&()・、『』。※「」]+/, sep)
    s = s.gsub(regexp) { |s| "#{sep}#{s}#{sep}" }
    s.split(/#{sep}+/).collect(&:presence).compact
  end

  def pair_split(s)
    s = s.to_s
    if s.include?("＆")
      v = s.split("＆")
    else
      v = s.split("・")
    end
    v.collect { |e| split(e) }
  end

  private

  def regexp
    @regexp ||= Regexp.union([
        /[元前](?=#{kisen_list.join("|")})/,
        /(#{kisen_list.join("|")})戦?/,
        /#{keyword.join("|")}/,
        /[一二三四五六七八九十]+[世冠]/,
        /[一二三四五六七八九十]+代目?/,
        /[初二三四五六七八九十]段/,
        /(平成)?\d+年度?/,
        /第\d+[局期]/,
        /第?\d+回戦?/,
        /\d+(歳|年)\b/,
        /\d+級/,
        /小\d+/,
      ])
  end

  def keyword
    @keyword ||= -> {
      list = Pathname("#{__dir__}/keyword.txt").read.scan(/\S+/)
      # list += nichan_names_hash.keys
      list.sort_by { |e| -e.length }
    }.call
  end

  def kisen_list
    [
      "竜王",
      "名人",
      "棋王",
      "棋聖",
      "王位",
      "王将",
      "王座",
      "叡王",
      "銀河",
      "NHK杯",
      "新人王",
      "倉敷藤花",
      "朝日",
      "赤旗",
    ]
  end

  # def nichan_names_hash
  #   @nichan_names_hash ||= Pathname("#{__dir__}/2ch棋譜_名前.txt").readlines.each_with_object({}) {|e, m|
  #     e = e.strip
  #     next if e.empty?
  #     next if e.start_with?("#")
  #     yomi, kanji = e.split
  #     m.merge(kanji => yomi)
  #   }
  # end
end
