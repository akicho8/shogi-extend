class Types::QueryType < Types::BaseObject
  field :ping, String, null: false, description: "疎通確認"
  def ping
    "pong"
  end

  field :hello, String, null: false, description: "helloにworldを返す"
  def hello
    "world"
  end

  field :user, Types::UserType, null: true do
    description 'ユーザーをidで1件取得' # fieldのdescription引数はブロック内で定義してもOK
    argument :id, ID, 'ユーザーのID', required: true
  end
  #
  # argumentがあるとき、resolveメソッドは必須キーワード引数としてそれを受け取れる
  #
  def user(id:)
    Fanta::User.find(id)
  end
end
