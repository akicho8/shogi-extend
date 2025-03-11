class QuickScript::Swars::BasicStatScript
  class Base
    attr_reader :base

    def initialize(base)
      @base = base
    end

    def cache_write
      AggregateCache[self.class.name].write(aggregate_now)
    end

    def cache_clear
      AggregateCache[self.class.name].destroy_all
    end

    def call
      raise NotImplementedError, "#{__method__} is not implemented"
    end

    def component_title
    end

    def component_body
      base.simple_table(call, always_table: true)
    end

    def to_component
      v = []
      if component_title
        v << { :_v_html => base.tag.div(component_title, :class => "title is-5 my-5") }
      end
      v += Array.wrap(component_body)
      v = base.v_stack(v, style: {"gap" => "0rem"})
      if false
        v = { _component: "QuickScriptViewValueAsBox", _v_bind: { value: v } }
      end
      v
    end

    def main_scope
      base.params[:scope] || base.main_scope_on_development || ::Swars::Membership.all
    end

    def aggregate
      @aggregate ||= AggregateCache[self.class.name].read || aggregate_now
    end

    def aggregate_now
      {}
    end

    def custom_chart_options
      {
        scales_y_axes_ticks: nil,
        scales_y_axes_display: false,
      }
    end
  end
end
