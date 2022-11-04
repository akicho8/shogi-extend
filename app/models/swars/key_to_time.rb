module Swars
  # キーは "(先手名)-(後手名)-(日付)" となっているので最後を開始日時とする
  class KeyToTime
    def initialize(key)
      @key = key
    end

    def to_time
      if @key.include?("-")
        ymd = @key.split("-").last
        if ymd.match?(/\A\d+_\d+\z/)
          Time.zone.parse(ymd)
        end
      end
    end
  end
end
