class TableRefactor4 < ActiveRecord::Migration[6.0]
  def up
    rows = []
    AuthInfo.find_each{|e|
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
  end
end
