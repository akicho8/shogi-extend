module Swars
  module Crawler
    class Reporter
      def initialize(user_key)
        @user_key = user_key
      end

      def call(&block)
        row = {
          "日時"       => Time.current.to_fs(:ymdhms),
          "ID"         => nil,
          "ユーザー名" => @user_key,
          "段級"       => nil,
          "前"         => nil,
          "後"         => nil,
          "差分"       => nil,
          "検索回数"   => nil,
          "最終検索"   => nil,
          "最終対局"   => nil,
          "エラー"     => nil,
        }

        if user
          row["ID"]       = user.id
          row["段級"]     = user.grade.name
          row["前"]       = user.battles.count
          row["最終検索"] = user.last_reception_at&.to_fs(:battle_time)
          row["検索回数"] = user.search_logs.count
        end

        begin
          if ENV["EXECUTE_ERROR_PURPOSE"]
            1 / 0
          end
          yield
        rescue => error
          AppLog.error(error, data: {user_key: @user_key})
          row["エラー"] = "#{error.message} (#{error.class.name})"
        end

        if user
          row["後"] = user.battles.count
          if battle = user.battles.order(:battled_at).last
            row["最終対局"] = battle.battled_at.to_fs(:ymdhms)
          end
        end

        if row["前"] && row["後"]
          row["差分"] = "%+d" % [row["後"] - row["前"]]
        end

        if ENV["VERBOSE"]
          tp [row]
        end

        row
      end

      def user
        @user ||= User.find_by(key: @user_key)
      end
    end
  end
end
