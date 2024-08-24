module Swars
  module Crawler
    class Base
      attr_accessor :params

      class << self
        def run(...)
          new(...).run
        end
      end

      def initialize(params = {})
        @params = {
          :notify  => true,
          :sleep   => Rails.env.local? ? 0 : 2,
          :subject => nil,
        }.merge(default_params, params)
      end

      def run
        perform
        mail_send
        if Rails.env.development?
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

      def mail_body
        av = []
        av << params.to_t(truncate: 80)
        av << rows.to_t
        av.join
      end

      def mail_subject
        @params[:subject] || self.class.name
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
    end
  end
end
