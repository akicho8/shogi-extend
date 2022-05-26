#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp User.all.find_all { |e| e.valid_password?("password") }.collect { |e| {name: e.name, auth_infos_count: e.auth_infos.count, password: e.valid_password?("password")} }

tp User.all.find_all { |e| e.valid_password?("password") }.collect { |e| e.name }
User.all.each do |user|
  if user.valid_password?("password")
    user.password = Devise.friendly_token(32)
    user.save!
  end
end
tp User.all.collect { |e| {name: e.name, password: e.valid_password?("password")} }

# >> |-----------------------+----------|
# >> | name                  | password |
# >> |-----------------------+----------|
# >> | 運営                  | true     |
# >> | ルール覚えたてのCPU   | true     |
# >> | あきれるほど弱いCPU   | true     |
# >> | ありえないほど弱いCPU | true     |
# >> | めちゃくちゃ弱いCPU   | true     |
# >> | かなり弱いCPU         | true     |
# >> | 弱いCPU               | true     |
# >> | 最大1分考えるCPU      | true     |
# >> | 3分考えるCPU          | true     |
# >> | 30分考えるCPU         | true     |
# >> | 名無しの棋士2号       | true     |
# >> | 名無しの棋士3号       | true     |
# >> |-----------------------+----------|
# >> |-----------------------|
# >> | 運営                  |
# >> | ルール覚えたてのCPU   |
# >> | あきれるほど弱いCPU   |
# >> | ありえないほど弱いCPU |
# >> | めちゃくちゃ弱いCPU   |
# >> | かなり弱いCPU         |
# >> | 弱いCPU               |
# >> | 最大1分考えるCPU      |
# >> | 3分考えるCPU          |
# >> | 30分考えるCPU         |
# >> | 名無しの棋士2号       |
# >> | 名無しの棋士3号       |
# >> |-----------------------|
# >> |-----------------------+----------|
# >> | name                  | password |
# >> |-----------------------+----------|
# >> | 運営                  | false    |
# >> | ルール覚えたてのCPU   | false    |
# >> | あきれるほど弱いCPU   | false    |
# >> | ありえないほど弱いCPU | false    |
# >> | めちゃくちゃ弱いCPU   | false    |
# >> | かなり弱いCPU         | false    |
# >> | 弱いCPU               | false    |
# >> | 最大1分考えるCPU      | false    |
# >> | 3分考えるCPU          | false    |
# >> | 30分考えるCPU         | false    |
# >> | 名無しの棋士2号       | false    |
# >> | 名無しの棋士3号       | false    |
# >> |-----------------------+----------|
