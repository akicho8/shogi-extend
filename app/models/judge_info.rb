class JudgeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :win,  name: "勝ち",     icon_key: nil,     icon_color: nil, wb_mark: "○" },
    { key: :lose, name: "負け",     icon_key: nil,     icon_color: nil, wb_mark: "●" },
    { key: :draw, name: "引き分け", icon_key: :loop,   icon_color: nil, wb_mark: "─" },
  ]

  def swars_memberships
    Swars::Membership.where(judge_key: key)
  end

  def icon_params(membership)
    grade_diff = membership.grade_diff

    rule_info = membership.battle.rule_info
    if t = rule_info.leave_alone_limit2
      if membership.think_max >= t
        return "😴"
      end
    end
    if t = rule_info.leave_alone_limit1
      if membership.think_max >= t
        return "😪"
      end
    end

    if icon_key
      # 引き分け
      return { key: icon_key, :class => icon_class }
    end

    # 勝ったときだけ
    if key == :win
      case
      when grade_diff >= 1
        case
        when true
          if grade_diff <= 9
            if grade_diff == 1
              # return "🍣"
            end
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

  concerning :IconColorMethods do
    def icon_color
      super || "grey-light"
    end

    def icon_class
      "has-text-#{icon_color}"
    end
  end
end
