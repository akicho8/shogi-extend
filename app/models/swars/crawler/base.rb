module Swars
  module Crawler
    class Base
      attr_accessor :params
      attr_accessor :rows

      class << self
        def run(**params)
          new(params).run
        end
      end

      def initialize(**params)
        @params = {
          developper_notice: true,
          sleep: Rails.env.production? ? 8 : 0,
        }.merge(default_params, params)

        @rows = []
      end

      def run
        @rows.clear
        perform
        if params[:developper_notice]
          ApplicationMailer.developper_notice(subject: subject, body: mail_body).deliver_now
        end
        if Rails.env.development?
          puts params.to_t
          puts @rows.to_t
        end
        self
      end

      private

      def default_params
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def perform
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def mail_body
        body = []
        body << params.to_t
        body << rows.to_t
        body.join
      end

      def subject
        self.class.name.demodulize
      end

      def report_for(user_key)
        row = {
          "日時"       => Time.current.to_s(:ymdhms),
          "ID"         => nil,
          "ユーザー名" => user_key,
          "段級"       => nil,
          "前"         => nil,
          "後"         => nil,
          "差分"       => nil,
          "検索回数"   => nil,
          "最終検索"   => nil,
          "最終対局"   => nil,
          "エラー"     => nil,
        }

        if user = lookup(user_key)
          row["ID"]         = user.id
          row["段級"]       = user.grade.name
          row["前"]         = user.battles.count
          row["最終検索"]   = user.last_reception_at&.to_s(:battle_time)
          row["検索回数"]   = user.search_logs.count
        end

        begin
          if ENV["EXECUTE_ERROR_PURPOSE"]
            1 / 0
          end
          yield
        rescue => error
          ExceptionNotifier.notify_exception(error)
          row["エラー"] = error.inspect
        end

        if user = lookup(user_key)
          row["後"] = user.battles.count
          if battle = user.battles.order(:battled_at).last
            row["最終対局"] = battle.battled_at.to_s(:battle_time_detail)
          end
        end

        if row["前"] && row["後"]
          row["差分"] = row["後"] - row["前"]
        end

        tp [row]

        rows << row
      end

      def lookup(user_key)
        User.find_by(key: user_key)
      end
    end
  end
end
