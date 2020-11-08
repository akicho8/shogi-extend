module BackendScript
  class EmoxKpiScript < ::BackendScript::Base
    include SortMod

    self.category = "emox"
    self.script_name = "エモ将棋 KPI"

    def script_body
      # 日別のユニーク対戦者数を求める
      user_hash = {}
      if true
        model = User
        s = model.all
        s = s.where(model.arel_table[:created_at].gteq(time_begin))
        records = s.select([
            "DATE(#{DbCop.tz_adjust(:created_at)}) AS created_on",           # 時間→日付変換
            "COUNT(*)                              AS count_all",            # 登録者数
          ].join(", ")).group(:created_on)                                   # 日付毎
        # 日付から一発で対応するレコードを求められるようにハッシュ化
        user_hash = records.inject({}) { |a, e| a.merge(e[:created_on] => e) }
      end

      # 日別の対戦回数を求める (対人と練習でそれぞれの分ける)
      room_hash = {}
      if true
        model = Emox::Room
        s = model.all
        s = s.where(model.arel_table[:created_at].gteq(time_begin))
        records = s.select([
            "DATE(#{DbCop.tz_adjust(:created_at)}) AS created_on",          # 時間→日付変換
            "COUNT(*)                              AS human_battle_count", # 対人戦の数
          ].join(", ")).group("created_on")                                 # 日付毎
        # 日付から一発で対応するレコードを求められるようにハッシュ化
        room_hash = records.inject({}) { |a, e| a.merge(e[:created_on] => e) }
      end

      # 日別のユニーク対戦者数を求める
      member_hash = {}
      if true
        model = Emox::RoomMembership
        s = model.all
        s = s.where(model.arel_table[:created_at].gteq(time_begin))
        records = s.select([
            "DATE(#{DbCop.tz_adjust(:created_at)}) AS created_on",           # 時間→日付変換
            "COUNT(distinct user_id)               AS unique_user_id_count", # ユニーク対戦者数
          ].join(", ")).group(:created_on)                                   # 日付毎
        # 日付から一発で対応するレコードを求められるようにハッシュ化
        member_hash = records.inject({}) { |a, e| a.merge(e[:created_on] => e) }
      end

      now = Time.current.to_date
      current_length.times.collect do |i|
        date = now - i
        row = {}
        row["日付"]        = h.tag.span(date.to_time.to_s(:ymd_j), :class => holiday_sunday_saturday_class(date))
        row["流入"]        = user_hash[date]&.count_all
        row["対人戦回数"]  = room_hash[date]&.human_battle_count
        row["対戦DAU"]     = member_hash[date]&.unique_user_id_count
        row
      end
    end

    def time_begin
      current_length.days.ago.midnight
    end

    def current_length
      (params[:length].presence || 30).to_i
    end
  end
end
