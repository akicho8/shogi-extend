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
    description "指定IDのユーザーを取得"
    argument :id, ID, "ユーザーID", required: true
  end
  def user(id:)
    Colosseum::User.find(id)
  end
end
