require "./setup"

Question.setup(mate: 3, max: 1)
Question.count                     # => 21
Question.sample(mate: 3, max: 2) rescue $!           # => #<RuntimeError: 3手詰問題を2件取得したかったが1件足りない

Question.setup(mate: 3, max: 10)
Question.count                     # => 30
srand(0)
Question.sample(mate: 3, max: 5).collect(&:position) # => [5, 0, 3, 7, 9]

tp Question
# >> |----+---------------------------------------------------------------------------------------+------+----------|
# >> | id | sfen                                                                                  | mate | position |
# >> |----+---------------------------------------------------------------------------------------+------+----------|
# >> | 31 | l2gkg2l/2s3s2/p1nppp1pp/2p3p2/P4P1P1/4n3P/1PPPG1N2/1BKS2+s2/LN3+r3 w RBgl3p 72        |    5 |        0 |
# >> | 32 | lnsgs2+Pl/3kg4/p1pppN2p/6pp1/9/7R1/P1PP1Sg1P/1S3+b3/LN5KL w Nrbg6p 58                 |    5 |        1 |
# >> | 33 | lnG4nl/5k3/p1p+R1g1p1/1p1p3sp/5N3/2P1p1p2/PP1GP3P/1SG2+p1+b1/LN1K4L w Srbs4p 60       |    5 |        2 |
# >> | 34 | ln4knl/4+N2b1/4ppsG1/p1P5p/2G3pp1/3P1P2P/P2+pP1P2/2+srSK3/L+r3G1NL w G4Pbs 78         |    5 |        3 |
# >> | 35 | ln5+Pl/3s1kg+R1/p2ppl2p/2ps1Bp2/P8/2P3P1P/N2gP4/5KS2/L+r3G1N+b b GS3Pn3p 57           |    5 |        4 |
# >> | 36 | ln1g3+Rl/2sk1s+P2/2ppppb1p/p1b3p2/8P/P4P3/2PPP1P2/1+r2GS3/LN+p2KGNL w GN2Ps 36        |    7 |        0 |
# >> | 37 | ln1g2B+Rl/2s6/pPppppk2/6p1p/9/4P1P1P/P1PPSP3/3+psK3/L+r3G1NL b SNb2gn2p 39            |    7 |        1 |
# >> | 38 | ln+P3s+Pl/2+R1Gsk2/p3pp1g1/4r1ppp/1NS6/6P2/PP1+bPPS1P/3+p1K3/LG3G1NL w Nb3p 72        |    7 |        2 |
# >> | 39 | lnsgk2+Pl/6+N2/p1pp2p1p/4p2R1/9/2P3P2/P2PPPN1P/4s1g1K/L4+r2L w 2B2SN4P2g 56           |    7 |        3 |
# >> | 40 | l+P1g2+S1l/2sk5/p1ppppngp/6p2/9/6P2/P1+bPPP2P/2+r2S3/+rN2GK1NL w SNbgl4p 56           |    7 |        4 |
# >> | 41 | ln2k3l/1Rs1gsgb1/2pppp3/p5Npp/5PP2/PP2P3P/2PPS4/1Bs2K3/LN3G1+rL w 2Pgnp 56            |    9 |        0 |
# >> | 42 | ln1g1k1nl/1rP5g/p1sp1+P1P1/4p3p/2pS2p1P/1P1P3p1/PGB1PP3/5K3/L+r3G1N+b w S2Psnl 62     |    9 |        1 |
# >> | 43 | l4kb1+R/4gs1+P1/2+Pp2p1n/p3pS2p/9/P1pP2PbP/4PPN2/2+pS1K1s1/L+r3G1NL b GL2Pgnp 59      |    9 |        2 |
# >> | 44 | ln2gs2l/2k1g2P1/2p4p1/P2pS1p1p/9/5pP1P/3PP4/1+r1S1S2B/L+rPKG3L w BPg3n4p 74           |    9 |        3 |
# >> | 45 | ln1gk3l/5p3/p2pp2+R1/2p2+Bp1p/9/P3P4/N+rPP2P1P/2gSKS3/L1+s2G1NL b GNbs5p 65           |    9 |        4 |
# >> | 46 | +P2+Rb1gnl/7k1/n1p1+Bp1pp/p5p2/1p1pP2P1/2+s6/PsNGSPP1P/3KG4/L5RNL b SL3Pg 83          |   11 |        0 |
# >> | 47 | l3+Rpknl/9/4G1pg1/pP+B2Ssp1/1npnP4/4KP2P/P2P4L/2GS4G/LR7 b SN6Pbp 151                 |   11 |        1 |
# >> | 48 | l4rg2/2+B1g1sl1/p2n1kn2/2p1Ppp2/3+R5/1PPP2P2/P1S2PN1P/3GGS3/+p3K3L b SN3Pbl2p 89      |   11 |        2 |
# >> | 49 | ln1g1k1nl/1r2Pgg2/p2p+Bs1pp/2p3n2/7P1/2P1pb2P/PP1P5/1K4Pr1/LN1+p4L w GSP2s2p 114      |   11 |        3 |
# >> | 50 | lnS1B2nl/4G1kn1/pr2pg1p1/6P1p/1Pp1P4/P3+bpG1P/1GS+r5/1KP2P3/LN6L w S4Psp 132          |   11 |        4 |
# >> | 52 | ln1gkg1nl/6+P2/2sppps1p/2p3p2/p8/P1P1P3P/2NP1PP2/3s1KSR1/L1+b2G1NL w R2Pbgp 42        |    3 |        0 |
# >> | 53 | l3kgsnl/9/p1pS+Bp3/7pp/6PP1/9/PPPPPPn1P/1B1GG2+r1/LNS1K3L w RG3Psnp 54                |    3 |        1 |
# >> | 54 | l3k2nl/4g1gb1/1+S1pspp+P1/p1p6/3n4p/2PPR1P2/P2bPP2P/5GS2/LN1K4L w R2Pgsn2p 50         |    3 |        2 |
# >> | 55 | lns+R4l/1p1p5/p1pkppB1p/6p2/1R7/6P1P/P1PPnPS2/2+b1G1g2/L3K1sNL b 2GS3Pnp 51           |    3 |        3 |
# >> | 56 | 1+P1gkg2l/2s3s+P1/3ppp2p/P1p2npp1/l2N1+b3/3KP1P2/N2P1PS1P/2+p1G2R1/L1+r3sNL w Pbgp 58 |    3 |        4 |
# >> | 57 | lnsG5/4g4/prpp1p1pp/1p4p2/4+B3k/2P1P4/P+b1PSP1LP/4K2SL/2G2G1r1 b SP3nl3p 71           |    3 |        5 |
# >> | 58 | l5+R1l/4kS3/p4pnpp/2Pppb3/6p1P/P2s5/NP2+nPPR1/2+bS2GK1/L6NL b 3GSP4p 93               |    3 |        6 |
# >> | 59 | lR5nl/5k1b1/2gp3p1/2s1p1P2/p4N2p/P3PpR2/1PPP1P2P/2G1K2s1/LN6L b GSN2Pbgs2p 83         |    3 |        7 |
# >> | 60 | l1+R5l/2pS5/p2pp+P1pp/2k3p2/2N4P1/PP2R1P1P/2+pPP1N2/2GSG1bs1/LN1K4L b 2GSNPbp 73      |    3 |        8 |
# >> | 61 | lnsg4l/1r1b5/p1pp1+N1+R1/4p3p/9/P3SSk2/NpPPPPg1P/2GK5/L1S4NL b 2Pbg4p 91              |    3 |        9 |
# >> |----+---------------------------------------------------------------------------------------+------+----------|
