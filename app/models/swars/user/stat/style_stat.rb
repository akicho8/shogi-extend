# frozen-string-literal: true

module Swars
  module User::Stat
    class StyleStat < Base
      include StyleStatMod

      class << self
        def vip_update_all(options = {})
          options = {
            :user_keys => User::Vip.auto_crawl_user_keys,
            :max       => nil,
          }.merge(options)

          options[:user_keys].each do |user_key|
            if user = User[user_key]
              scope = user.battles
              scope = scope.where(Battle.arel_table[:updated_at].lt("2024/06/28 13:00".to_time))
              scope = scope.limit(options[:max])
              AppLog.important("#{user.key} #{scope.count}")
              tp({user.key => scope.count})
              scope.in_batches.each_record do |e|
                p e.id
                e.rebuild
              end
            end
          end
        end
      end

      def counts_hash
        @counts_hash ||= yield_self do
          s = ids_scope.joins(:style).group(Style.arel_table[:key])
          s.count.each_with_object({}) do |(style_key, count), m|
            style_info = StyleInfo[style_key]
            m[style_info.key] = count
          end
        end
      end
    end
  end
end
