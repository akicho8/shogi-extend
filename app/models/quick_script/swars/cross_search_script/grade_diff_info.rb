class QuickScript::Swars::CrossSearchScript
  class GradeDiffInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :gt,   name: "強い",       el_message: "例: 自分が1級のとき相手が初段以上", },
      { key: :gteq, name: "同じか強い", el_message: "例: 自分が1級のとき相手が1級以上",  },
      { key: :eq,   name: "同じ",       el_message: "例: 自分が1級のとき相手も1級",      },
      { key: :lteq, name: "同じか弱い", el_message: "例: 自分が1級のとき相手が1級以下",  },
      { key: :lt,   name: "弱い",       el_message: "例: 自分が1級のとき相手が2級以下",  },
    ]
  end
end
