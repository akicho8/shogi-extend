module FormBox
  module InputsBuilder
    class Base
      attr_accessor :form_parts
      attr_accessor :options

      def self.inputs_render(*args)
        new(*args).inputs_render
      end

      def initialize(form_parts, options = {})
        @form_parts = form_parts
        @options = {}.merge(options)
      end

      def inputs_render
        form_parts.collect { |e| ::FormBox::InputBuilder.input_render(e) }.join("\n").html_safe
      end

      private

      def form_parts
        Array.wrap(@form_parts)
      end

      def h
        ::ApplicationController.helpers
      end
    end

    # class CollapseInputsBuilder < Base
    #   def inputs_render
    #     out = []
    #     group = form_parts.group_by { |e| !!e[:collapse] }
    #     out << Array(group[false]).collect { |e| InputBuilder.input_render(e) }.join("\n").html_safe
    #     # その他の項目
    #     if group[true].present?
    #       out << h.bootstrap_form_actions do
    #         h.content_tag(:span, collapse_label_name, :class => "button button-link button-sm", "data-toggle" => "collapse", "data-target" => "##{target_id}")
    #       end
    #       out << h.content_tag(:div, :id => target_id, :class => "collapse") do
    #         Array(group[true]).collect { |e| InputBuilder.input_render(e) }.join("\n").html_safe
    #       end
    #     end
    #     out.join.html_safe
    #   end
    #
    #   private
    #
    #   def collapse_label_name
    #     @options[:collapse_label_name] || h.bootstrap_icon(:sort_down, :size => 3) + "その他".html_safe
    #   end
    #
    #   def target_id
    #     @target_id ||= @target_id || SecureRandom.hex
    #   end
    # end

    # グループ毎に分けられる機能付き
    # class GroupedInputsBuilder < Base
    #   def inputs_render
    #     out = []
    #     g = form_parts.group_by { |e| e[:group] }
    #     g.collect {|group, list|
    #       s = list.collect { |e| InputBuilder.input_render(e) }.join.html_safe
    #       content_tag(:div, s, :class => group ? "well" : "").html_safe
    #     }.join("\n").html_safe
    #   end
    # end

    Default = Base
  end
end
