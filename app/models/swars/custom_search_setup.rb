module Swars
  class CustomSearchSetup
    def call
      hv = {}

      hv[:xmode_infos] = XmodeInfo.collect do |e|
        { :key => e.key, :yomiage => e.long_name }
      end

      hv[:rule_infos] = RuleInfo.collect do |e|
        { :key => e.name, :yomiage => e.long_name }
      end

      hv[:final_infos] = FinalInfo.collect do |e|
        { :key => e.name }
      end

      hv[:preset_infos] = SwPresetInfo.collect do |e|
        { :key => e.key }
      end

      hv[:grade_infos] = GradeInfo.find_all(&:select_option).reverse.collect do |e|
        { :key => e.key, :name => e.short_name, yomiage: e.name }
      end

      hv[:ban_infos] = BanInfo.collect do |e|
        { :key => e.key, :name => e.name, yomiage: e.yomiage }
      end

      hv[:style_infos] = StyleInfo.collect do |e|
        { :key => e.key }
      end

      hv[:judge_infos] = JudgeInfo.collect do |e|
        { :key => e.name }
      end

      hv[:location_infos] = LocationInfo.collect do |e|
        {
          :key     => e.name,
          :name    => "#{e.pentagon_mark} #{e.equality_name}",
          :yomiage => "#{e.equality_name}または#{e.handicap_name}",
        }
      end

      hv[:tactic_infos] = Bioshogi::Analysis::TacticInfo.inject({}) do |a, e|
        a.merge(e.key => {
            :key    => e.key,
            :name   => e.name,
            :values => e.model.collect(&:name).uniq, # uniq はキーが異なっても名前が同じものがある場合があるため
          })
      end

      hv
    end
  end
end
