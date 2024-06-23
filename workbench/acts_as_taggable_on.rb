require "./setup"
tag = ActsAsTaggableOn::Tag.find_by(name: "相振り飛車") # => #<ActsAsTaggableOn::Tag id: 500, name: "相振り飛車", taggings_count: 446564>
tag.taggings_count                                      # => 446564
