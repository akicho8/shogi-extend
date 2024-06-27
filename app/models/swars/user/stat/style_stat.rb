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
              tp({user.key => user.battles.count})
              user.battles.order(battled_at: :desc).limit(options[:max]).in_batches.each_record(&:remake)
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
