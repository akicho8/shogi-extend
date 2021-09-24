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

  cattr_accessor :replace_table do
    {
      "手番" => "てばん",
    }
  end

  cattr_accessor :default_polly_params do
    {
      :output_format => "mp3",
      :sample_rate   => "16000",
      :text_type     => "text",
    }
  end

  cattr_accessor(:pictorial_chars_delete_enable) { true } # 特殊文字の除去 (除去しないとAWS側の変換が特殊文字の直前で停止してしまう)

  def normalized_text
    @normalized_text ||= -> {
      s = source_text
      if pictorial_chars_delete_enable
        s = s.encode("EUC-JP", "UTF-8", invalid: :replace, undef: :replace, replace: "").encode("UTF-8")
      end
      if replace_table
        s = s.gsub(/#{replace_table.keys.join("|")}/o, replace_table)
      end
      s = s.sub(/\p{Space}+\z/, "")                     # "テストw　" → "テストw"
      s = s.sub(/[wｗ]+\z/) { |s| "わら" * s.size }

      s = Loofah.fragment(s).scrub!(:whitewash).to_text # タグを除去。副作用で > が &gt; になったり改行が入る
      s = s.remove(/&\w+;/)                             # エスケープされたタグを除去する

      # 読み上げには関係ないが綺麗にしておく
      if true
        s = s.gsub(/\p{Space}+/, " ")                   # to_text で埋められた改行を取る
        s = s.strip
      end

      s
    }.call
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
    default_polly_params.merge({voice_id: voice_id}, params[:polly_params])
  end

  def voice_id
    "Mizuki"                    # or Takumi
  end

  def client
    @client ||= Aws::Polly::Client.new
  end
end
