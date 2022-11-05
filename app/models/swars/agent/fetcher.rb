module Swars
  module Agent
    class Fetcher
      BASE_URL   = "https://shogiwars.heroz.jp"
      USER_AGENT = "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Mobile Safari/537.36"

      attr_reader :params

      def initialize(params = {})
        @params = {
          :remote_run => ENV["RUN_REMOTE"].in?(["1", "true"]) || Rails.env.production? || Rails.env.staging?,
          :sleep      => nil,
          :dry_run    => false,
          :verbose    => false,
        }.merge(params)
      end

      def fetch(type, url)
        if params[:SwarsConnectionFailed]
          raise SwarsConnectionFailed
        end

        if local_run?
          return mock_html(type)
        end

        begin
          resp = agent.get(url)
          sleep_on
          if resp.success?
            resp.body.force_encoding("UTF-8")
          end
        rescue Faraday::ConnectionFailed => error
          # SystemMailer.notify_exception(error)
          raise SwarsConnectionFailed
        end
      end

      private

      def agent
        @agent ||= Faraday.new(url: BASE_URL) do |conn|
          raise if OpenSSL::SSL::VERIFY_PEER != OpenSSL::SSL::VERIFY_NONE
          conn.use FaradayMiddleware::Instrumentation # --> config/initializers/0260_faraday_logger.rb
          conn.headers[:user_agent] = USER_AGENT
          conn.headers[:cookie] = Rails.application.credentials.swars_agent_cookie
        end
      end

      def remote_run?
        params[:remote_run]
      end

      def local_run?
        !remote_run?
      end

      def mock_html(type)
        Pathname(__dir__).join("mock_html/#{type}.html").read
      end

      def sleep_on
        if params[:dry_run]
          return
        end

        if v = params[:sleep]
          v = v.to_f
          if v.positive?
            if params[:verbose]
              tp "sleep: #{v}"
            end
            sleep(v)
          end
        end
      end
    end
  end
end

if $0 == __FILE__
  puts Swars::Agent::Fetcher.new.fetch("index", "https://example.com/")
end
