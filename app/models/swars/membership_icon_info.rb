module Swars
  class MembershipIconInfo
    include ApplicationMemoryRecord
    memory_record [
      {
        icon: "☠",
        func: proc { |membership|
          membership.tag_names_for(:note).include?("角不成")
        },
      },
    ]
  end
end
