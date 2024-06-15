# frozen-string-literal: true

module Swars
  module User::Stat
    class BadTacticStat < Base
      class << self
        def report(options = {})
          User::Vip.auto_crawl_user_keys.collect { |user_key|
            if user = User[user_key]
              bad_tactic_stat = user.stat(options).bad_tactic_stat
              {
                :user_key     => user.key,
                :bad_tactic_count => bad_tactic_stat.bad_tactic_count,
              }
            end
          }.compact.sort_by { |e| -e[:bad_tactic_count] }.collect { |e|
            e.merge(bad_tactic_count: "%.2f" % e[:bad_tactic_count])
          }
        end
      end

      delegate *[
        :tag_stat,
      ], to: :stat

      def bad_tactic_count
        @bad_tactic_count ||= BadTacticInfo.sum do |e|
          tag_stat.count_by(e.key) * e.weight
        end
      end
    end
  end
end
