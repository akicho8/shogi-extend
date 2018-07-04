#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

ChatMessage.destroy_all
User.destroy_all
Fanta::Battle.destroy_all
Membership.destroy_all

alice = Fanta::User.create!
bob = Fanta::User.create!

battle = OwnerRoom.create!
battle.users << alice
battle.users << bob

tp battle.memberships

alice.chat_messages.create(battle: battle, message: "(body)")
tp ChatMessage

tp battle

tp battle.current_users

# ~> -:4:in `<main>': uninitialized constant ChatMessage (NameError)
