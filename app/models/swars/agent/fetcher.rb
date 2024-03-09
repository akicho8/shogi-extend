module Swars
  module Agent
    class Fetcher
      USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"

      attr_reader :params

      def initialize(params = {})
        @params = {
          :remote_run => ENV["RUN_REMOTE"].in?(["1", "true"]) || Rails.env.production? || Rails.env.staging?,
          :sleep      => nil,
          :verbose    => false,
        }.merge(params)
      end

      def fetch(type, url)
        if params[:RaiseConnectionFailed]
          raise Faraday::ConnectionFailed, ""
        end

        if local_run?
          return mock_html(type)
        end

        resp = agent.get(url)
        sleep_on
        unless resp.success?
          return
        end

        html = resp.body.force_encoding("UTF-8")
        record_the_most_recently_html_file(type, html)
        html
      end

      private

      def agent
        @agent ||= Faraday.new do |conn|
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

      # 読み込んだ直近のファイルを記録しておく
      def record_the_most_recently_html_file(type, html)
        if Rails.env.local?
          Pathname(__dir__).join("fetched_html/#{type}.html").write(html)
        end
      end
    end
  end
end

if $0 == __FILE__
  puts Swars::Agent::Fetcher.new.fetch("index", "https://example.com/")
end
