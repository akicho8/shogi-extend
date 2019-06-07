#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

ChatMessage.destroy_all
User.destroy_all
Colosseum::Battle.destroy_all
Membership.destroy_all

alice = Colosseum::User.create!
bob = Colosseum::User.create!

battle = OwnerRoom.create!
battle.users << alice
battle.users << bob

tp battle.memberships

alice.chat_messages.create(battle: battle, message: "(body)")
tp ChatMessage

tp battle

tp battle.current_users

# ~> -:4:in `<main>': uninitialized constant ChatMessage (NameError)
