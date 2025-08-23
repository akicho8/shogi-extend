# |----------------------+------------------------------------------------------------------------|
# | 本番用セットアップ   | Ppl::Updater.resume_crawling                                           |
# | ローカルで全読み込み | Ppl::Updater.resume_crawling                                           |
# | 範囲 N から 2 件     | Ppl::Updater.resume_crawling(season_key_begin: "S49", limit: 2) |
# |----------------------+------------------------------------------------------------------------|

module Ppl
  module Updater
    extend self

    def latest_key
      Season.latest_key || AntiquitySpider.accept_range.min
    end

    # Ppl::Updater.resume_crawling
    # Ppl::Updater.resume_crawling(sleep: 1, season_key_begin: "75", limit: 2)
    def resume_crawling(options = {})
      options = {
        :season_key_begin => Season.latest_key_or_base,
        :limit => nil,
      }.merge(options)

      season_key_vo = SeasonKeyVo[options[:season_key_begin]]
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

    def update_raw(season_key_vo, records = [{}])
      season_key_vo = SeasonKeyVo[season_key_vo]
      records = Array.wrap(records)
      if records.present?
        season = season_key_vo.season
        records.each do |record|
          user = User.find_or_create_by!(name: record[:name] || "(name#{User.count.next})")
          if v = record[:mentor].presence
            mentor = Mentor.find_or_create_by!(name: v)
            if user.mentor && user.mentor.name != mentor.name
              tp({ "対象" => user.name, "前師匠" => user.mentor.name, "新師匠" => mentor.name })
            end
            user.update!(mentor: mentor)
          end

          membership = user.memberships.find_or_initialize_by(season: season)
          membership.update!(record.slice(:result_key, :age, :win, :lose, :ox))
        end

        User.find_each(&:update_deactivated_season)
      end
    end

    # Ppl::Updater.test(8, "alice", "昇段")
    def test(season_number, name, result_key)
      update_raw(season_number, { name: name, result_key: result_key })
    end
  end
end
