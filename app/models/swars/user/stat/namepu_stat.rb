# frozen-string-literal: true

module Swars
  module User::Stat
    class NamepuStat < Base
      class << self
        def report(options = {})
          Swars::User::Vip.auto_crawl_user_keys.collect { |user_key|
            if user = Swars::User[user_key]
              namepu_stat = user.stat(options).namepu_stat
              {
                :user_key     => user.key,
                :namepu_count => namepu_stat.namepu_count,
              }
            end
          }.compact.sort_by { |e| -e[:namepu_count] }.collect { |e|
            e.merge(namepu_count: "%.2f" % e[:namepu_count])
          }
        end
      end

      delegate *[
        :tag_stat,
      ], to: :@stat

      def namepu_count
        @namepu_count ||= NamepuInfo.sum do |e|
          tag_stat.count_by(e.key) * e.weight
        end
      end
    end
  end
end
