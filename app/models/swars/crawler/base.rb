module Swars
  module Crawler
    class Base
      attr_accessor :params

      class << self
        def call(...)
          new(...).call
        end
      end

      def initialize(params = {})
        @params = {
          :notify  => true,
          :sleep   => Rails.env.local? ? 0 : 1,
          :subject => nil,
        }.merge(default_params, params)
      end

      def call
        perform
        mail_send
        if Rails.env.development?
          p mail_subject
          puts params.to_t
          puts rows.to_t
        end
        self
      end

      def rows
        @rows ||= []
      end

      def mail_send
        if params[:notify]
          AppLog.important(subject: mail_subject, body: mail_body)
        end
      end

      def mail_subject
        str = @params[:subject] || self.class.name
        "[将棋ウォーズ][クロール完了][#{str}] +#{total}"
      end

      def mail_body
        av = []
        av << params.to_t(truncate: 80)
        av << rows.to_t
        av.join
      end

      private

      def perform
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def default_params
        {}
      end

      def report_for(user_key, &block)
        rows << Reporter.new(user_key).call(&block)
      end

      def total
        rows.sum { |e| e["差分"].to_i }
      end
    end
  end
end
