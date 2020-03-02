module AtomicScript
  module ExampleScript
    class Base < ::AtomicScript::Base
      self.url_prefix = [:admin, :example_script]
    end
  end
end
