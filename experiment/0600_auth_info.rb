#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# auth_info = AuthInfo.last
# tp auth_info
# tp auth_info.meta_info.dig("info", "description")
# pp auth_info.meta_info

rows = []
AuthInfo.find_each{|e|
  p e
  profile = e.user.profile
  if v = e.meta_info.dig("info", "description")
    if profile.description.blank?
      profile.description = v
    end
  end
  if e.provider == "twitter"
    if v = e.meta_info.dig("info", "nickname")
      if profile.twitter_key.blank?
        profile.twitter_key = v
      end
    end
  end
  if profile.has_changes_to_save?
    profile.changes_to_save
    rows << e.user
  end
  profile.save!
}
tp rows
