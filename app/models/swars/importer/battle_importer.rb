module Swars
  module Importer
    class BattleImporter < Base
      CREATE_TRY_COUNT = 3      # デッドロック対策でX回試みる (リトライ回数ではなく実行回数)
      private_constant :CREATE_TRY_COUNT

      attr_reader :battle

      def default_params
        {
          :verbose       => Rails.env.development?,
          :skip_if_exist => true,
        }
      end

      def call
        if params[:skip_if_exist]
          if props.battle_exist?
            return
          end
        end

        if props.invalid?
          return
        end

        user_create_or_update
        battle_create!
      end

      private

      def raw_props
        @raw_props ||= Agent::Record.new(params).fetch
      end

      def props
        @props ||= Agent::PropsAdapter.new(raw_props, key: key)
      end

      def key
        params.fetch(:key)
      end

      def user_create_or_update
        props.memberships.each do |e|
          grade = Grade.fetch(e[:grade_info].key)
          user = User.find_or_initialize_by(user_key: e[:user_key])
          user.high_grade_then_set(grade)
          user.save!
        end
      end

      def battle_create!
        @battle ||= Retryable.retryable(retryable_options) do
          Battle.create_or_find_by!(key: key) do |e|
            e.assign_attributes(props.to_battle_attributes)
            e.memberships.build(props.to_battle_membership_attributes)
          end
        end
      end

      def retryable_options
        {
          :on => ActiveRecord::Deadlocked,
          :tries => CREATE_TRY_COUNT, # 再実行回数ではなく実行回数
          :ensure => proc { |retries|
            if retries >= 1
              AppLog.info(emoji: ":救急:", subject: "実行回数計#{retries}回/最大#{CREATE_TRY_COUNT}", body: props.key.to_s)
            end
          },
          :exception_cb => proc { |exception|
            Rails.logger.debug { exception }
          },
          :log_method => lambda { |retries, exception|
            AppLog.debug(emoji: ":救急:", subject: "再実行 ##{retries}", body: props.key.to_s)
          },
        }
      end
    end
  end
end
