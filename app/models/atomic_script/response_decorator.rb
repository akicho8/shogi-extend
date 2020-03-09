module AtomicScript
  class ResponseDecorator < Hash
    def to_result_label
      if time_label && bm_ms_str
        "#{time_label}の実行結果(#{bm_ms_str})"
      else
        "実行結果"
      end
    end

    private

    def time_label
      if self[:time]
        self[:time].to_time.to_s(:exec_distance)
      end
    end

    def bm_ms_str
      if self[:bm_ms]
        "%.1f ms" % self[:bm_ms]
      end
    end
  end
end
