class QuickScript::Swars::CrossSearchScript
  class GradeDiffInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :gteq2, name: "かなり強い", comparison: :gteq, value: 2, el_message: "たとえば自分が1級としたら相手が二段以上", },
      { key: :gteq1, name: "強い",       comparison: :gteq, value: 1, el_message: "たとえば自分が1級としたら相手が初段以上", },
      { key: :gteq0, name: "同じか強い", comparison: :gteq, value: 0, el_message: "たとえば自分が1級としたら相手が1級以上",  },
      { key: :eq,    name: "同じ",       comparison: :eq,   value: 0, el_message: "たとえば自分が1級としたら相手も1級",      },
      { key: :lteq0, name: "同じか弱い", comparison: :lteq, value: 0, el_message: "たとえば自分が1級としたら相手が1級以下",  },
      { key: :lteq1, name: "弱い",       comparison: :lteq, value: 1, el_message: "たとえば自分が1級としたら相手が2級以下",  },
      { key: :lteq2, name: "かなり弱い", comparison: :lteq, value: 2, el_message: "たとえば自分が1級としたら相手が3級以下",  },
    ]
  end
end
