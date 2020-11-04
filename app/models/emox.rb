module Emox
  extend self

  def table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  def setup(options = {})
    if options[:force]
      destroy_all
    end

    [
      Emox::Judge,
      Emox::Rule,
      Emox::Final,
    ].each do |e|
      e.setup(options)
    end

    User.find_each(&:create_emox_setting_if_blank)

    if Rails.env.development? || Rails.env.test?
      Emox::BaseChannel.redis_clear
    end
  end

  def models
    [
      Room,
      RoomMembership,
      Battle,
      BattleMembership,
      Setting,
      Judge,
      Rule,
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

  # rails r 'user = User.create!; tp Emox.count_diff { user.destroy! }'
  # >> |------------------------+--------+-------+------|
  # >> | model                  | before | after | diff |
  # >> |------------------------+--------+-------+------|
  # >> | Emox::Folder           |      6 |     3 |   -3 |
  # >> | Emox::Question         |      1 |     0 |   -1 |
  # >> | Emox::MovesAnswer      |      1 |     0 |   -1 |
  # >> | User                   |      2 |     1 |   -1 |
  # >> | Emox::RoomMembership   |      2 |     1 |   -1 |
  # >> | Emox::BattleMembership |      2 |     1 |   -1 |
  # >> | Emox::SeasonXrecord    |      2 |     1 |   -1 |
  # >> | Emox::MainXrecord      |      2 |     1 |   -1 |
  # >> | Emox::Setting          |      2 |     1 |   -1 |
  # >> | Emox::GoodMark         |      1 |     0 |   -1 |
  # >> | Emox::BadMark          |      1 |     0 |   -1 |
  # >> | Emox::ClipMark         |      1 |     0 |   -1 |
  # >> | Emox::QuestionMessage  |      1 |     0 |   -1 |
  # >> | Emox::Rule             |     12 |    12 |    0 |
  # >> | Emox::Room             |      1 |     1 |    0 |
  # >> | Emox::Skill            |     21 |    21 |    0 |
  # >> | Emox::Battle           |      1 |     1 |    0 |
  # >> | Emox::RoomMessage      |      0 |     0 |    0 |
  # >> | Emox::Season           |      1 |     1 |    0 |
  # >> | Emox::LobbyMessage     |      1 |     1 |    0 |
  # >> | Emox::Judge            |      4 |     4 |    0 |
  # >> | Emox::Lineage          |      8 |     8 |    0 |
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
