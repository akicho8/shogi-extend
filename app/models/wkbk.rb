module Wkbk
  extend self

  def table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  def setup(options = {})
    if options[:force]
      destroy_all
    end

    [
      Wkbk::SourceAbout,
      Wkbk::Question,
    ].each do |e|
      e.setup(options)
    end

    User.find_each(&:wkbk_create_various_folders_if_blank)

    if Rails.env.staging? || Rails.env.production? || options[:import_all] || ENV["INSIDE_DB_SEEDS_TASK"]
      unless Wkbk::Question.exists?
        Wkbk::Question.import_all
      end
    end
  end

  def models
    [
      Question,
      MovesAnswer,
      Folder,
      Lineage,
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

  # rails r 'user = User.create!; tp Wkbk.count_diff { user.destroy! }'
  # >> |------------------------+--------+-------+------|
  # >> | model                  | before | after | diff |
  # >> |------------------------+--------+-------+------|
  # >> | Wkbk::Folder           |      6 |     3 |   -3 |
  # >> | Wkbk::Question         |      1 |     0 |   -1 |
  # >> | Wkbk::MovesAnswer      |      1 |     0 |   -1 |
  # >> | User                   |      2 |     1 |   -1 |
  # >> | Wkbk::RoomMembership   |      2 |     1 |   -1 |
  # >> | Wkbk::BattleMembership |      2 |     1 |   -1 |
  # >> | Wkbk::SeasonXrecord    |      2 |     1 |   -1 |
  # >> | Wkbk::MainXrecord      |      2 |     1 |   -1 |
  # >> | Wkbk::Setting          |      2 |     1 |   -1 |
  # >> | Wkbk::GoodMark         |      1 |     0 |   -1 |
  # >> | Wkbk::BadMark          |      1 |     0 |   -1 |
  # >> | Wkbk::ClipMark         |      1 |     0 |   -1 |
  # >> | Wkbk::QuestionMessage  |      1 |     0 |   -1 |
  # >> | Wkbk::Rule             |     12 |    12 |    0 |
  # >> | Wkbk::Room             |      1 |     1 |    0 |
  # >> | Wkbk::Skill            |     21 |    21 |    0 |
  # >> | Wkbk::Battle           |      1 |     1 |    0 |
  # >> | Wkbk::RoomMessage      |      0 |     0 |    0 |
  # >> | Wkbk::Season           |      1 |     1 |    0 |
  # >> | Wkbk::LobbyMessage     |      1 |     1 |    0 |
  # >> | Wkbk::Judge            |      4 |     4 |    0 |
  # >> | Wkbk::Lineage          |      8 |     8 |    0 |
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
