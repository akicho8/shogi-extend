# frozen-string-literal: true

module QuickScript
  module General
    class EncyclopediaScript < Base
      self.title = "戦法ミニ事典"
      self.description = "任意の戦法の組み方や棋譜を確認する"
      self.form_method = :get
      self.button_label = "表示"
      self.router_push_failed_then_fetch = true
      self.debug_mode = false
      # self.qs_invisible = true

      def form_parts
        super + [
          {
            :label        => "戦法",
            :key          => :tag,
            :type         => :string,
            :dynamic_part => -> {
              {
                :auto_complete_by        => :html5,
                :elems        => candidate_tag_names,
                :default      => params[:tag].presence,
                :help_message => "直接入力 or 右端の▼から選択",
              }
            },
          },
          # {
          #   :label        => "戦法 (選択)",
          #   :key          => :input_tag1,
          #   :type         => debug_mode ? :select : :hidden,
          #   :elems        => [""] + candidate_tag_names,
          #   :dynamic_part => -> {
          #   {
          #   }
          # }
          # :default => params[:input_tag1] },
          # },
          # {
          #   :label        => "戦法 (入力)",
          #   :key          => :input_tag2,
          #   :type         => debug_mode ? :string : :hidden,
          #   :auto_complete_by        => :b_autocomplete,
          #   :elems        => candidate_tag_names,
          #   :dynamic_part => -> {
          #   {
          #   }
          # }
          # :default => params[:input_tag2].presence },
          # },
        ]
      end

      def call
        if tag.blank?
          return
        end
        if current_item.blank?
          return "#{tag}に該当するものが見つかりません"
        end
        values = [
          { _component: "CustomShogiPlayer", _v_bind: sp_params, style: { "max-width" => "640px", margin: "auto" }, :class => "is-unselectable is-centered", },
          { _component: "QuickScriptViewValueAsPre", _v_bind: { value: sp_body }, :class => "is-size-7" },
        ]
        v_stack(values, style: { "gap" => "1rem" })
      end

      ################################################################################

      def tag
        @tag ||= (params[:input_tag1].presence || params[:input_tag2].presence || params[:tag].presence).to_s
      end

      def current_item
        @current_item ||= Bioshogi::Analysis::TagIndex.lookup(tag)
      end

      def candidate_tag_names
        @candidate_tag_names ||= [:attack, :defense, :technique, :note].flat_map { |e| Bioshogi::Analysis::TacticInfo[e].model.collect(&:name) }
      end

      ################################################################################

      def title
        if current_item
          "[#{current_item.tactic_info}] #{current_item.name} - #{super}"
        else
          super
        end
      end

      ################################################################################

      def sp_params
        {
          :key           => SecureRandom.hex, # 再度表示ボタンを押したときに盤面を作り直すため
          :sp_mode       => "view",
          :sp_body       => sp_body,
          :sp_turn       => sp_turn,
          :sp_viewpoint  => sp_viewpoint,
          :sp_turn_show  => true,
          :sp_comment    => true,
          :sp_controller => true,
          :sp_slider     => true,
        }
      end

      def parser
        @parser ||= current_item.static_kif_info
      end

      def sp_body
        @sp_body ||= current_item.static_kif_file.read
      end

      def sp_turn
        current_item.hit_turn || parser.container.turn_info.display_turn
      end

      # 手数から視点を判断する、current_item.hit_turn.try { even? ? :white : :black } || :black の方法では
      # 平手でない場合に先後が怪しくなる。
      # 単純に「戦法」を持っている側の視点にするのがいい。
      def sp_viewpoint
        player = parser.container.players.find { |e| e.tag_bundle.include?(current_item) }
        player or raise "この棋譜では #{current_item.name} が発動しない"
        player.location.key
      end
    end
  end
end
