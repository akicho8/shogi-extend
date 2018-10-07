################################################################################ bundler

# set :bundle_path, nil
# set :bundle_flags, '--deployment'
# ▼capistrano3.3.xでbin以下に配備されなくなる - Qiita
# https://qiita.com/yuuna/items/27a561a14399c5343d2f
set :bundle_binstubs, -> { shared_path.join('bin') }
