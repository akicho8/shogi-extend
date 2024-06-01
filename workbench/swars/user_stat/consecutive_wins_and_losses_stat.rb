require "../setup"
Swars::User.first.user_stat.consecutive_wins_and_losses_stat.to_h                       # => {}
Swars::User.find_by!(key: "SugarHuuko").user_stat.consecutive_wins_and_losses_stat.to_h # => {:lose=>2, :win=>12, :draw=>1}

