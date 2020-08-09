module Actb
  extend self

  def table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  def setup(options = {})
    if options[:force]
      destroy_all
    end

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

    if Rails.env.staging? || Rails.env.production? || options[:import_all] || ENV["INSIDE_DB_SEEDS_TASK"]
      unless Actb::Question.exists?
        Actb::Question.import_all
      end
    end
  end

  def models
    [
      Question,
      MovesAnswer,
      Folder,
      Lineage,
      Room,
      RoomMembership,
      Battle,
      BattleMembership,
      Season,
      SeasonXrecord,
      MainXrecord,
      Setting,
      GoodMark,
      BadMark,
      ClipMark,
      Judge,
      Rule,
      Skill,
      QuestionMessage,
      LobbyMessage,
      RoomMessage,
    ]
  end

  def destroy_all
    models.each do |e|
      e.destroy_all
    end
  end

  def info
    [User, *models].collect { |e|
      { model: e.name, count: e.count, "最終ID" => e.order(:id).last&.id }
    }
  end

  # rails r 'user = User.create!; tp Actb.count_diff { user.destroy! }'
  # >> |------------------------+--------+-------+------|
  # >> | model                  | before | after | diff |
  # >> |------------------------+--------+-------+------|
  # >> | Actb::Folder           |      6 |     3 |   -3 |
  # >> | Actb::Question         |      1 |     0 |   -1 |
  # >> | Actb::MovesAnswer      |      1 |     0 |   -1 |
  # >> | User                   |      2 |     1 |   -1 |
  # >> | Actb::RoomMembership   |      2 |     1 |   -1 |
  # >> | Actb::BattleMembership |      2 |     1 |   -1 |
  # >> | Actb::SeasonXrecord    |      2 |     1 |   -1 |
  # >> | Actb::MainXrecord      |      2 |     1 |   -1 |
  # >> | Actb::Setting          |      2 |     1 |   -1 |
  # >> | Actb::GoodMark         |      1 |     0 |   -1 |
  # >> | Actb::BadMark          |      1 |     0 |   -1 |
  # >> | Actb::ClipMark         |      1 |     0 |   -1 |
  # >> | Actb::QuestionMessage  |      1 |     0 |   -1 |
  # >> | Actb::Rule             |     12 |    12 |    0 |
  # >> | Actb::Room             |      1 |     1 |    0 |
  # >> | Actb::Skill            |     21 |    21 |    0 |
  # >> | Actb::Battle           |      1 |     1 |    0 |
  # >> | Actb::RoomMessage      |      0 |     0 |    0 |
  # >> | Actb::Season           |      1 |     1 |    0 |
  # >> | Actb::LobbyMessage     |      1 |     1 |    0 |
  # >> | Actb::Judge            |      4 |     4 |    0 |
  # >> | Actb::Lineage          |      8 |     8 |    0 |
  # >> |------------------------+--------+-------+------|
  def count_diff(options = {})
    list = [User, *models]
    before = Vector[*list.collect(&:count)]
    yield
    after = Vector[*list.collect(&:count)]
    diff = after - before

    records = list.collect.with_index do |model, i|
      {
        model: model.name,
        before: before[i],
        after: after[i],
        diff: diff[i],
      }
    end

    if options[:change_only]
      records = records.reject { |e| e[:diff].zero? }
    end

    records.sort_by { |e| e[:diff] }
  end
end
