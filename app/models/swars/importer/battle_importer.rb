module Swars
  module Importer
    class BattleImporter
      CREATE_TRY_COUNT = 3      # デッドロック対策でN回試みる (リトライ回数ではなく実行回数)
      private_constant :CREATE_TRY_COUNT

      attr_accessor :params
      attr_accessor :battles

      def initialize(params = {})
        @params = {
          :verbose       => Rails.env.development?,
          :skip_if_exist => true,
        }.merge(params)

        @battles = []           # FIXME: なんで配列？
      end

      def call
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

        # 保存
        Retryable.retryable(retryable_options) do
          battle_create!
        end
      end

      private

      def key
        params.fetch(:key)
      end

      def user_create_or_update(e)
        grade = Grade.fetch(e[:grade_info].key)
        user = User.find_or_initialize_by(user_key: e[:user_key])
        user.high_grade_then_set(grade)
        user.save!
      end

      def battle_create!
        # raise ActiveRecord::Deadlocked, @info.key.to_s

        @battles << Battle.create!({
            :key        => @info.key.to_s,
            :rule_key   => @info.rule_info.key,
            :final_key  => @info.final_info.key,
            :csa_seq    => @info.csa_seq, # FIXME: SFEN を渡す。時間は別にする
            :preset_key => @info.preset_info.key,
            :xmode_key  => @info.xmode_info.key,
            :imode_key => @info.imode_info.key,
            :battled_at => @info.battled_at,
            :starting_position => @info.starting_position,
          }) do |battle|
          # なかに入れれば Battle.create! の transaction のなかに入る
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

      def retryable_options
        {
          :on => ActiveRecord::Deadlocked,
          :tries => CREATE_TRY_COUNT, # 再実行回数ではなく実行回数
          :ensure => proc { |retries|
            if retries >= 1
              AppLog.info(emoji: ":救急:", subject: "実行回数計#{retries}回/最大#{CREATE_TRY_COUNT}", body: @info.key.to_s)
            end
          },
          :exception_cb => proc { |exception|
            Rails.logger.debug { exception }
          },
          :log_method => lambda { |retries, exception|
            AppLog.debug(emoji: ":救急:", subject: "再実行 ##{retries}", body: @info.key.to_s)
          },
        }
      end
    end
  end
end
