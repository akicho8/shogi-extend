# https://us-east-1.console.aws.amazon.com/polly/home/SynthesizeSpeech
#
# Talk.new(source_text: "こんにちは")
#
class Talk
  cattr_accessor :replace_table do
    # {
    #   "手指" => "てさ",
    # }
  end

  cattr_accessor :default_polly_params do
    {
      :output_format => "mp3",
      :sample_rate   => "16000",
      :text_type     => "text",
    }
  end

  cattr_accessor(:pictorial_chars_delete_enable) { true } # 特殊文字の除去 (除去しないとAWS側の変換が特殊文字の直前で停止してしまう)

  attr_accessor :params

  def initialize(params = {})
    @params = {
      polly_params: {},
      cache_enable: Rails.env.production? || Rails.env.staging? || Rails.env.test?,
    }.merge(params)
  end

  def mp3_path
    generate_if_not_exist
    relative_path
  end

  def real_path
    generate_if_not_exist
    direct_file_path
  end

  def as_json(*)
    {
      mp3_path: mp3_path,
    }
  end

  def cache_delete
    FileUtils.rm_f(direct_file_path)
  end

  def normalized_text
    @normalized_text ||= -> {
      s = source_text
      if pictorial_chars_delete_enable
        s = s.encode("EUC-JP", "UTF-8", invalid: :replace, undef: :replace, replace: "").encode("UTF-8")
      end
      if replace_table
        s = s.gsub(/#{replace_table.keys.join("|")}/o, replace_table)
      end
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

  def direct_file_path
    Rails.public_path.join("system", self.class.name.underscore, *dir_parts, filename)
  end

  def filename
    "#{unique_key}.mp3"
  end

  def unique_key
    @unique_key ||= Digest::MD5.hexdigest(unique_key_source_string)
  end

  def unique_key_source_string
    [polly_params[:voice_id], polly_params[:sample_rate], source_text].join(":")
  end

  def generate_if_not_exist
    if params[:cache_enable] && direct_file_path.exist?
      return
    end

    force_generate
  end

  def force_generate
    params = polly_params.merge(text: normalized_text, response_target: direct_file_path.to_s)
    direct_file_path.dirname.mkpath

    if Rails.env.development? || Rails.env.test?
      Rails.logger.debug(params.to_t)
    end

    begin
      resp = client.synthesize_speech(params)
      if Rails.env.development? || Rails.env.test?
        Rails.logger.debug(resp.to_h.to_t)
        Rails.logger.debug({source_text: source_text,direct_file_path: direct_file_path}.to_t)
      end
    rescue Aws::Errors::NoSuchEndpointError, Aws::Polly::Errors::MovedTemporarily => error
      # 不安定な環境で実行すると client.synthesize_speech のタイミングで
      # Seahorse::Client::NetworkingError (SSL_connect returned=1 errno=0 state=error: certificate verify failed (self signed certificate)):
      # のエラーになることがある
      # が、よくわからんので例外に含めていない
      SlackAgent.notify_exception(error)
    end
  end

  def polly_params
    default_polly_params.merge({voice_id: voice_id}, params[:polly_params])
  end

  def voice_id
    "Mizuki"                    # or Takumi
  end

  # system/ だと /s/system になってしまうので / から始めるようにする
  def relative_path
    "/" + direct_file_path.relative_path_from(Rails.public_path).to_s
  end

  def dir_parts
    unique_key.match(/(.{2})(.{2})/).captures
  end

  def client
    @client ||= Aws::Polly::Client.new
  end
end
