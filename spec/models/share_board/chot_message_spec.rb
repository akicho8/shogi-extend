require "rails_helper"

RSpec.describe ShareBoard::ChotMessage do
  before do
    ShareBoard.setup
  end

  it "発言スコープ種別のレコードがある" do
    assert { ShareBoard::MessageScope.count == 2 }
  end

  it "レコードを作る" do
    user = ShareBoard::User.create!
    room = ShareBoard::Room.create!
    chot_message = room.chot_messages.create!(user: user)
    assert { chot_message.user == user }
    assert { chot_message.room == room }
    chot_message.save!
    assert { room.chot_messages_count == 1 }
    assert { user.chot_messages_count == 1 }
    assert { room.chot_messages == [chot_message] }
    assert { room.chot_users == [user] }
    assert { chot_message.message_scope == ShareBoard::MessageScope[:is_message_scope_public] }
  end

  it "user 側のリレーションが正しい" do
    user = ShareBoard::User.create!
    room = ShareBoard::Room.create!
    assert { user.chot_messages.create!(room: room) }
  end

  it "ログインしている人のIDを一緒に記録する" do
    login_user = User.create!
    user = ShareBoard::User.create!
    room = ShareBoard::Room.create!
    chot_message = room.chot_messages.create!(user: user, real_user: login_user)
    assert { chot_message.real_user == login_user }
  end

  it "簡単にデータを用意する" do
    user = ShareBoard::User.create!
    room = ShareBoard::Room.create!
    room.chot_messages_mock_setup(10, user: user)
    assert { room.chot_messages.count == 10 }
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> ShareBoard::ChotMessage
# >>   発言スコープ種別のレコードがある
# >>   レコードを作る
# >>   user 側のリレーションが正しい
# >>   ログインしている人のIDを一緒に記録する
# >>   簡単にデータを用意する
# >> 
# >> Top 5 slowest examples (0.38014 seconds, 15.6% of total time):
# >>   ShareBoard::ChotMessage 発言スコープ種別のレコードがある
# >>     0.11456 seconds -:8
# >>   ShareBoard::ChotMessage レコードを作る
# >>     0.09706 seconds -:12
# >>   ShareBoard::ChotMessage ログインしている人のIDを一緒に記録する
# >>     0.07191 seconds -:32
# >>   ShareBoard::ChotMessage 簡単にデータを用意する
# >>     0.06844 seconds -:40
# >>   ShareBoard::ChotMessage user 側のリレーションが正しい
# >>     0.02817 seconds -:26
# >> 
# >> Finished in 2.43 seconds (files took 1.55 seconds to load)
# >> 5 examples, 0 failures
# >> 
