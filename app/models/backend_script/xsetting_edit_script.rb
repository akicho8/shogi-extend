module BackendScript
  class XsettingEditScript < ::BackendScript::Base
    include AtomicScript::PostRedirectMethods

    self.category = "システム設定"
    self.script_name = "システム設定更新"

    def form_parts
      list = AvailableXsetting.find_all(&:form_enable)
      if v = params[:xsetting_key].presence
        list = list.find_all { |e| e.key == v.to_sym }
      end
      if v = params[:xsetting_tag].presence
        list = list.find_all { |e| e.tags.include?(v) }
      end
      elems = list.collect {|e|
        v = e.form_part
        if true
          # エラーになったときに不具合の内容を入れる
          v = v.merge(:default => current_xsetting[e.key.to_s] || Xsetting[e.key])
        else
          # エラーになったとき正しい値に戻る
        end
        v
      }.compact
      if elems.one?
        elems += [
          {
            :label        => "初期値に戻す",
            :right_label  => "はい",
            :key          => :reset,
            :type         => :boolean,
            :default      => current_reset,
            :collapse     => !current_reset,
            :help_message => "DBにレコードがあった場合はDBから削除します",
          }
        ]
      end
      elems += [
        {
          :key     => :xsetting_lock_version,
          :type    => :hidden,
          :default => Xsetting[:xsetting_lock_version],
        },
        {
          :key     => :xsetting_key,
          :type    => :hidden,
          :default => params[:xsetting_key],
        },
        {
          :key     => :xsetting_tag,
          :type    => :hidden,
          :default => params[:xsetting_tag],
        },
      ]
    end

    def script_body
      diff = Xsetting[:xsetting_lock_version] - params[:xsetting_lock_version].to_i
      if diff >= 1
        raise "競合しているため更新できません。フォームを開いてから保存する間に他の人の更新が#{diff}回ありました。いまは最新の値をフォームに取り込んだので速やかに操作すれば更新できるはずです。"
      end

      unless current_reset
        # 保存する前にすべてチェックする
        current_xsetting.collect do |var_key, value|
          meta = AvailableXsetting.fetch(var_key)
          if v = (meta.respond_to?(:valid_func) && meta.valid_func)
            # begin
            r = v.call(value)
            # rescue Exception => error # 外側では StandardError しか捕捉していないため
            #   raise ArgumentError, error.inspect
            # end
            unless r
              raise ArgumentError, "#{meta.name} (#{meta.key}) の値 #{value.inspect} が不正です"
            end
          end
        end
      end

      Xsetting.transaction do
        Xsetting[:xsetting_lock_version] += 1
        current_xsetting.collect { |var_key, value|
          b = Xsetting[var_key]
          func = -> {
            if current_reset
              Xsetting.reset(var_key, :by_staff => __staff__)
              Xsetting.remove_from_db(var_key)
            else
              Xsetting.var_set(var_key, value, :by_staff => __staff__)
            end
          }
          if Rails.env.production?
            func.call
          else
            Timecop.return { func.call }
          end
          a = Xsetting[var_key]
          if [b, a].collect {|v| v.to_s.lines.to_a.collect(&:rstrip) }.uniq.count != 1
            {"項目" => AvailableXsetting[var_key].name, "変更前" => b.inspect, "変更後" => a.inspect}
          end
        }.compact
      end
    end

    def current_xsetting
      params[:xsetting].presence || {}
    end

    def clean_params
      super.except(:xsetting, :xsetting_lock_version, :_submit, :reset)
    end

    def post_buttun_label
      "保存"
    end

    def current_reset
      current_xsetting.one? && params[:reset].to_s == "true"
    end
  end
end
