module Xclock
  extend self

  def table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  def setup(options = {})
    if options[:force]
      destroy_all
    end

    [
      Xclock::OxMark,
      Xclock::Season,
      Xclock::Lineage,
      Xclock::EmotionFolder,
      Xclock::Judge,
      Xclock::Rule,
      Xclock::Final,
      Xclock::Skill,
      Xclock::SourceAbout,
      Xclock::Question,
    ].each do |e|
      e.setup(options)
    end

    User.find_each(&:create_various_folders_if_blank)
    User.find_each(&:create_xclock_setting_if_blank)
    User.find_each(&:create_xclock_season_xrecord_if_blank)
    User.find_each(&:create_xclock_main_xrecord_if_blank)

    if Rails.env.development? || Rails.env.test?
      Xclock::BaseChannel.redis_clear
    end

    if Rails.env.staging? || Rails.env.production? || options[:import_all] || ENV["INSIDE_DB_SEEDS_TASK"]
      unless Xclock::Question.exists?
        Xclock::Question.import_all
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

  # rails r 'user = User.create!; tp Xclock.count_diff { user.destroy! }'
  # >> |------------------------+--------+-------+------|
  # >> | model                  | before | after | diff |
  # >> |------------------------+--------+-------+------|
  # >> | Xclock::Folder           |      6 |     3 |   -3 |
  # >> | Xclock::Question         |      1 |     0 |   -1 |
  # >> | Xclock::MovesAnswer      |      1 |     0 |   -1 |
  # >> | User                   |      2 |     1 |   -1 |
  # >> | Xclock::RoomMembership   |      2 |     1 |   -1 |
  # >> | Xclock::BattleMembership |      2 |     1 |   -1 |
  # >> | Xclock::SeasonXrecord    |      2 |     1 |   -1 |
  # >> | Xclock::MainXrecord      |      2 |     1 |   -1 |
  # >> | Xclock::Setting          |      2 |     1 |   -1 |
  # >> | Xclock::GoodMark         |      1 |     0 |   -1 |
  # >> | Xclock::BadMark          |      1 |     0 |   -1 |
  # >> | Xclock::ClipMark         |      1 |     0 |   -1 |
  # >> | Xclock::QuestionMessage  |      1 |     0 |   -1 |
  # >> | Xclock::Rule             |     12 |    12 |    0 |
  # >> | Xclock::Room             |      1 |     1 |    0 |
  # >> | Xclock::Skill            |     21 |    21 |    0 |
  # >> | Xclock::Battle           |      1 |     1 |    0 |
  # >> | Xclock::RoomMessage      |      0 |     0 |    0 |
  # >> | Xclock::Season           |      1 |     1 |    0 |
  # >> | Xclock::LobbyMessage     |      1 |     1 |    0 |
  # >> | Xclock::Judge            |      4 |     4 |    0 |
  # >> | Xclock::Lineage          |      8 |     8 |    0 |
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
