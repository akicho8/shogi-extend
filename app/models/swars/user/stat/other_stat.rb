# frozen-string-literal: true

module Swars
  module User::Stat
    class OtherStat < Base
      delegate *[
        :ids_scope,
      ], to: :@stat

      def to_a
        av = OtherInfo.values
        if Rails.env.local?
        else
          av = av.reject(&:local_only)
        end
        av.collect do |e|
          h = {
            :name          => e.name,
            :chart_type    => e.chart_type,
            :chart_options => e.chart_options,
            :body          => @stat.instance_eval(&e.body),
          }
          if Rails.env.local?
            if e.bottom_message
              h[:bottom_message] = @stat.instance_eval(&e.bottom_message)
            end
          end
          h
        end
      end

      # ボトルネックを探すときに使う
      # tp Swars::User.find_by!(user_key: "SugarHuuko").stat.time_stats
      def time_stats(sort: true)
        av = OtherInfo.collect { |e|
          body = nil
          ms = Benchmark.ms { body = @stat.instance_eval(&e.body) }
          [ms, e, body]
        }
        if sort
          av = av.sort_by { |ms, e, body| -ms }
        end
        av.collect do |ms, e, body|
          {
            "項目" => e.name,
            "時間" => "%.2f" % ms,
            "結果" => body,
          }
        end
      end
    end
  end
end
