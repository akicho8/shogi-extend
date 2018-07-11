class Types::UserType < GraphQL::Schema::Object
  # [1] resolveのinference(推論)と、resolveのバリエーション
  field :id,     ID,                    null: false
  field :name,   String,                null: false

  # # [2] resolveメソッド内で利用できるhelperメソッド: object, context
  # field :bodyHtml,  String,                null: false
  # # snake_caseであることに注意してください。
  # # resolveメソッド名を `camelize(:lowder)`した値がfield名のresolveに用いられます
  # def body_html
  #   "object.decorate.body_html"
  # end

  # # [3] 型の種類にはいくつかある
  # field :createdAt, ScalarTypes::DateTime, null: false
end
