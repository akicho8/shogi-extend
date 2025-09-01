# 読み上げやすい文字列に変換する
#
#   YomiageNormalizer.normalize("手番w") # => "てばんわら"
#
module Talk
  class YomiageNormalizer
    class << self
      def normalize(...)
        new(...).to_s
      end
    end

    attr_accessor :source_text

    def initialize(source_text)
      @source_text = source_text
    end

    def to_s
      s = source_text
      s = pictorial_chars_delete(s)
      s = word_replace(s)
      s = long_url_replace(s)
      s = rstrip_process(s)
      s = kusa_replace(s)
      s = tag_strip(s)
      s = text_clean(s)
      s
    end

    private

    # 特殊文字を除去する
    # 除去しないとAWS側の変換が特殊文字の直前で停止してしまう
    def pictorial_chars_delete(s)
      s.encode("EUC-JP", "UTF-8", invalid: :replace, undef: :replace, replace: "").encode("UTF-8")
    end

    # 読み間違いは許容するがあきらかに支障がある文言のみ訂正する
    def word_replace(s)
      s.gsub(/#{WordReplaceTable.keys.join("|")}/o, WordReplaceTable)
    end

    # 長いURLをチャットに貼られると課金が死ぬ
    # "●http://www.xxx-yyy.com/●" -> "●example com●
    def long_url_replace(s)
      s.gsub(/(?:https?):[[:graph:]&&[:ascii:]]+/) { |url|
        host = URI(url.strip).host || ""      # => "www.xxx-yyy.com"
        host = host.remove(/^(?:www)\b/)      # => "xxx-yyy.com"
        host.scan(/\w+/).join(" ")            # => "xxx yyy com"
      }
    end

    # 語尾の w を「わら」とする
    def kusa_replace(s)
      s.sub(/[wｗ]+\z/) { |s| "わら" * s.size }
    end

    # 語尾のスペースを除去
    def rstrip_process(s)
      s.sub(/\p{Space}+\z/, "") # "テストw　" → "テストw"
    end

    # タグを除去する
    def tag_strip(s)
      s = Loofah.fragment(s).scrub!(:whitewash).to_text # 副作用で > が &gt; になったり改行が入る
      s = s.remove(/&\w+;/)                             # エスケープされたタグを除去する
    end

    # 読み上げには関係ないが綺麗にしておく
    def text_clean(s)
      s = s.gsub(/\p{Space}+/, " ")                   # to_text で埋められた改行を取る
      s = s.strip
    end
  end
end
