# ▼人数確認
# cap production rails:runner CODE="p Swars::User.vip_except.momentum_only(period: 1.days, at_least: 5).hard_crawled_old_only(1.days).count"
#
# ▼即反映
# cap production deploy:upload FILES=app/models/swars/crawler/momentum_crawler.rb
#
# ▼対象人数
# |--------+----------+------|
# | period | at_least | 人数 |
# |--------+----------+------|
# | 1.days |        5 |  329 |
# | 1.days |        6 |  199 |
# | 1.days |        7 |  143 |
# |--------+----------+------|
#
module Swars
  module Crawler
    # Swars::Crawler::MomentumCrawler.new(page_max: 3, sleep: 5).run
    class MomentumCrawler < Base
      def default_params
        super.merge({
            :subject          => "直近数日で注目されているユーザー",
            :page_max         => Rails.env.production? ? 100 : 1,
            :early_break      => false,  # false: 全体クロール
            :period           => 1.days, # この期間で
            :at_least         => 5,      # N件以上検索されている(多い順)
            :limit            => 50,     # ユーザーを最大N件
            :hard_crawled_old => 1.days, # 全体クロールしてN日以上経過している人たち
          })
      end

      def perform
        s = User.all
        s = s.vip_except
        s = s.momentum_only(period: params[:period], at_least: params[:at_least])
        s = s.hard_crawled_old_only(params[:hard_crawled_old])
        s = s.limit(params[:limit])
        s.find_each do |user|
          report_for(user.key) do
            Importer::AllRuleImporter.new(params.merge(user_key: user.key)).run
          end
        end
      end
    end
  end
end
