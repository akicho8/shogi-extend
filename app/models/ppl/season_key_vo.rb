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

      def all
        av = []
        e = start
        while e.valid?
          av << e
          e = e.succ
        end
        av
      end
    end

    include Comparable

    def initialize(...)
      @cache = {}
      super
    end

    def <=>(other)
      [spider_type_info.code, to_i] <=> [other.spider_type_info.code, other.to_i]
    end

    ################################################################################ アクセサ

    # def priority
    #   SpiderTypeInfo.priority_map.fetch(key)
    # end

    def to_i
      @cache[:to_i] ||= key[/\d+/].to_i
    end

    def to_zero_padding_s
      "%02d" % to_i
    end

    def name
      key
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

    ################################################################################ クローラ

    def valid?
      spider_type_info
    end

    def invalid?
      !valid?
    end

    def spider_class
      spider_type_info.klass
    end

    def spider_type_info
      @cache[:spider_type_info] ||= SpiderTypeInfo.find { |e| e.klass.accept_range.include?(key) }
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

    ################################################################################ DB更新

    def season
      find_or_create
    end

    def find_or_create
      @cache[:find_or_create] ||= Season.find_or_create_by!(key: self)
    end

    def users_update_from_web(...)
      users_update(records(...))
    end

    def users_update(records = [])
      season = find_or_create
      Array.wrap(records).each do |record|
        user = User.find_or_create_by!(name: record[:name] || "(name#{User.count.next})")
        if v = record[:mentor].presence
          mentor = Mentor.find_or_create_by!(name: v)
          mentor_change_log(user:, mentor:)
          user.update!(mentor: mentor)
        end
        membership = user.memberships.find_or_initialize_by(season: season)
        membership.update!(record.slice(:result_key, :age, :win, :lose, :ox))
      end
      User.find_each(&:update_deactivated_season)
    end

    def test(name, result_key)
      users_update({ name: name, result_key: result_key })
    end

    ################################################################################

    private

    def mentor_change_log(user:, mentor:)
      if user.mentor && user.mentor.name != mentor.name
        tp({ "対象" => user.name, "前師匠" => user.mentor.name, "新師匠" => mentor.name })
      end
    end
  end
end
