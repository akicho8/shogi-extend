module Actb
  extend self

  def table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  def setup(options = {})
    Actb::OxMark.setup(options)
    Actb::Season.setup(options)
    Actb::Lineage.setup(options)
    Actb::Judge.setup(options)
    Actb::Rule.setup(options)
    Actb::Final.setup(options)
    Actb::Skill.setup(options)
    Actb::SourceAbout.setup(options)
    Actb::Question.setup(options)

    User.find_each(&:create_various_folders_if_blank)
    User.find_each(&:create_actb_setting_if_blank)
    User.find_each(&:create_actb_season_xrecord_if_blank)
    User.find_each(&:create_actb_main_xrecord_if_blank)

    if Rails.env.development? || Rails.env.test?
      Actb::BaseChannel.redis_clear
    end

    if Rails.env.staging? || Rails.env.production? || Rails.env.development?
      unless Actb::Question.exists?
        Actb::Question.import_all
      end
    end
  end

  def models
    [
      Question, QuestionMessage,
      Room, RoomMembership, RoomMessage,
      Battle, BattleMembership,
      Season,
      SeasonXrecord,
      MainXrecord,
      Setting,
      GoodMark, BadMark, ClipMark,
      Folder,
      Lineage, Judge, Rule, Skill,
      LobbyMessage,
    ]
  end

  def destroy_all
    models.each do |e|
      e.destroy_all
      # e.delete_all
    end
  end

  def info
    [User, *models].collect { |e|
      { model: e, count: e.count, "最終ID" => e.order(:id).last&.id }
    }
  end
end
