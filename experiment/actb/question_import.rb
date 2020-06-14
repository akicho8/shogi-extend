require "./setup"

# Actb::Question.exists?                 # => true

Actb::Question.import_all
Actb::Question.count            # => 3
