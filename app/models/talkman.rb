class Talkman
  cattr_accessor :default_polly_params do
    {
      output_format: "mp3",
      sample_rate: "16000",
      text_type: "text",
      voice_id: "Mizuki",
    }
  end

  attr_accessor :text

  def initialize(text)
    @text = text
  end

  # QRコード画像のURLを返す(画像は必ずある)
  def service_path
    generate_if_not_exist
    relative_path
  end

  # QRコード画像のファイルパスを返す(画像は必ずある)
  def real_path
    generate_if_not_exist
    direct_file_path
  end

  private

  # QRコード画像の実際のパス
  def direct_file_path
    Rails.public_path.join("system", self.class.name.underscore, *dir_parts, filename)
  end

  def filename
    "#{@hash_key}.mp3"
  end

  def hash_key
    @hash_key ||= Digest::MD5.hexdigest(text)
  end

  def generate_if_not_exist
    if direct_file_path.exist?
      if Rails.env.production?
        return
      end
    end

    force_generate
  end

  def force_generate
    direct_file_path.dirname.mkpath

    FileUtils.makedirs(direct_file_path.dirname)
    resp = client.synthesize_speech(default_polly_params.merge(text: text, response_target: direct_file_path.to_s))
    tp resp.to_h
    # >> |-------------+----------------------------------------|
    # >> |      region | us-west-2                              |
    # >> | credentials | #<Aws::Credentials:0x00007fdb7bc7ba10> |
    # >> |-------------+----------------------------------------|
    # >> |--------------------+-----------------------------------------------------|
    # >> |       audio_stream | #<Seahorse::Client::ManagedFile:0x00007fdb7ba74cf8> |
    # >> |       content_type | audio/mpeg                                          |
    # >> | request_characters | 5                                                   |
    # >> |--------------------+-----------------------------------------------------|

    Rails.logger.info("#{__method__}: #{text} => #{direct_file_path}")
  end

  def relative_path
    Rails.application.routes.url_helpers.root_path + direct_file_path.relative_path_from(Rails.public_path).to_s
  end

  def dir_parts
    hash_key.match(/(.{2})(.{2})/).captures
  end

  def client
    @client ||= Aws::Polly::Client.new
  end
end
