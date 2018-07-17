class SocialMediaInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :google,  name: "Google",  },
    { key: :twitter, name: "Twitter", },
    { key: :github,  name: "GitHub",  },
  ]
end

