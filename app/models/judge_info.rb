class JudgeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :win,  name: "勝ち",     icon_names: nil,     icon_class: nil, },
    { key: :lose, name: "負け",     icon_names: nil,     icon_class: nil, },
    { key: :draw, name: "引き分け", icon_names: :minus,  icon_class: nil, },
  ]

  def icon_params(grade_diff)
    if icon_names
      { names: icon_names, :class => icon_class }
    else
      if key == :win
        case
        when grade_diff >= 1
          { names: "star", :class => "icon_o", }
        when grade_diff == 0
          { names: "star-half", :class => "icon_o", }
        else
          { names: "star-outline", :class => "icon_o", }
        end
      end
    end
  end

  def swars_memberships
    Swars::Membership.where(judge_key: key)
  end

  def general_memberships
    General::Membership.where(judge_key: key)
  end
end
