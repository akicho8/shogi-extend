# frozen-string-literal: true

module Swars
  module User::Stat
    class OtherStat < Base
      delegate *[
        :ids_scope,
      ], to: :stat

      def to_a
        # if ids_count.positive?
        #   return []
        # end
        av = OtherInfo.values
        if Rails.env.local?
        else
          av = av.reject(&:local_only)
        end
        av.each_with_object([]) do |e, m|
          body = @stat.instance_exec(&e.body)
          body = not_zero_allow_then_zero_as_nil(e, body)
          if body.present? || Rails.env.local?
            hv = {
              :name          => e.display_name,
              :chart_type    => e.chart_type,
              :chart_options => e.chart_options,
              :with_search   => e.with_search,
              :body          => body,
            }
            m << hv
          end
        end
      end

      # ボトルネックを探すときに使う
      # tp Swars::User.find_by!(user_key: "SugarHuuko").stat.execution_time_explain
      def execution_time_explain(sort: true)
        av = OtherInfo.collect { |e|
          body = nil
          ms = TimeTrial.ms { body = @stat.instance_exec(&e.body) }
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

      private

      def not_zero_allow_then_zero_as_nil(e, value)
        if Rails.env.local?
          if e.chart_type != :simple && e.chart_options.has_key?(:zero_allow)
            raise ArgumentError, e.inspect
          end
        end

        case e.chart_type
        when :simple
          unless e.chart_options[:zero_allow]
            if value == 0
              value = nil
            end
          end
        end

        value
      end
    end
  end
end
