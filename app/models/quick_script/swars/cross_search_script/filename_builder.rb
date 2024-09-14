class QuickScript::Swars::CrossSearchScript
  class FilenameBuilder
    def initialize(base)
      @base = base
    end

    def call
      parts = []
      parts << "shogiwars"
      parts << Time.current.strftime("%Y%m%d%H%M%S")
      parts << @base.found_ids.size
      str = parts.compact.join("-") + ".zip"
      str
    end
  end
end
