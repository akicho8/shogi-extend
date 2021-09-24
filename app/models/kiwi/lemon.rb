module Kiwi
  class Lemon < ApplicationRecord
    include BuildMethods
    include ThumbnailMethods
    include InfoMethods
    include JsonStructMethods
    include MockMethods
  end
end
