module BasenameNormalizer
  extend self

  def normalize(file)
    file = Pathname(file)
    basename = file.basename(".*").to_s
    regexp = Regexp.union(/\w+/, /\p{Hiragana}+/, /\p{Katakana}+/, /\p{Han}+/)
    basename = basename.scan(regexp).join
    file.dirname + "#{basename}#{file.extname}"
  end
end
