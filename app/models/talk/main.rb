# ▼使い方
# render json: Talk.create(source_text: "こんにちは")
#
# ▼キャッシュ削除 (development)
# rails r 'Talk::Main.cache_delete_all'
#
# ▼キャッシュ削除 (production)
# cap production rails:runner CODE='Talk::Main.cache_delete_all'
#
module Talk
  class Main
    include SystemFileMethods

    class << self
      def output_subdirs
        "talk"
      end

      def default_params
        super.merge(api_params: {})
      end
    end

    private

    def source_text
      params[:source_text].to_s
    end

    def normalized_text
      YomiageNormalizer.new(source_text).to_s
    end

    def disk_filename
      "#{unique_key}.#{TransformApi::API_DEFAULT_PARAMS[:output_format]}"
    end

    def unique_key_source
      [api_params[:voice_id], api_params[:sample_rate], source_text].join(":")
    end

    def force_build
      real_path.dirname.mkpath
      TransformApi.new.call(api_params.merge(text: normalized_text, response_target: real_path.to_s))
    end

    def api_params
      @api_params ||= TransformApi::API_DEFAULT_PARAMS.merge({voice_id: voice_id}, params[:api_params])
    end

    def voice_id
      "Mizuki" # or Takumi
    end
  end
end
