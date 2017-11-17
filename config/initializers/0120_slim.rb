if Rails.env.development?
  Slim::Engine.set_options(pretty: true, sort_attrs: false)
end
