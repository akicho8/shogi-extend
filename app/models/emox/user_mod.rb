module Emox
  module UserMod
    extend ActiveSupport::Concern

    included do
      # 対局
      has_many :emox_room_memberships, class_name: "Emox::RoomMembership", dependent: :destroy         # 対局時の情報(複数)
      has_many :emox_rooms,            class_name: "Emox::Room", through: :emox_room_memberships       # 対局(複数)

                                                                                                       # 対局
      has_many :emox_battle_memberships, class_name: "Emox::BattleMembership", dependent: :destroy     # 対局時の情報(複数)
      has_many :emox_battles,            class_name: "Emox::Battle", through: :emox_battle_memberships # 対局(複数)
    end

    concerning :CurrentUserMethods do
      attr_accessor :session_lock_token

      def session_lock_token_valid?(token)
        emox_setting.reload.session_lock_token == token
      end

      # for current_user, profile
      def as_json_type9x
        # 二つのブラウザで同期してしまう不具合回避のための値
        # 新しく開いた瞬間にトークンが変化するので古い方には送られなくなる(受信しても無視するしかなくなる)
        # ↑これはまずい、2連続アクセス(はてブ？などが後からGET)した場合に START できなくなる
        @session_lock_token = SecureRandom.hex
        as_json_type9
      end

      # rails r "tp User.first.emotions.destroy_all"
      # rails r "tp User.first.as_json_type9"
      # rails r "tp Emox::EmotionInfo.as_json"
      def as_json_type9
        as_json({
            only: [
              :id,
              :key,
            ],
            methods: [
              :session_lock_token,
            ],
          })
      end
    end

    concerning :SettingMod do
      included do
        has_one :emox_setting, class_name: "Emox::Setting", dependent: :destroy

        after_create do
          create_emox_setting!
        end
      end

      def create_emox_setting_if_blank
        emox_setting || create_emox_setting!
      end
    end

    concerning :UserInfoMethods do
      # rails r "tp User.first.info"
      def emox_info
        {
          "ID"             => id,
          "オンライン"     => Emox::SchoolChannel.active_users.include?(self) ? "○" : "",
          "対戦中"         => Emox::RoomChannel.active_users.include?(self) ? "○" : "",
          "最終選択ルール" => emox_setting.rule.pure_info.name,
        }
      end
    end
  end
end
