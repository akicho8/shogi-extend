module Ppl
  class Rank < ApplicationRecord
    include MemoryRecordBind::Basic

    has_many :users, class_name: "Ppl::User", dependent: :destroy
  end
end
