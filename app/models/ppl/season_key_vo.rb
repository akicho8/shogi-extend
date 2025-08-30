module Ppl
  SeasonKeyVo = Data.define(:key) do
    class << self
      def start
        self[OrderInfo.first.name]
      end
    end

    def initialize(...)
      @cache = {}
      super
    end

    ################################################################################ (a..b)

    include Comparable

    def <=>(other)
      position <=> other.position
    end

    def position
      @cache[:position] ||= order_info&.code || OrderInfo.values.size + to_i.pred
    end

    def succ
      if order_info
        if info = OrderInfo[order_info.code.next]
          str = info.name
        else
          str = "1"
        end
      else
        str = to_i.next.to_s
      end
      self.class.new(str)
    end

    ################################################################################ アクセサ

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

    def order_info
      OrderInfo[key]
    end

    ################################################################################ クローラ

    def spider_class
      spider_type_info.klass
    end

    def spider_type_info
      @cache[:spider_type_info] ||= SpiderTypeInfo.find { |e| e.klass.accept_range?(key) }
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
        membership.update!(record.slice(:result_key, :age, :win, :lose, :ox, :ranking_pos))
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
