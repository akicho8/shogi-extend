module Ppl
  SeasonKeyVo = Data.define(:key) do
    class << self
      def [](key)
        if key.kind_of? self
          return key
        end
        new(key)
      end

      def start
        self[AntiquitySpider.accept_range.min]
      end
    end

    def initialize(...)
      @cache = {}

      super

      if key.kind_of? Integer
        raise TypeError, key.inspect
      end

      unless spider_class
        raise SpiderKlassNotFound, key.inspect
      end
    end

    def season
      Season.find_or_create_by!(key: key)
    end

    def to_i
      key[/\d+/].to_i
    end

    def to_zero_padding_s
      "%02d" % to_i
    end

    def to_s
      key
    end

    def inspect
      to_s
    end

    def succ
      if key == AntiquitySpider.accept_range.max
        v = MedievalSpider.accept_range.min
      else
        v = key.succ
      end
      self.class.new(v)
    end

    def spider_class
      @cache[:spider_class] ||= spider_class_list.find { |e| e.accept_range.include?(key) }
    end

    def spider(options = {})
      spider_class.new(options.merge(season_key_vo: self))
    end

    def records(...)
      spider(...).records
    end

    def url(...)
      spider(...).source_url
    end

    def import_to_db(...)
      Updater.update_by_records(self, records(...))
    end

    def update_by_records(records = [])
      season = Season.find_or_create_by!(key: key)
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

    private

    # 順不同
    def spider_class_list
      [
        AntiquitySpider,
        MedievalSpider,
        ModernitySpider,
      ]
    end
  end
end
