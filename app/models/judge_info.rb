class JudgeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :win,  name: "勝ち",     icon_key: nil,     icon_color: nil, },
    { key: :lose, name: "負け",     icon_key: nil,     icon_color: nil, },
    { key: :draw, name: "引き分け", icon_key: :loop,   icon_color: nil, },
  ]

  def swars_memberships
    Swars::Membership.where(judge_key: key)
  end

  def icon_params(grade_diff)
    if icon_key
      { key: icon_key, :class => icon_class }
    else
      if key == :win
        case
        when grade_diff >= 1
          case
          when true
            if grade_diff <= 9
              v = "numeric-#{grade_diff}-circle"
            else
              v = "numeric-9-plus-circle"
            end
            { :key => v, :class => "has-text-gold" }
          when false
            "🎉"
          when false
            { key: "star-circle", :class => "has-text-gold", }
          end
        when grade_diff == 0
          { key: "star", :class => "has-text-gold", }
        else
          { key: "star-outline", :class => "has-text-gold", }
        end
      end
    end
  end

  concerning :IconColorMethods do
    def icon_color
      super || "grey-light"
    end

    def icon_class
      "has-text-#{icon_color}"
    end
  end
end
