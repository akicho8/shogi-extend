RSpec::Rails::ModelExampleGroup.module_eval do
  concerning :RspecSwarsSupportMethods do
    def outbreak_csa
      [
        ["+1716FU", 600],
        ["-1314FU", 600],
        ["+1615FU", 600],
        ["-1415FU", 600],
        ["+1915KY", 600],
        ["-1115KY", 600],
      ]
    end
  end
end
