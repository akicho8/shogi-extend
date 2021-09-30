require "rails_helper"

RSpec.describe User, type: :model do
  include ActbSupportMethods

  xit "works" do
    user1.actb_lobby_messages.create!(body: "(body)")
    question = user1.actb_questions.create_mock1
    room = Actb::Room.create_with_members!([user1, user2])
    battle = room.battle_create_with_members!
    user1.actb_histories.create!(question: question, ox_mark: Actb::OxMark.fetch(:correct))
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
| Actb::Rule             |     14 |    14 |    0 |
| Actb::Season           |      1 |     1 |    0 |
| Actb::Skill            |     21 |    21 |    0 |
| Actb::Lineage          |      8 |     8 |    0 |
|------------------------+--------+-------+------|
EOT
  end
end
# ~> /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/specification.rb:2302:in `raise_if_conflicts': Unable to activate rspec-expectations-3.9.2, because rspec-support-3.10.1 conflicts with rspec-support (~> 3.9.0) (Gem::ConflictError)
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/specification.rb:1418:in `activate'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems.rb:223:in `rescue in try_activate'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems.rb:216:in `try_activate'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:123:in `rescue in require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:34:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-core-3.10.1/lib/rspec/core/configuration.rb:841:in `block in expect_with'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-core-3.10.1/lib/rspec/core/configuration.rb:836:in `map'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-core-3.10.1/lib/rspec/core/configuration.rb:836:in `expect_with'
# ~> 	from /Users/ikeda/src/shogi-extend/spec/spec_helper.rb:24:in `block in <top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-core-3.10.1/lib/rspec/core.rb:98:in `configure'
# ~> 	from /Users/ikeda/src/shogi-extend/spec/spec_helper.rb:20:in `<top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from /Users/ikeda/src/shogi-extend/spec/rails_helper.rb:2:in `<top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from -:1:in `<main>'
# ~> /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/specification.rb:2302:in `raise_if_conflicts': Unable to activate rspec-expectations-3.9.2, because rspec-support-3.10.1 conflicts with rspec-support (~> 3.9.0) (Gem::ConflictError)
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/specification.rb:1418:in `activate'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems.rb:217:in `try_activate'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:123:in `rescue in require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:34:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-core-3.10.1/lib/rspec/core/configuration.rb:841:in `block in expect_with'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-core-3.10.1/lib/rspec/core/configuration.rb:836:in `map'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-core-3.10.1/lib/rspec/core/configuration.rb:836:in `expect_with'
# ~> 	from /Users/ikeda/src/shogi-extend/spec/spec_helper.rb:24:in `block in <top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-core-3.10.1/lib/rspec/core.rb:98:in `configure'
# ~> 	from /Users/ikeda/src/shogi-extend/spec/spec_helper.rb:20:in `<top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from /Users/ikeda/src/shogi-extend/spec/rails_helper.rb:2:in `<top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from -:1:in `<main>'
# ~> /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require': cannot load such file -- rspec/expectations (LoadError)
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-core-3.10.1/lib/rspec/core/configuration.rb:841:in `block in expect_with'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-core-3.10.1/lib/rspec/core/configuration.rb:836:in `map'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-core-3.10.1/lib/rspec/core/configuration.rb:836:in `expect_with'
# ~> 	from /Users/ikeda/src/shogi-extend/spec/spec_helper.rb:24:in `block in <top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-core-3.10.1/lib/rspec/core.rb:98:in `configure'
# ~> 	from /Users/ikeda/src/shogi-extend/spec/spec_helper.rb:20:in `<top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from /Users/ikeda/src/shogi-extend/spec/rails_helper.rb:2:in `<top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from -:1:in `<main>'
