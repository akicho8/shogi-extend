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
      # Static
      Sequence,
      Folder,
      Lineage,
      # ActiveRecord
      Book,
      Article,
    ].each do |e|
      e.setup(options)
    end

    if Rails.env.staging? || Rails.env.production? || options[:import_all] || ENV["INSIDE_DB_SEEDS_TASK"]
      unless Article.exists?
        Article.import_all
      end
    end
  end

  def models
    [
      Folder,
      Lineage,
      Book,
      Article,
      MovesAnswer,
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
  # >> | Folder           |      6 |     3 |   -3 |
  # >> | Article         |      1 |     0 |   -1 |
  # >> | MovesAnswer      |      1 |     0 |   -1 |
  # >> | User                   |      2 |     1 |   -1 |
  # >> | RoomMembership   |      2 |     1 |   -1 |
  # >> | BattleMembership |      2 |     1 |   -1 |
  # >> | SeasonXrecord    |      2 |     1 |   -1 |
  # >> | MainXrecord      |      2 |     1 |   -1 |
  # >> | Setting          |      2 |     1 |   -1 |
  # >> | GoodMark         |      1 |     0 |   -1 |
  # >> | BadMark          |      1 |     0 |   -1 |
  # >> | ClipMark         |      1 |     0 |   -1 |
  # >> | ArticleMessage  |      1 |     0 |   -1 |
  # >> | Rule             |     12 |    12 |    0 |
  # >> | Room             |      1 |     1 |    0 |
  # >> | Skill            |     21 |    21 |    0 |
  # >> | Battle           |      1 |     1 |    0 |
  # >> | RoomMessage      |      0 |     0 |    0 |
  # >> | Season           |      1 |     1 |    0 |
  # >> | LobbyMessage     |      1 |     1 |    0 |
  # >> | Judge            |      4 |     4 |    0 |
  # >> | Lineage          |      8 |     8 |    0 |
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
