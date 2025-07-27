module KifuExtractor
  class Base
    delegate *[
      :url_type?,
      :extracted_uri,
      :extracted_kif_uri,
      :uri_fetched_content,
    ], to: :item

    attr_accessor :body
    attr_accessor :item

    def initialize(item, options = {})
      @item = item

      @options = {
        url_check_head_lines: 4,
      }.merge(options)

      @body = nil
    end

    def resolve
      raise NotImplementedError, "#{__method__} is not implemented"
    end

    private

    # 棋譜として読み込めるか？
    def legal_valid?(str)
      begin
        info = Bioshogi::Parser.parse(str, {
            :ki2_function     => false,
            :validate_feature => false, # 二歩を許可するため
            :analysis_feature => false,
          })
        info.formatter.container_run_once
        true
      rescue Bioshogi::BioshogiError => error
        AppLog.critical(error)
        false
      end
    end

    # uri から取得して人間が書き込んだ問題の多いKIFを綺麗にする
    # uri は必ず KIF になっていること
    def human_very_dirty_kif_fetch_and_clean(uri)
      v = WebAgent2.fetch(uri)          # 元が Shift_JIS なので内部で toutf8 している
      v = v.gsub(/\\n/, "")             # なぜか '\n' の「文字」が入っているので削除
      v = Bioshogi::Source.wrap(v).to_s # 右端の謎の全角スペースなどを削除
      v = v.remove(/^\*.*\R/)           # 観戦記者の膨大なコメントを削除
    end
  end
end
