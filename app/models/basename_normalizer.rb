module BasenameNormalizer
  extend self

  # BasenameNormalizer.normalize("/_ _/(A 漢 あ ア .).mp3").to_s # => "/_ _/A漢あア.mp3"
  def normalize(file)
    file = Pathname(file)
    basename = file.basename(".*").to_s
    regexp = Regexp.union(/\w+/, /\p{Hiragana}+/, /\p{Katakana}+/, /\p{Han}+/)
    basename = basename.scan(regexp).join
    file.dirname + "#{basename}#{file.extname}"
  end
end
