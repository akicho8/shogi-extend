require "./setup"
Swars::User.first.stat.win_lose_streak_stat.to_h                       # => {}
Swars::User.find_by!(key: "SugarHuuko").stat.win_lose_streak_stat.to_h # => {lose: 2, win: 15}
