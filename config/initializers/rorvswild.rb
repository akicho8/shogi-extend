if defined? RorVsWild
  RorVsWild.start(api_key: Rails.application.credentials[:rorvswild][Rails.env][:api_key])
end
