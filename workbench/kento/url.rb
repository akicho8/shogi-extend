require "./setup"
object = Kento::Url["https://example.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6"]
tp object.attributes            # => {initpos: "ln7/2g6/1ks+R5/pppp5/9/9/+p+p+p6/2+p6/K1+p6 b NGB9p3l2n3s2gbr 1", branch_from: 0, branch: ["N*7e", "7d7e", "B*7d", "8c9c", "G*9b", "9a9b", "7d9b+", "9c9b", "6c7b", "R*8b", "G*8c", "9b9a", "7b8b", "7c8b", "R*9b"], moves: nil}
object.to_sfen                  # => "position sfen ln7/2g6/1ks+R5/pppp5/9/9/+p+p+p6/2+p6/K1+p6 b NGB9p3l2n3s2gbr 1"
# >> |-------------+---------------------------------------------------------------------------------------------------------------------------|
# >> |     initpos | ln7/2g6/1ks+R5/pppp5/9/9/+p+p+p6/2+p6/K1+p6 b NGB9p3l2n3s2gbr 1                                                           |
# >> | branch_from | 0                                                                                                                         |
# >> |      branch | ["N*7e", "7d7e", "B*7d", "8c9c", "G*9b", "9a9b", "7d9b+", "9c9b", "6c7b", "R*8b", "G*8c", "9b9a", "7b8b", "7c8b", "R*9b"] |
# >> |       moves |                                                                                                                           |
# >> |-------------+---------------------------------------------------------------------------------------------------------------------------|
