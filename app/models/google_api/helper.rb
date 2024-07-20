module GoogleApi
  module Helper
    extend self

    def hyper_link(name, url)
      %(=HYPERLINK("#{url}", "#{name}"))
    end
  end
end
