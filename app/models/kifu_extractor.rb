module KifuExtractor
  def self.extract(source, options = {})
    Extractor.new(source, options).extract
  end
end
