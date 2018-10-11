set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }
set :whenever_path,       -> { release_path } # FIXME: whenever (0.10.0) 以下の場合のみ

