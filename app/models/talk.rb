# https://us-east-1.console.aws.amazon.com/polly/home/SynthesizeSpeech
#
# Talk.new(source_text: "こんにちは")
#
# cap production rails:runner CODE='Talk.cache_delete_all'
# rails r 'Talk.cache_delete_all'
class Talk
  include SystemFileMethods

  class << self
    def default_params
      super.merge({
          polly_params: {},
        })
    end
  end

  DEFAULT_POLLY_PARAMS = {
    :output_format => "mp3",
    :sample_rate   => "16000",
    :text_type     => "text",
  }

  def normalized_text
    @normalized_text ||= TextNormalizer.new(source_text).to_s
  end

  private

  def source_text
    params[:source_text].to_s
  end

  def disk_filename
    "#{unique_key}.mp3"
  end

  def unique_key_source
    [
      polly_params[:voice_id],
      polly_params[:sample_rate],
      source_text,
    ].join(":")
  end

  def force_build
    params = polly_params.merge(text: normalized_text, response_target: real_path.to_s)
    real_path.dirname.mkpath

    if Rails.env.development? || Rails.env.test?
      Rails.logger.debug(params.to_t)
    end

    begin
      resp = client.synthesize_speech(params)
      if Rails.env.development? || Rails.env.test?
        Rails.logger.debug(resp.to_h.to_t)
        Rails.logger.debug({source_text: source_text, real_path: real_path}.to_t)
      end
    rescue Aws::Errors::NoSuchEndpointError, Aws::Polly::Errors::MovedTemporarily, Seahorse::Client::NetworkingError => error
      # インターネットに接続していないと client.synthesize_speech のタイミングで
      # Seahorse::Client::NetworkingError (SSL_connect returned=1 errno=0 state=error: certificate verify failed (self signed certificate)):
      # のエラーになる
      # if Rails.env.development?
      #   # ログが見えなくなるので出力しない
      # else
      SlackAgent.notify_exception(error)
      # end
    end
  end

  def polly_params
    DEFAULT_POLLY_PARAMS.merge({voice_id: voice_id}, params[:polly_params])
  end

  def voice_id
    "Mizuki"                    # or Takumi
  end

  def client
    @client ||= Aws::Polly::Client.new
  end

  # class PollyAdapter
  # end

  class TextNormalizer
    WORD_REPLACE_TABLE = {
      "手番" => "てばん",       # 「てつがい」と読んでしまうため
    }

    def initialize(source_text)
      @source_text = source_text
    end

    def to_s
      s = @source_text
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
      s.gsub(/#{WORD_REPLACE_TABLE.keys.join("|")}/o, WORD_REPLACE_TABLE)
    end

    # 長いURLをチャットに貼られると課金が死ぬ
    # "●http://www.xxx-yyy.com/●" -> "●example com●
    def long_url_replace(s)
      s.gsub(/(?:https?):[[:graph:]&&[:ascii:]]+/) { |url|
        host = URI(url.strip).host            # => "www.xxx-yyy.com"
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
