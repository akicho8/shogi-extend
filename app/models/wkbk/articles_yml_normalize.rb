reject_keys    = ["3615c50af5141299c3fa4d528107590d", "81fc37d593dc0fe3267bcaecfff712e1", "b1a3c586561f8ebe58f15f7c10c2d404", "ef5c5009401cf717ae7e37dd8c834a7d", "e1dbd0d616511f4a16016595f21f662f", "910035b23b192ab32d012211e6d59211", "0285557cfbfde9510ac271a249eebe42", "b0538a0efd2a8ee173d6fd11160fcf4f", "ec478a69cc63aafefa35b304325b6c19", "bb01149af655c6a5120cd4e1f27c46b9", "863225110816a47b701de8e34ed102cf", "cba9132a42f676ae206d3017b848b764"]
mate_skip_keys = ["273e3c63a2042d84324a9424b761d541", "2fff956093c107adad7cfc476ce5de88", "3615c50af5141299c3fa4d528107590d", "57f055d2775e96b4c1e7e879623993b3", "583dc8cc25c591ecdb350930a2fd7915", "6fc471f94345ebb2421be55c3aaff4a6", "9db85cccda2ec53a7ed6c52d0762bbbc", "a9bcfb4fd3e6348a71a6f39337c82914", "cb0118f864b89f7dbbb6a11a3350bac2", "fa77f5e5d870bdde64b28264635f1158", "fe946a6362bb67c9e87bbe91ca7d9850"]

require "pathname"
require "yaml"
file = Pathname("../actb/questions_all.yml")
list = YAML.load(file.read)
list.count                      # => 562
list = list.find_all { |e| e["user_id"] == 8 }
list = list.reject { |e| reject_keys.include?(e["key"]) }
list.each { |e| e["mate_skip"] = mate_skip_keys.include?(e["key"]) }
list.count                      # => 321
Pathname("articles.yml").write(list.to_yaml)
