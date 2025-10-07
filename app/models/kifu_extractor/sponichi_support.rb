module KifuExtractor
  module SponichiSupport
    # 入力されたテキストにそのまま適用するとKIFのコメント内の符号を拾ってしまうので注意
    def sponichi_scan(item)
      s = item.source.toutf8
      s = StringSupport.strip_tags(s)
      s = s.remove(/\p{blank}/)
      s = s.remove(/.*◆指し手/m)   # 上側を削除
      s = s.remove(/※持ち時間.*/m) # 下側を削除
      s = s.tr("０-９（）", "0-9()")
      av = Bioshogi::InputParser.scan(s)
      av = av.find_all { |e| e.match?(/[▲△]/) } # ゴミが混ざるため
      if av.present?
        @body = av.join(" ")
      end
    end
  end
end
