# |----------------------+-----------------------------------------------------|
# | 本番用セットアップ   | Ppl::Updater.resume_crawling                        |
# | ローカルで全読み込み | Ppl::Updater.resume_crawling                        |
# | 範囲 N 以降          | Ppl::Updater.resume_crawling(generations: (75..))   |
# | 範囲 A と B          | Ppl::Updater.resume_crawling(generations: [59, 77]) |
# |----------------------+-----------------------------------------------------|

module Ppl
  module Updater
    extend self

    # Ppl::Updater.resume_crawling
    # Ppl::Updater.resume_crawling(sleep: 1, generations: (75..))
    # Ppl::Updater.resume_crawling(sleep: 1, generations: (75..))
    def resume_crawling(options = {})
      options = {
        :generations => ((League.max_generation || Spider::BASE_GENERATION)...),
      }.merge(options)

      options[:generations].each do |generation|
        update_from_web(generation, options)
      end
    rescue OpenURI::HTTPError
    end

    # Ppl::Updater.update_from_web(59)
    def update_from_web(generation, options = {})
      rows = Spider.new(options.merge(generation: generation)).call
      update_raw(generation, rows)
    end

    def update_raw(generation, rows)
      rows = Array.wrap(rows)
      if rows.present?
        league = League.find_or_create_by!(generation: generation)
        rows.each do |attrs|
          user = User.find_or_create_by!(name: attrs[:name])
          membership = user.memberships.find_or_initialize_by(league: league)
          membership.assign_attributes(attrs.slice(:result_key, :start_pos, :ox, :age, :win, :lose))
          user.save!
        end
      end
    end

    # Ppl::Updater.test(8, "alice", "昇段")
    def test(generation, name, result_key)
      update_raw(generation, { name: name, result_key: result_key })
    end
  end
end
