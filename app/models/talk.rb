#
# Talk.new(source_text: "こんにちは")
#
class Talk
  cattr_accessor :default_polly_params do
    {
      output_format: "mp3",
      sample_rate: "16000",
      text_type: "text",
      voice_id: "Mizuki",
      # voice_id: "Takumi",
    }
  end

  attr_accessor :source_text
  attr_accessor :params

  def initialize(**params)
    @params = {
      polly_params: {},
    }.merge(params)
  end

  def service_path
    generate_if_not_exist
    relative_path
  end

  def real_path
    generate_if_not_exist
    direct_file_path
  end

  def as_json(*)
    {
      service_path: service_path,
    }
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
    @unique_key ||= Digest::MD5.hexdigest(unique_source_value)
  end

  def unique_source_value
    [polly_params[:voice_id], polly_params[:sample_rate], source_text].join(":")
  end

  def generate_if_not_exist
    if direct_file_path.exist?
      if Rails.env.production? || Rails.env.test?
        return
      end
    end

    force_generate
  end

  def force_generate
    params = polly_params.merge(text: source_text, response_target: direct_file_path.to_s)
    tp params
    direct_file_path.dirname.mkpath
    resp = client.synthesize_speech(params)
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

    Rails.logger.info("#{__method__}: #{source_text} => #{direct_file_path}")
  end

  def polly_params
    default_polly_params.merge(@params[:polly_params])
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
