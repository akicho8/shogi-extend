# |----------------------+-------------------------------|
# | 本番用セットアップ   | Ppl::Updater.resume_crawling  |
# | ローカルで全読み込み | Ppl::Updater.resume_crawling  |
# | ネット → JSON生成   | Ppl::Updater.json_write       |
# | JSON → DB           | Ppl::Updater.import_from_json |
# |----------------------+-------------------------------|

module Ppl
  module Updater
    extend self

    # Ppl::Updater.resume_crawling
    # Ppl::Updater.resume_crawling(sleep: 1, start: SeasonKeyVo["75"], limit: 2)
    def resume_crawling(options = {})
      options = {
        :start => Season.latest_or_base_key,
        :limit => nil,
      }.merge(options)

      season_key_vo = options[:start]
      (0..).each do |i|
        if options[:limit] && i >= options[:limit]
          break
        end
        season_key_vo.users_update_from_web(options)
        season_key_vo = season_key_vo.succ
      end
    rescue OpenURI::HTTPError
    end

    def json_write
      season_key_vo = SeasonKeyVo.start
      all = []
      begin
        loop do
          p season_key_vo
          all << season_key_vo.records
          season_key_vo = season_key_vo.succ
        end
      rescue OpenURI::HTTPError
      end
      Pathname("all.json").write(all.to_json)
    end

    def import_from_json
      all = JSON.parse(Pathname("all.json").read, symbolize_names: true)
      season_key_vo = SeasonKeyVo.start
      all.each do |records|
        p season_key_vo
        season_key_vo.users_update(records)
        season_key_vo = season_key_vo.succ
      end
    end
  end
end
