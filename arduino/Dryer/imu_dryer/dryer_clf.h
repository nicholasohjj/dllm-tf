#pragma once
#include <cstdarg>
namespace Eloquent {
    namespace ML {
        namespace Port {
            class RandomForest {
                public:
                    /**
                    * Predict class for features vector
                    */
                    int predict(float *x) {
                        uint8_t votes[2] = { 0 };
                        // tree #1
                        if (x[3] <= 16631.5361328125) {
                            if (x[3] <= 16290.48193359375) {
                                if (x[0] <= 214.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }

                            else {
                                if (x[0] <= -70.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[0] += 1;
                                }
                            }
                        }

                        else {
                            if (x[2] <= -1910.0) {
                                votes[1] += 1;
                            }

                            else {
                                if (x[2] <= -1886.0) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        // tree #2
                        if (x[3] <= 16627.1728515625) {
                            if (x[3] <= 16395.240234375) {
                                if (x[0] <= 526.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }

                            else {
                                if (x[2] <= -1774.0) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        else {
                            if (x[2] <= -2168.0) {
                                votes[1] += 1;
                            }

                            else {
                                if (x[2] <= -2146.0) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        // tree #3
                        if (x[2] <= -2382.0) {
                            if (x[3] <= 16235.4296875) {
                                if (x[3] <= 16195.03955078125) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[0] += 1;
                                }
                            }

                            else {
                                votes[1] += 1;
                            }
                        }

                        else {
                            if (x[2] <= -2082.0) {
                                if (x[0] <= 628.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[0] += 1;
                                }
                            }

                            else {
                                if (x[1] <= 16460.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        // tree #4
                        if (x[2] <= -2346.0) {
                            if (x[0] <= 420.0) {
                                votes[1] += 1;
                            }

                            else {
                                if (x[2] <= -2452.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        else {
                            if (x[2] <= -2102.0) {
                                if (x[0] <= 14.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[0] += 1;
                                }
                            }

                            else {
                                if (x[1] <= 16354.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        // tree #5
                        if (x[1] <= 16090.0) {
                            votes[1] += 1;
                        }

                        else {
                            if (x[1] <= 16396.0) {
                                if (x[2] <= -2082.0) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }

                            else {
                                if (x[1] <= 16468.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        // tree #6
                        if (x[2] <= -2388.0) {
                            if (x[2] <= -2452.0) {
                                votes[1] += 1;
                            }

                            else {
                                if (x[0] <= 844.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        else {
                            if (x[0] <= 1064.0) {
                                if (x[3] <= 16243.80419921875) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[0] += 1;
                                }
                            }

                            else {
                                if (x[3] <= 16415.2333984375) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        // tree #7
                        if (x[0] <= 532.0) {
                            if (x[0] <= 44.0) {
                                if (x[3] <= 16344.2646484375) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }

                            else {
                                if (x[3] <= 16469.1962890625) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        else {
                            if (x[3] <= 16708.02734375) {
                                if (x[1] <= 16134.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[0] += 1;
                                }
                            }

                            else {
                                if (x[3] <= 16849.0458984375) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        // tree #8
                        if (x[1] <= 16410.0) {
                            if (x[1] <= 16146.0) {
                                votes[1] += 1;
                            }

                            else {
                                if (x[0] <= 1532.0) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        else {
                            if (x[1] <= 16468.0) {
                                if (x[0] <= 1106.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }

                            else {
                                votes[1] += 1;
                            }
                        }

                        // tree #9
                        if (x[1] <= 16136.0) {
                            if (x[1] <= 16074.0) {
                                votes[1] += 1;
                            }

                            else {
                                if (x[3] <= 16297.12353515625) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        else {
                            if (x[1] <= 16468.0) {
                                if (x[3] <= 16637.3671875) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }

                            else {
                                if (x[3] <= 16816.5732421875) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        // tree #10
                        if (x[3] <= 16631.5361328125) {
                            if (x[1] <= 16128.0) {
                                votes[1] += 1;
                            }

                            else {
                                if (x[2] <= -1872.0) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        else {
                            if (x[2] <= -1894.0) {
                                votes[1] += 1;
                            }

                            else {
                                if (x[2] <= -1884.0) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        // tree #11
                        if (x[2] <= -2304.0) {
                            if (x[2] <= -2382.0) {
                                votes[1] += 1;
                            }

                            else {
                                if (x[3] <= 16621.0078125) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        else {
                            if (x[2] <= -2110.0) {
                                if (x[1] <= 16088.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[0] += 1;
                                }
                            }

                            else {
                                if (x[0] <= 1340.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        // tree #12
                        if (x[3] <= 16593.2099609375) {
                            if (x[3] <= 16395.240234375) {
                                if (x[3] <= 16195.03955078125) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }

                            else {
                                if (x[0] <= 402.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[0] += 1;
                                }
                            }
                        }

                        else {
                            if (x[1] <= 16610.0) {
                                if (x[2] <= -2156.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }

                            else {
                                votes[1] += 1;
                            }
                        }

                        // tree #13
                        if (x[2] <= -2382.0) {
                            if (x[2] <= -2452.0) {
                                votes[1] += 1;
                            }

                            else {
                                if (x[2] <= -2440.0) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        else {
                            if (x[2] <= -2102.0) {
                                if (x[1] <= 16410.0) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }

                            else {
                                if (x[3] <= 16496.037109375) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        // tree #14
                        if (x[3] <= 16612.513671875) {
                            if (x[1] <= 16136.0) {
                                if (x[1] <= 16090.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }

                            else {
                                if (x[0] <= 666.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[0] += 1;
                                }
                            }
                        }

                        else {
                            if (x[2] <= -2168.0) {
                                votes[1] += 1;
                            }

                            else {
                                if (x[2] <= -2144.0) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        // tree #15
                        if (x[2] <= -2384.0) {
                            if (x[1] <= 16020.0) {
                                if (x[1] <= 16014.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[0] += 1;
                                }
                            }

                            else {
                                votes[1] += 1;
                            }
                        }

                        else {
                            if (x[1] <= 16136.0) {
                                votes[1] += 1;
                            }

                            else {
                                if (x[3] <= 16630.70703125) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        // tree #16
                        if (x[2] <= -2382.0) {
                            if (x[3] <= 16210.1435546875) {
                                if (x[1] <= 15970.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[0] += 1;
                                }
                            }

                            else {
                                votes[1] += 1;
                            }
                        }

                        else {
                            if (x[2] <= -2044.0) {
                                if (x[3] <= 16606.07421875) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }

                            else {
                                if (x[0] <= 1064.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        // tree #17
                        if (x[1] <= 16090.0) {
                            votes[1] += 1;
                        }

                        else {
                            if (x[3] <= 16708.02734375) {
                                if (x[0] <= 20.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[0] += 1;
                                }
                            }

                            else {
                                if (x[1] <= 16612.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        // tree #18
                        if (x[2] <= -2390.0) {
                            if (x[2] <= -2452.0) {
                                votes[1] += 1;
                            }

                            else {
                                if (x[2] <= -2432.0) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        else {
                            if (x[0] <= 1616.0) {
                                if (x[2] <= -2070.0) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }

                            else {
                                votes[1] += 1;
                            }
                        }

                        // tree #19
                        if (x[2] <= -2392.0) {
                            votes[1] += 1;
                        }

                        else {
                            if (x[2] <= -2082.0) {
                                if (x[1] <= 16446.0) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }

                            else {
                                if (x[3] <= 16551.1005859375) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        // tree #20
                        if (x[2] <= -2382.0) {
                            if (x[3] <= 16210.1435546875) {
                                if (x[1] <= 15970.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[0] += 1;
                                }
                            }

                            else {
                                votes[1] += 1;
                            }
                        }

                        else {
                            if (x[2] <= -2086.0) {
                                if (x[3] <= 16596.7333984375) {
                                    votes[0] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }

                            else {
                                if (x[2] <= -1882.0) {
                                    votes[1] += 1;
                                }

                                else {
                                    votes[1] += 1;
                                }
                            }
                        }

                        // return argmax of votes
                        uint8_t classIdx = 0;
                        float maxVotes = votes[0];

                        for (uint8_t i = 1; i < 2; i++) {
                            if (votes[i] > maxVotes) {
                                classIdx = i;
                                maxVotes = votes[i];
                            }
                        }

                        return classIdx;
                    }

                protected:
                };
            }
        }
    }