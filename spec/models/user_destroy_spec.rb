require 'rails_helper'

RSpec.describe User, type: :model do
  include ActbSupportMethods

  it "works" do
    user1.actb_lobby_messages.create!(body: "(body)")
    question = user1.actb_questions.create_mock1
    room = Actb::Room.create_with_members!([user1, user2])
    battle = room.battle_create_with_members!
    membership = battle.memberships.first
    membership.user.actb_histories.create!(membership: membership, question: question, ox_mark: Actb::OxMark.fetch(:correct))
    user1.actb_good_marks.create!(question: question)
    user1.actb_bad_marks.create!(question: question)
    user1.actb_clip_marks.create!(question: question)
    question.messages.create!(user: user1, body: "(body)")

    # tp Actb.count_diff { user1.destroy! }

    assert { Actb.count_diff { user1.destroy! }.to_t == <<~EOT }
|------------------------+--------+-------+------|
| model                  | before | after | diff |
|------------------------+--------+-------+------|
| Actb::Folder           |      9 |     6 |   -3 |
| Actb::Question         |      1 |     0 |   -1 |
| Actb::MovesAnswer      |      1 |     0 |   -1 |
| User                   |      3 |     2 |   -1 |
| Actb::SeasonXrecord    |      3 |     2 |   -1 |
| Actb::MainXrecord      |      3 |     2 |   -1 |
| Actb::Setting          |      3 |     2 |   -1 |
| Actb::GoodMark         |      1 |     0 |   -1 |
| Actb::BadMark          |      1 |     0 |   -1 |
| Actb::ClipMark         |      1 |     0 |   -1 |
| Actb::QuestionMessage  |      1 |     0 |   -1 |
| Actb::LobbyMessage     |      2 |     1 |   -1 |
| Actb::RoomMembership   |      2 |     1 |   -1 |
| Actb::BattleMembership |      2 |     1 |   -1 |
| Actb::RoomMessage      |      0 |     0 |    0 |
| Actb::Room             |      1 |     1 |    0 |
| Actb::Judge            |      4 |     4 |    0 |
| Actb::Battle           |      1 |     1 |    0 |
| Actb::Rule             |     13 |    13 |    0 |
| Actb::Season           |      1 |     1 |    0 |
| Actb::Skill            |     21 |    21 |    0 |
| Actb::Lineage          |      8 |     8 |    0 |
|------------------------+--------+-------+------|
EOT
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> |------------------------+--------+-------+------|
# >> | model                  | before | after | diff |
# >> |------------------------+--------+-------+------|
# >> | Actb::Folder           |      9 |     6 |   -3 |
# >> | Actb::Question         |      1 |     0 |   -1 |
# >> | Actb::MovesAnswer      |      1 |     0 |   -1 |
# >> | User                   |      3 |     2 |   -1 |
# >> | Actb::SeasonXrecord    |      3 |     2 |   -1 |
# >> | Actb::MainXrecord      |      3 |     2 |   -1 |
# >> | Actb::Setting          |      3 |     2 |   -1 |
# >> | Actb::GoodMark         |      1 |     0 |   -1 |
# >> | Actb::BadMark          |      1 |     0 |   -1 |
# >> | Actb::ClipMark         |      1 |     0 |   -1 |
# >> | Actb::QuestionMessage  |      1 |     0 |   -1 |
# >> | Actb::LobbyMessage     |      2 |     1 |   -1 |
# >> | Actb::RoomMembership   |      2 |     1 |   -1 |
# >> | Actb::BattleMembership |      2 |     1 |   -1 |
# >> | Actb::RoomMessage      |      0 |     0 |    0 |
# >> | Actb::Room             |      1 |     1 |    0 |
# >> | Actb::Judge            |      4 |     4 |    0 |
# >> | Actb::Battle           |      1 |     1 |    0 |
# >> | Actb::Rule             |     13 |    13 |    0 |
# >> | Actb::Season           |      1 |     1 |    0 |
# >> | Actb::Skill            |     21 |    21 |    0 |
# >> | Actb::Lineage          |      8 |     8 |    0 |
# >> |------------------------+--------+-------+------|
# >> F
# >> 
# >> Failures:
# >> 
# >>   1) User works
# >>      Failure/Error: Unable to find - to read failed line
# >>      # -:20:in `block (2 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:18:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:18:in `block (2 levels) in <main>'
# >> 
# >> Finished in 1.74 seconds (files took 2.33 seconds to load)
# >> 1 example, 1 failure
# >> 
# >> Failed examples:
# >> 
# >> rspec -:6 # User works
# >> 
