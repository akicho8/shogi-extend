# frozen-string-literal: true

module Swars
  module User::Stat
    module TimeMod
      DAWN_HOUR = 3

      private

      def dawn_adjusted_battled_at
        "DATE_SUB(#{zero_adjusted_battled_at}, INTERVAL #{DAWN_HOUR} HOUR)"
      end

      def zero_adjusted_battled_at
        MysqlToolkit.column_tokyo_timezone_cast(:battled_at)
      end

      def day_hours
        [
          *DAWN_HOUR...24,
          *0...DAWN_HOUR,
        ]
      end

      def date_to_day_type(t)
        case
        when t.sunday?
          :danger
        when HolidayJp.holiday?(t)
          :danger
        when t.saturday?
          :info
        end
      end
    end
  end
end
