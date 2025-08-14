module Ppl
  class Result < ApplicationRecord
    include MemoryRecordBind::Basic

    has_many :memberships, class_name: "Ppl::Membership", dependent: :destroy
  end
end
