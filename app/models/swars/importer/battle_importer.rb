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
          if Battle.exists?(key: key.to_s)
            return
          end
        end

        # 本家から取得する
        props = Agent::Record.new(params).fetch

        # 扱いやすい形で取れるようにする
        @info = Agent::PropsAdapter.new(props, key: key)

        # 無効な対局データは取り込まない
        if @info.invalid?
          return
        end

        # 対局者の作成・更新
        @info.memberships.each { |e| user_create_or_update(e) }

        # 対局レコードの作成
        battle_create
      end

      private

      def key
        params[:key]
      end

      def user_create_or_update(e)
        grade = Grade.fetch(e[:grade_info].key)
        user = User.find_or_initialize_by(user_key: e[:user_key])
        user.grade_update_if_new(grade)
      end

      def battle_create
        Battle.create!({
            :key        => @info.key.to_s,
            :rule_key   => @info.rule_info.key,
            :csa_seq    => @info.csa_seq, # FIXME: SFEN を渡す。時間は別にする
            :preset_key => @info.preset_info.key,
            :xmode_key  => @info.xmode_info.key,
            :battled_at => @info.battled_at,
          }) do |battle|
          @info.memberships.each.with_index do |e, i|
            battle.memberships.build({
                :user         => User.find_by!(user_key: e[:user_key]),
                :grade_key    => e[:grade_info].key,
                :judge_key    => e[:judge_info].key,
                :location_key => LocationInfo.fetch(i).key,
              })
          end
        end
      end
    end
  end
end
