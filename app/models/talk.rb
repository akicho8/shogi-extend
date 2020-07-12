# https://us-east-1.console.aws.amazon.com/polly/home/SynthesizeSpeech
#
# Talk.new(source_text: "こんにちは")
#
class Talk
  cattr_accessor(:surrogate_pair_delete_enable) { true } # 特殊文字の除去 (除去しないとAWS側の変換が特殊文字の直前で停止してしまう)

  cattr_accessor :default_polly_params do
    {
      output_format: "mp3",
      sample_rate: "16000",
      text_type: "text",
    }
  end

  attr_accessor :source_text
  attr_accessor :params

  def initialize(params = {})
    @params = {
      polly_params: {},
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

  private

  def source_text
    params[:source_text].to_s
  end

  def surrogate_pair_deleted_text
    if surrogate_pair_delete_enable
      source_text.encode("EUC-JP", "UTF-8", invalid: :replace, undef: :replace, replace: "").encode("UTF-8")
    else
      source_text
    end
  end

  def direct_file_path
    Rails.public_path.join("system", self.class.name.underscore, *dir_parts, filename)
  end

  def filename
    "#{unique_key}.mp3"
  end

  def unique_key
    @unique_key ||= Digest::MD5.hexdigest(unique_source_value)
  end

  def unique_source_value
    [polly_params[:voice_id], polly_params[:sample_rate], source_text].join(":")
  end

  def generate_if_not_exist
    if direct_file_path.exist?
      if Rails.env.production? || Rails.env.staging? || Rails.env.test?
        # すでにファイルが生成されている場合はパスする
        return
      end
    end

    force_generate
  end

  def force_generate
    params = polly_params.merge(text: surrogate_pair_deleted_text, response_target: direct_file_path.to_s)
    direct_file_path.dirname.mkpath
    resp = client.synthesize_speech(params)

    # ドトールで実行すると client.synthesize_speech のタイミングで
    # Seahorse::Client::NetworkingError (SSL_connect returned=1 errno=0 state=error: certificate verify failed (self signed certificate)):
    # のエラーになることがある

    if Rails.env.production? || Rails.env.staging?
    else
      Rails.logger.debug(params.to_t)
      Rails.logger.debug(resp.to_h.to_t)
      # >> |-------------+----------------------------------------|
      # >> |      region | us-west-2                              |
      # >> | credentials | #<Aws::Credentials:0x00007fdb7bc7ba10> |
      # >> |-------------+----------------------------------------|
      # >> |--------------------+-----------------------------------------------------|
      # >> |       audio_stream | #<Seahorse::Client::ManagedFile:0x00007fdb7ba74cf8> |
      # >> |       content_type | audio/mpeg                                          |
      # >> | request_characters | 5                                                   |
      # >> |--------------------+-----------------------------------------------------|
      Rails.logger.info("#{__method__}: #{source_text.inspect} => #{direct_file_path}")
    end
  rescue Aws::Errors::NoSuchEndpointError, Aws::Polly::Errors::MovedTemporarily => error
    Rails.logger.info ["#{__FILE__}:#{__LINE__}", __method__, error].to_t
  end

  def polly_params
    default_polly_params.merge({voice_id: voice_id}, @params[:polly_params])
  end

  def voice_id
    if Rails.env.production? || Rails.env.staging?
      return "Mizuki"
    end

    t = Time.current
    if t.saturday? || t.sunday? || t.hour.modulo(2).even? || HolidayJp.holiday?(t)
      "Mizuki"
    else
      "Takumi"
    end
  end

  def relative_path
    Rails.application.routes.url_helpers.root_path + direct_file_path.relative_path_from(Rails.public_path).to_s
  end

  def dir_parts
    unique_key.match(/(.{2})(.{2})/).captures
  end

  def client
    @client ||= Aws::Polly::Client.new
  end
end
