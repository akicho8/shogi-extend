# |----------------------+-----------------------------------------------------|
# | 本番用セットアップ   | Ppl::Updater.resume_crawling                        |
# | ローカルで全読み込み | Ppl::Updater.resume_crawling                        |
# | 範囲 N 以降          | Ppl::Updater.resume_crawling(season_numbers: (75..))   |
# | 範囲 A と B          | Ppl::Updater.resume_crawling(season_numbers: [59, 77]) |
# |----------------------+-----------------------------------------------------|

module Ppl
  module Updater
    extend self

    # Ppl::Updater.resume_crawling
    # Ppl::Updater.resume_crawling(sleep: 1, season_numbers: (75..))
    # Ppl::Updater.resume_crawling(sleep: 1, season_numbers: (75..))
    def resume_crawling(options = {})
      options = {
        :season_numbers => ((LeagueSeason.season_number_max || Spider::BASE_GENERATION)...),
      }.merge(options)

      options[:season_numbers].each do |season_number|
        update_from_web(season_number, options)
      end
    rescue OpenURI::HTTPError
    end

    # Ppl::Updater.update_from_web(59)
    def update_from_web(season_number, options = {})
      rows = Spider.new(options.merge(season_number: season_number)).call
      update_raw(season_number, rows)
    end

    def update_raw(season_number, rows)
      rows = Array.wrap(rows)
      if rows.present?
        league_season = LeagueSeason.find_or_create_by!(season_number: season_number)
        rows.each do |attrs|
          user = User.find_or_create_by!(name: attrs[:name])
          membership = user.memberships.find_or_initialize_by(league_season: league_season)
          membership.assign_attributes(attrs.slice(:result_key, :start_pos, :ox, :age, :win, :lose))
          user.save!
        end
      end
    end

    # Ppl::Updater.test(8, "alice", "昇段")
    def test(season_number, name, result_key)
      update_raw(season_number, { name: name, result_key: result_key })
    end
  end
end
