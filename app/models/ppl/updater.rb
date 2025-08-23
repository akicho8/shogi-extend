# |----------------------+------------------------------------------------------|
# | 本番用セットアップ   | Ppl::Updater.resume_crawling                         |
# | ローカルで全読み込み | Ppl::Updater.resume_crawling                         |
# | 範囲 N から 2 件     | Ppl::Updater.resume_crawling(start: "S49", limit: 2) |
# |----------------------+------------------------------------------------------|

module Ppl
  module Updater
    extend self

    def latest_key
      Season.latest_key || AntiquitySpider.accept_range.min
    end

    # Ppl::Updater.resume_crawling
    # Ppl::Updater.resume_crawling(sleep: 1, start: "75", limit: 2)
    def resume_crawling(options = {})
      options = {
        :start => Season.latest_or_base_key,
        :limit => nil,
      }.merge(options)

      season_key_vo = SeasonKeyVo[options[:start]]
      (0..).each do |i|
        if options[:limit] && i >= options[:limit]
          break
        end
        update_from_web(season_key_vo, options)
        season_key_vo = season_key_vo.succ
      end
    rescue OpenURI::HTTPError
    end

    # Ppl::Updater.update_from_web(SeasonKeyVo["59"])
    def update_from_web(season_key_vo, options = {})
      update_raw(season_key_vo, season_key_vo.records(options))
    end

    def update_raw(season_key_vo, records = [])
      season = SeasonKeyVo[season_key_vo].season
      Array.wrap(records).each do |record|
        user = User.find_or_create_by!(name: record[:name] || "(name#{User.count.next})")
        if v = record[:mentor].presence
          mentor = Mentor.find_or_create_by!(name: v)
          mentor_change_log(user, mentor)
          user.update!(mentor: mentor)
        end
        membership = user.memberships.find_or_initialize_by(season: season)
        membership.update!(record.slice(:result_key, :age, :win, :lose, :ox))
      end
      User.find_each(&:update_deactivated_season)
    end

    # Ppl::Updater.test("8", "alice", "昇段")
    def test(season_key_vo, name, result_key)
      update_raw(season_key_vo, { name: name, result_key: result_key })
    end

    def json_write
      season_key_vo = Ppl::SeasonKeyVo.start
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
      season_key_vo = Ppl::SeasonKeyVo.start
      all.each do |rows|
        p season_key_vo
        Ppl::Updater.update_raw(season_key_vo, rows)
        season_key_vo = season_key_vo.succ
      end
    end

    private

    def mentor_change_log(user, mentor)
      if user.mentor && user.mentor.name != mentor.name
        tp({ "対象" => user.name, "前師匠" => user.mentor.name, "新師匠" => mentor.name })
      end
    end
  end
end
