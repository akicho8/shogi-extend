require "./setup"
Actb.setup(force: true)

user1 = User.create!
user2 = User.create!
question1 = user1.actb_questions.create_mock1
room = Actb::Room.create_with_members!([user1, user2])
battle = room.battle_create_with_members!
history = user1.actb_histories.create!(question: question1, ox_mark: Actb::OxMark.fetch(:correct))
Actb::LobbyMessage.last         # => #<Actb::LobbyMessage id: 51, user_id: 2, body: "<a href=\"/actb?user_id=67\">名無しの棋士60号</a>さんが本日1...", created_at: "2020-08-09 03:01:25", updated_at: "2020-08-09 03:01:25">
