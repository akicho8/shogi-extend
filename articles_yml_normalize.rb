reject_keys    = ["08b580e9fb01b1af64a44800a3808403","8866edbfaf28b3a9a74786a51b183460","1e9f8d856cd92f930b43ac7e87393250","433cc387bc9896bd4833ac5bcae41496","8a8019fb9113528066d95ebc5c2412f8","104b2e5ef422b020dd12183c7ef79468", "3615c50af5141299c3fa4d528107590d", "81fc37d593dc0fe3267bcaecfff712e1", "b1a3c586561f8ebe58f15f7c10c2d404", "ef5c5009401cf717ae7e37dd8c834a7d", "e1dbd0d616511f4a16016595f21f662f", "910035b23b192ab32d012211e6d59211", "0285557cfbfde9510ac271a249eebe42", "b0538a0efd2a8ee173d6fd11160fcf4f", "ec478a69cc63aafefa35b304325b6c19", "bb01149af655c6a5120cd4e1f27c46b9", "863225110816a47b701de8e34ed102cf", "cba9132a42f676ae206d3017b848b764"]
mate_skip_keys = ["0ae6feb64d4046c8ddd5967b1302f837","4bd9c7cad0f6d752bc6ce28b47813b53","4ffd19f335f4ce3a9c5896d8b77cbe10","60cd8172f8be31541128d145ebaa8fde","9a247e0a083919e029f88a4746daa739","9f35297a4e738c65ed89ebfafdb3f816","eb0f96fde1d7d85da8189a183025da76","00228c96480654f2caa9a0f8ff980739","26c52fa8e4d23c093edb52f797c3d408","303efe13e65c5b5e47f8ed8ca9c0c68f","30ea9d503497dcddc820c9f0cf4a05d5","3a9375f15d93dbfa8281cdab8d182272","404690302c39b118e464f27ad04acc66","40e31c4f1b5ad5de94dd570b2c5f3311","557566888edca76e209993f38b944f76","5cf0bcc2448e7acd945da353a5545cc2","6207d14930010a90d6a608c26efa3117","6c9d08395565370f1c297c183c15481e","6d79a50c7b4a5ac625ec9f3305b23dad","82c0d4d871a531d59bb4fb4fd3d3a47c","83a90164e2a1e5529bf152c44a0aa336","8cabfb55c9f310a592ff3ee35ed61c06","8cef5307e2faced9f00bbcca61f6e831","93cd51d78087e688b9a16bac78ba7e47","9557140335acdcdf98d9552f44700a9e","9a6bb4e6801f5b68fbb6e044cac24ff0","bfff1d3f15bec42e56e357312119849b","c03fb397ead5cde711a8f00c93be4da4","ce3ae551cde7896c16d18fbd90b40e41","d78bc550c8a23d65369c6b502a572b1b","e05d24e73b9497521b9f5f8f743c06f7","e89d2e5ebdd47e4a5f071983000f4478","e937ba56060f20b380576b255641af74","ee3ca99dc9cc94cdcd0a1de807449f00","eecda98d27dbae7a74b4da54fbec574b","f2ec514f4a673cf953406a81947ce1fa","f5f5799a59e6e4f6bed731fb6eb3e5b2","273e3c63a2042d84324a9424b761d541", "2fff956093c107adad7cfc476ce5de88", "3615c50af5141299c3fa4d528107590d", "57f055d2775e96b4c1e7e879623993b3", "583dc8cc25c591ecdb350930a2fd7915", "6fc471f94345ebb2421be55c3aaff4a6", "9db85cccda2ec53a7ed6c52d0762bbbc", "a9bcfb4fd3e6348a71a6f39337c82914", "cb0118f864b89f7dbbb6a11a3350bac2", "fa77f5e5d870bdde64b28264635f1158", "fe946a6362bb67c9e87bbe91ca7d9850"]
gentei = ["c47100573117d1c34afd357131ad07e7","9f35297a4e738c65ed89ebfafdb3f816","66d21e34d4bf7f1734e5477ea1b420aa","2cdad363f567162f13b63dc6747aef0f","60cd8172f8be31541128d145ebaa8fde","2e8cf057317c4b85d891d502568a8608","bf6b2631c27ceb02b59a1973f6bbc328","3e1f68fe9249ce9f5c152ce3b34a0cab"]
jissen = ["08f70d594f00f4201f2628e7cca76ae6","0ae6feb64d4046c8ddd5967b1302f837","10736afbcc80fcdeda1bb76913855ce5","44108f7e3c2a5deca3b81db12693a936","4bd9c7cad0f6d752bc6ce28b47813b53","4ffd19f335f4ce3a9c5896d8b77cbe10","919603f60b529c38c2549c793f71fa9b","9a247e0a083919e029f88a4746daa739","be00219fef2f23d134761336b152f872","eb0f96fde1d7d85da8189a183025da76",]
tsume = ["20a5cc3915637f7ee711a4c4c9c6d759"]

require "pathname"
require "yaml"
file = Pathname("app/models/actb/questions_all.yml")
list = YAML.load(file.read)
list.count                      # => 562
# list = list.find_all { |e| e["user_id"] == 8 }
list = list.reject { |e| reject_keys.include?(e["key"]) }
list = list.find_all { |e| e["folder_key"] == "active" }
list.each { |e| e["folder_key"] = "public" }
list.each { |e| e["mate_skip"] = mate_skip_keys.include?(e["key"]) }
list.each { |e| e["lineage_key"] = e["lineage_key"].gsub("玉方持駒限定の似非詰将棋", "持駒限定詰将棋") }
list.each { |e| gentei.include?(e["key"]) ? e["lineage_key"] = "持駒限定詰将棋" : nil }
list.each { |e| jissen.include?(e["key"]) ? e["lineage_key"] = "実戦詰め筋" : nil }
list.each { |e| tsume.include?(e["key"]) ? e["lineage_key"] = "詰将棋" : nil}
list.count                      # => 511
Pathname("app/models/wkbk/articles.yml").write(list.to_yaml)
