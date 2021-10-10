module Kiwi
  class SearchPresetInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "新着",     func: -> s, params { s.public_only_with_user(params)                                                            }, },
      { key: "視聴数",   func: -> s, params { s.public_only_with_user(params).order(access_logs_count: :desc)                                    }, },
      { key: "居飛車",   func: -> s, params { s.public_only_with_user(params).tagged_with("居飛車")                                      }, },
      { key: "振り飛車", func: -> s, params { s.public_only_with_user(params).tagged_with("振り飛車")                                    }, },
      { key: "右玉",     func: -> s, params { s.public_only_with_user(params).tagged_with(::Swars::UserInfo.migigyoku_family, any: true) }, },
      { key: "履歴",     func: -> s, params { params[:current_user] ? params[:current_user].kiwi_access_logs.uniq_histories : s.none         }, },
      { key: "公開",     func: -> s, params { params[:current_user] ? params[:current_user].kiwi_bananas.folder_eq(:public) : s.none               }, },
      { key: "限定公開", func: -> s, params { params[:current_user] ? params[:current_user].kiwi_bananas.folder_eq(:limited) : s.none              }, },
      { key: "非公開",   func: -> s, params { params[:current_user] ? params[:current_user].kiwi_bananas.folder_eq(:private) : s.none               }, },
    ]
  end
end
