class QuickScript::Swars::BattleDownloadScript
  class FilenameBuilder
    def initialize(base)
      @base = base
    end

    def call
      parts = []
      parts << "shogiwars"
      parts << @base.swars_user.key
      parts << @base.main_scope.count
      parts << latest_battled_at.strftime("%Y%m%d%H%M%S")
      parts << @base.format_info.key
      parts << @base.encode_info.key
      str = parts.compact.join("-") + ".zip"
      str
    end

    private

    def latest_battled_at
      @base.main_scope.maximum(:battled_at) || Time.current
    end
  end
end
