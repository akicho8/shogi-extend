require "./setup"
_ { Swars::User["SugarHuuko"].stat.think_stat.average } # => "231.97 ms"
_ { Swars::User["SugarHuuko"].stat.think_stat.max     } # => "21.99 ms"

options = {
  sample_max: 200,
}
tp Swars::User::Vip.auto_crawl_user_keys.collect { |key|
  if user = Swars::User[key]
    think_stat = user.stat(options).think_stat
    {
      :key     => key,
      :average => think_stat.average,
    }
  end
}.compact.sort_by { |e| e[:average] }
