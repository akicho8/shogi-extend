module Tsl
  module Updater
    extend self

    # Tsl::Updater.update
    def update(options = {})
      options = {
        generations: default_generations,
      }.merge(options)

      options.fetch(:generations).each do |generation|
        update_from_web(generation, options)
      end
    end

    # Tsl::Updater.update_for_local
    def update_for_local(options = {})
      options = {
        generations: default_generations,
      }.merge(options)

      options.fetch(:generations).each do |generation|
        update_from_web(generation, options)
      end
    end

    # Tsl::Updater.update_from_web(30)
    def update_from_web(generation, options = {})
      options = {
        :generation => generation,
        :verbose => Rails.env.development? || Rails.env.staging? || Rails.env.production?,
      }.merge(options)

      rows = Spider.new(options).call
      update_raw(generation, rows)
    end

    def update_raw(generation, rows)
      rows = Array.wrap(rows)
      if rows.present?
        league = League.find_or_create_by!(generation: generation) # 1件でも記録があればその世代が存在するとする
        rows.each do |attrs|
          user = User.find_or_create_by!(name: attrs[:name])
          membership = user.memberships.find_or_initialize_by(league: league)
          membership.assign_attributes(attrs.slice(:result_key, :start_pos, :ox, :age, :win, :lose))
          user.save!
        end
      end
    end

    # shortcut for update_raw
    # Tsl::Updater.test(8, "alice", "昇段")
    def test(generation, name, result_key)
      update_raw(generation, { name: name, result_key: result_key })
    end

    private

    def default_generations
      if Rails.env.production? || Rails.env.staging?
        [*28..100]
      elsif Rails.env.test?
        [66]
      else
        [28, 66, 67, 68]
      end
    end
  end
end
