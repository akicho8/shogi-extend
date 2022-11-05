module Swars
  module Importer
    class BattleImporter
      attr_accessor :params

      def initialize(params = {})
        @params = {
          :verbose       => Rails.env.development?,
          :skip_if_exist => true,
        }.merge(params)
      end

      def run
        # すでに登録済みなら何もしない
        if params[:skip_if_exist]
          if Battle.exists?(key: params[:key])
            return
          end
        end

        props = Agent::Record.new(params).fetch
        info = Agent::RecordAdapter.new(props)
        if info.invalid?
          return
        end

        info.memberships.each do |e|
          User.find_or_initialize_by(user_key: e[:user_key]).tap do |user|
            # FIXME: 取って↑を find_or_create にする
            if true
              grade = Grade.fetch(e[:grade_info].key)
              user.grade = grade # 常にランクを更新する
              begin
                user.save!
              rescue ActiveRecord::RecordNotUnique
              end
            end
          end
        end

        battle = Battle.new({
            :key        => params[:key], # info.key だとmock版の中の固定のkeyになってしまうため
            :rule_key   => info.rule_info.key,
            :csa_seq    => info.csa_seq, # FIXME: 完全なCSAを渡すか？ 時間は別にして渡すか？
            :preset_key => info.preset_info.key,
            :xmode_key  => info.xmode_info.key,
            :battled_at => info.battled_at,
          }) do |battle|
          info.memberships.each.with_index do |e, i|
            battle.memberships.build({
                :user         => User.find_by!(user_key: e[:user_key]),
                :grade_key    => e[:grade_info].key,
                :judge_key    => e[:judge_info].key,
                :location_key => LocationInfo.fetch(i).key,
              })
          end
        end

        begin
          battle.save!
        rescue ActiveRecord::RecordNotUnique, ActiveRecord::Deadlocked => error # RecordNotUnique は DB の unique index 違反
          Rails.logger.info { error.inspect }
          false
        end
      end
    end
  end
end
