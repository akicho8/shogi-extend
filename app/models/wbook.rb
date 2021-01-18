module Wbook
  extend self

  def table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  def setup(options = {})
    if options[:force]
      destroy_all
    end

    [
      Wbook::OxMark,
      Wbook::Season,
      Wbook::Lineage,
      Wbook::EmotionFolder,
      Wbook::Judge,
      Wbook::Rule,
      Wbook::Final,
      Wbook::Skill,
      Wbook::SourceAbout,
      Wbook::Question,
    ].each do |e|
      e.setup(options)
    end

    User.find_each(&:create_various_folders_if_blank)
    User.find_each(&:create_wbook_setting_if_blank)
    User.find_each(&:create_wbook_season_xrecord_if_blank)
    User.find_each(&:create_wbook_main_xrecord_if_blank)

    if Rails.env.development? || Rails.env.test?
      Wbook::BaseChannel.redis_clear
    end

    if Rails.env.staging? || Rails.env.production? || options[:import_all] || ENV["INSIDE_DB_SEEDS_TASK"]
      unless Wbook::Question.exists?
        Wbook::Question.import_all
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

  # rails r 'user = User.create!; tp Wbook.count_diff { user.destroy! }'
  # >> |------------------------+--------+-------+------|
  # >> | model                  | before | after | diff |
  # >> |------------------------+--------+-------+------|
  # >> | Wbook::Folder           |      6 |     3 |   -3 |
  # >> | Wbook::Question         |      1 |     0 |   -1 |
  # >> | Wbook::MovesAnswer      |      1 |     0 |   -1 |
  # >> | User                   |      2 |     1 |   -1 |
  # >> | Wbook::RoomMembership   |      2 |     1 |   -1 |
  # >> | Wbook::BattleMembership |      2 |     1 |   -1 |
  # >> | Wbook::SeasonXrecord    |      2 |     1 |   -1 |
  # >> | Wbook::MainXrecord      |      2 |     1 |   -1 |
  # >> | Wbook::Setting          |      2 |     1 |   -1 |
  # >> | Wbook::GoodMark         |      1 |     0 |   -1 |
  # >> | Wbook::BadMark          |      1 |     0 |   -1 |
  # >> | Wbook::ClipMark         |      1 |     0 |   -1 |
  # >> | Wbook::QuestionMessage  |      1 |     0 |   -1 |
  # >> | Wbook::Rule             |     12 |    12 |    0 |
  # >> | Wbook::Room             |      1 |     1 |    0 |
  # >> | Wbook::Skill            |     21 |    21 |    0 |
  # >> | Wbook::Battle           |      1 |     1 |    0 |
  # >> | Wbook::RoomMessage      |      0 |     0 |    0 |
  # >> | Wbook::Season           |      1 |     1 |    0 |
  # >> | Wbook::LobbyMessage     |      1 |     1 |    0 |
  # >> | Wbook::Judge            |      4 |     4 |    0 |
  # >> | Wbook::Lineage          |      8 |     8 |    0 |
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
