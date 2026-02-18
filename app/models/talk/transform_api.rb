module Talk
  class TransformApi
    # https://us-east-1.console.aws.amazon.com/polly/home/SynthesizeSpeech
    API_DEFAULT_PARAMS = {
      :output_format => "mp3",
      :sample_rate   => "16000",
      :text_type     => "text",
    }

    def call(params)
      Rails.logger.debug { params.to_t }
      begin
        resp = client.synthesize_speech(params)
        Rails.logger.debug { resp.to_h.to_t }
      rescue Aws::Errors::NoSuchEndpointError, Aws::Polly::Errors::ServiceError, Seahorse::Client::NetworkingError => error
        # ネットに接続していない場合のエラー
        # Seahorse::Client::NetworkingError (SSL_connect returned=1 errno=0 state=error: certificate verify failed (self signed certificate)):
        AppLog.critical(error)

        if Rails.env.test?
          raise error
        end
      end
    end

    def client
      Aws::Polly::Client.new
    end
  end
end
