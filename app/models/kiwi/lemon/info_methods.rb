module Kiwi
  class Lemon
    concern :InfoMethods do
      def info2
        {
          "ID"       => id,
          "投稿者"   => user.name,
          "作成日時" => created_at.to_s(:ymdhm),
        }
      end
    end
  end
end
