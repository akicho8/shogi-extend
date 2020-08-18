module UserMuteMod
  extend ActiveSupport::Concern

  # rails r "User.sysop.mute_infos.create!(target_user: User.bot); tp MuteInfo; tp User.sysop.mute_users"
  # rails r "User.sysop.mute_users << User.bot; tp MuteInfo; tp User.sysop.mute_users; tp User.sysop.mute_user_ids"
  # rails r "User.sysop.mute_users.destroy(User.bot); tp MuteInfo"
  included do
    has_many :mute_infos, dependent: :destroy # 自分がミュートした人たち(中間情報)
    has_many :reverse_mute_infos, class_name: "MuteInfo", foreign_key: :target_user_id, dependent: :destroy # 自分をミュートした人たち(中間情報)。定義しているのは外部キー制約があってもユーザー削除できるようにするためでもある
    has_many :mute_users, through: :mute_infos, source: :target_user  # 自分がミュートした人たち
    has_many :reverse_mute_users, through: :mute_infos, source: :user # 自分をミュートした人たち
  end
end
