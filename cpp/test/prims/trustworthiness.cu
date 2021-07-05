/*
 * Copyright (c) 2018-2021, NVIDIA CORPORATION.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <gtest/gtest.h>
#include <raft/cudart_utils.h>
#include <iostream>
#include <metrics/trustworthiness_score.cuh>
#include <raft/distance/distance.cuh>
#include <raft/mr/device/allocator.hpp>
#include <vector>
#include "test_utils.h"

namespace MLCommon {
namespace Score {

class TrustworthinessScoreTest : public ::testing::Test {
 protected:
  void basicTest()
  {
    std::vector<float> X = {
      5.6142087,   8.59787,     -4.382763,   -3.6452143,  -5.8816037,  -0.6330313,  4.6920023,
      -0.79210913, 0.6106314,   2.1210914,   5.919943,    -8.43784,    -6.4819884,  0.41001374,
      -6.1052523,  -4.0825715,  -5.314755,   -2.834671,   5.751696,    -6.5012555,  -0.4719201,
      -7.53353,    7.6789393,   -1.4959852,  -5.5977287,  -9.564147,   1.2902534,   3.559834,
      -6.7659483,  8.265964,    4.595404,    9.133477,    -6.1553917,  -6.319754,   -2.9039452,
      4.4150834,   -3.094395,   -4.426273,   9.584571,    -5.64133,    6.6209483,   7.4044604,
      3.9620576,   5.639907,    10.33007,    -0.8792053,  5.143776,    -7.464049,   1.2448754,
      -5.6300974,  5.4518576,   4.119535,    6.749645,    7.627064,    -7.2298336,  1.9681473,
      -6.9083176,  6.404673,    0.07186685,  9.0994835,   8.51037,     -8.986389,   0.40534487,
      2.115397,    4.086756,    1.2284287,   -2.6272132,  0.06527536,  -9.587425,   -7.206078,
      7.864875,    7.4397306,   -6.9233336,  -2.6643622,  3.3466153,   7.0408177,   -3.6069896,
      -9.971769,   4.4075623,   7.9063697,   2.559074,    4.323717,    1.6867131,   -1.1576937,
      -9.893141,   -3.251416,   -7.4889135,  -4.0588717,  -2.73338,    -7.4852257,  3.4460473,
      9.759119,    -5.4680476,  -4.722435,   -8.032619,   -1.4598992,  4.227361,    3.135568,
      1.1950601,   1.1982028,   6.998856,    -6.131138,   -6.6921015,  0.5361224,   -7.1213965,
      -5.6104236,  -7.2212887,  -2.2710054,  8.544764,    -6.0254574,  1.4582269,   -5.5587835,
      8.031556,    -0.26328218, -5.2591386,  -9.262641,   2.8691363,   5.299787,    -9.209455,
      8.523085,    5.180329,    10.655528,   -5.7171874,  -6.7739563,  -3.6306462,  4.067106,
      -1.5912259,  -3.2345476,  8.042973,    -3.6364832,  4.1242137,   9.886953,    5.4743724,
      6.3058076,   9.369645,    -0.5175337,  4.9859877,   -7.879498,   1.358422,    -4.147944,
      3.8984218,   5.894656,    6.4903927,   8.702036,    -8.023722,   2.802145,    -7.748032,
      5.8461113,   -0.34215945, 11.298865,   1.4107164,   -9.949621,   -1.6257563,  -10.655836,
      2.4528909,   1.1570255,   5.170669,    2.8398793,   7.1838694,   9.088459,    2.631155,
      3.964414,    2.8769252,   0.04198391,  -0.16993195, 3.6747139,   -2.8377378,  6.1782537,
      10.759618,   -4.5642614,  -8.522967,   0.8614642,   6.623416,    -1.029324,   5.5488334,
      -7.804511,   2.128833,    7.9042315,   7.789576,    -2.7944536,  0.72271067,  -10.511495,
      -0.78634536, -10.661714,  2.9376361,   1.9148129,   6.22859,     0.26264945,  8.028384,
      6.8743043,   0.9351067,   7.0690722,   4.2846055,   1.4134506,   -0.18144785, 5.2778087,
      -1.7140163,  9.217541,    8.602799,    -2.6537218,  -7.8377395,  1.1244944,   5.4540544,
      -0.38506773, 3.9885726,   -10.76455,   1.4440702,   9.136163,    6.664117,    -5.7046547,
      8.038592,    -9.229767,   -0.2799413,  3.6064725,   4.187257,    1.0516582,   -2.0707326,
      -0.7615968,  -8.561018,   -3.7831352,  10.300297,   5.332594,    -6.5880876,  -4.2508664,
      1.7985519,   5.7226253,   -4.1223383,  -9.6697855,  1.4885283,   7.524974,    1.7206005,
      4.890457,    3.7264557,   0.4428284,   -9.922455,   -4.250455,   -6.4410596,  -2.107994,
      -1.4109765,  -6.1325397,  0.32883006,  6.0489736,   7.7257385,   -8.281174,   1.0129383,
      -10.792166,  8.378851,    10.802716,   9.848448,    -9.188757,   1.3151443,   1.9971865,
      -2.521849,   4.3268294,   -7.775683,   -2.2902298,  3.0824065,   -7.17559,    9.6100855,
      7.3965735,   -10.476525,  5.895973,    -3.6974669,  -7.6688933,  1.7354839,   -7.4045196,
      -1.7992063,  -4.0394845,  5.2471714,   -2.250571,   2.528036,    -8.343515,   -2.2374575,
      -10.019771,  0.73371273,  3.1853926,   2.7994921,   2.6637669,   7.620401,    7.515571,
      0.68636256,  5.834537,    4.650282,    -1.0362619,  0.4461701,   3.7870514,   -4.1340904,
      7.202998,    9.736904,    -3.005512,   -8.920467,   1.1228397,   6.2598724,   1.2812365,
      4.5442104,   -8.791537,   0.92113096,  8.464749,    8.359035,    -4.3923397,  1.2252625,
      -10.1986475, -1.4409319,  -10.013967,  3.9071581,   1.683064,    4.877419,    1.6570637,
      9.559105,    7.3546534,   0.36635467,  5.220211,    4.6303267,   0.6601065,   0.16149978,
      3.8818731,   -3.4438233,  8.42085,     8.659159,    -3.0935583,  -8.039611,   2.3060374,
      5.134666,    1.0458113,   6.0190983,   -9.143728,   0.99048865,  9.210842,    6.670241,
      -5.9614363,  0.8747396,   7.078824,    8.067469,    -10.314754,  0.45977542,  -9.28306,
      9.1838665,   9.318644,    7.189082,    -11.092555,  1.0320464,   3.882163,    0.10953151,
      7.9029684,   -6.9068265,  -1.3526366,  5.3996363,   -8.430931,   11.452577,   6.39663,
      -11.090514,  4.6662245,   -3.1268113,  -8.357452,   2.2276728,   -10.357126,  -0.9291848,
      -3.4193344,  3.1289792,   -2.5030103,  6.772719,    11.457757,   -4.2125936,  -6.684548,
      -4.7611327,  3.6960156,   -2.3030636,  -3.0591488,  10.452471,   -4.1267314,  5.66614,
      7.501461,    5.072407,    6.636537,    8.990381,    -0.2559256,  4.737867,    -6.2149944,
      2.535682,    -5.5484023,  5.7113924,   3.4742818,   7.9915137,   7.0052586,   -7.156467,
      1.4354781,   -8.286235,   5.7523417,   -2.4175215,  9.678009,    0.05066403,  -9.645226,
      -2.2658763,  -9.518178,   4.493372,    2.3232365,   2.1659086,   0.42507997,  8.360246,
      8.23535,     2.6878164,   5.236947,    3.4924245,   -0.6089895,  0.8884741,   4.359464,
      -4.6073823,  7.83441,     8.958755,    -3.4690795,  -9.182282,   1.2478025,   5.6311107,
      -1.2408862,  3.6316886,   -8.684654,   2.1078515,   7.2813864,   7.9265943,   -3.6135032,
      0.4571511,   8.493568,    10.496853,   -7.432897,   0.8625995,   -9.607528,   7.2899456,
      8.83158,     8.908199,    -10.300263,  1.1451302,   3.7871468,   -0.97040755, 5.7664757,
      -8.9688,     -2.146672,   5.9641485,   -6.2908535,  10.126465,   6.1553903,   -12.066902,
      6.301596,    -5.0419583,  -8.228695,   2.4879954,   -8.918582,   -3.7434099,  -4.1593685,
      3.7431836,   -1.1704745,  0.5524103,   9.109399,    9.571567,    -11.209955,  1.2462777,
      -9.554555,   9.091726,    11.477966,   7.630937,    -10.450911,  1.9205878,   5.358983,
      -0.44546837, 6.7611346,   -9.74753,    -0.5939732,  3.8892255,   -6.437991,   10.294727,
      5.6723895,   -10.7883,    6.192348,    -5.293862,   -10.811491,  1.0194173,   -7.074576,
      -3.192368,   -2.5231771,  4.2791643,   -0.53309685, 0.501366,    9.636625,    7.710316,
      -6.4219728,  1.0975566,   -8.218886,   6.9011984,   9.873679,    8.903804,    -9.316832,
      1.2404599,   4.9039655,   1.2272617,   4.541515,    -5.2753224,  -3.2196746,  3.1303136,
      -7.285681,   9.041425,    5.6417427,   -9.93667,    5.7548947,   -5.113397,   -8.544622,
      4.182665,    -7.7709813,  -3.2810235,  -3.312072,   3.8900535,   -2.0604856,  6.709082,
      -8.461194,   1.2666026,   4.8770437,   2.6955879,   3.0340345,   -1.1614609,  -3.536341,
      -7.090382,   -5.36146,    9.072544,    6.4554095,   -4.4728956,  -1.88395,    3.1095037,
      8.782348,    -3.316743,   -8.65248,    1.6802986,   8.186188,    2.1783829,   4.931278,
      4.158475,    1.4033595,   -11.320101,  -3.7084908,  -6.740436,   -2.5555193,  -1.0451177,
      -6.5569925,  0.82810307,  8.505919,    8.332857,    -9.488569,   -0.21588463, -8.056692,
      8.493993,    7.6401625,   8.812983,    -9.377281,   2.4369764,   3.1766508,   0.6300803,
      5.6666765,   -7.913654,   -0.42301777, 4.506412,    -7.8954244,  10.904591,   5.042256,
      -9.626183,   8.347351,    -3.605006,   -7.923387,   1.1024277,   -8.705793,   -2.5151258,
      -2.5066147,  4.0515003,   -2.060757,   6.2635093,   8.286584,    -6.0509276,  -6.76452,
      -3.1158175,  1.6578803,   -1.4608748,  -1.24211,    8.151246,    -4.2970877,  6.093071,
      7.4911637,   4.51018,     4.8425875,   9.211085,    -2.4386222,  4.5830803,   -5.6079445,
      2.3713675,   -4.0707507,  3.1787417,   5.462342,    6.915912,    6.3928423,   -7.2970796,
      5.0112796,   -9.140893,   4.9990606,   0.38391754,  7.7088532,   1.9340848,   8.18833,
      8.16617,     -9.42086,    -0.3388326,  -9.659727,   8.243045,    8.099073,    8.439428,
      -7.038694,   2.1077902,   3.3866816,   -1.9975324,  7.4972878,   -7.2525196,  -1.553731,
      4.08758,     -6.6922374,  9.50525,     4.026735,    -9.243538,   7.2740564,   -3.9319072,
      -6.3228955,  1.6693478,   -7.923119,   -3.7423058,  -2.2813146,  5.3469067,   -1.8285407,
      3.3118162,   8.826356,    -4.4641976,  -6.4751124,  -9.200089,   -2.519147,   4.225298,
      2.4105988,   -0.4344186,  0.53441775,  5.2836394,   -8.2816105,  -4.996147,   -1.6870759,
      -7.8543897,  -3.9788852,  -7.0346904,  -3.1289773,  7.4567637,   -5.6227813,  1.0709786,
      -8.866012,   8.427324,    -1.1755563,  -5.789216,   -8.197835,   5.3342214,   6.0646234,
      -6.8975716,  7.717031,    3.480355,    8.312151,    -3.6645212,  -3.0976524,  -8.090359,
      -1.9176173,  2.4257212,   1.9700835,   0.4098958,   2.1341088,   7.652741,    -9.9595585,
      -5.989757,   0.10119354,  -7.935407,   -5.792786,   -5.22783,    -4.318978,   5.414037,
      -6.4621663,  1.670883,    -6.9224787,  8.696932,    -2.0214002,  -6.6681314,  -8.326418,
      4.9049683,   5.4442496,   -6.403739,   7.5822453,   7.0972915,   -9.072851,   -0.23897195,
      1.7662339,   5.3096304,   1.983179,    -2.222645,   -0.34700772, -9.094717,   -6.107907,
      9.525174,    8.1550665,   -5.6940084,  -4.1636486,  1.7360662,   8.528821,    -3.7299833,
      -9.341266,   2.608542,    9.108706,    0.7978509,   4.2488184,   2.454484,    0.9446999,
      -10.106636,  -3.8973773,  -6.6566644,  -4.5647273,  -0.99837756, -6.568582,   9.324853,
      -7.9020953,  2.0910501,   2.2896829,   1.6790711,   1.3159255,   -3.5258796,  1.8898442,
      -8.105812,   -4.924962,   8.771129,    7.1202874,   -5.991957,   -3.4106019,  2.4450088,
      7.796387,    -3.055946,   -7.8971434,  1.9856719,   9.001636,    1.8511922,   3.019749,
      3.1227696,   0.4822102,   -10.021213,  -3.530504,   -6.225959,   -3.0029628,  -1.7881511,
      -7.3879776,  1.3925704,   9.499782,    -3.7318087,  -3.7074296,  -7.7466836,  -1.5284524,
      4.0535855,   3.112011,    0.10340207,  -0.5429599,  6.67026,     -9.155924,   -4.924038,
      0.64248866,  -10.0103655, -3.2742946,  -4.850029,   -3.6707063,  8.586258,    -5.855605,
      4.906918,    -6.7813993,  7.9938135,   -2.5473144,  -5.688948,   -7.822478,   2.1421318,
      4.66659,     -9.701272,   9.549149,    0.8998125,   -8.651497,   -0.56899565, -8.639817,
      2.3088377,   2.1264515,   3.2764478,   2.341989,    8.594338,    8.630639,    2.8440373,
      6.2043204,   4.433932,    0.6320018,   -1.8179281,  5.09452,     -1.5741565,  8.153934,
      8.744339,    -3.6945698,  -8.883078,   1.5329908,   5.2745943,   0.44716078,  4.8809066,
      -7.9594903,  1.134374,    9.233994,    6.5528665,   -4.520542,   9.477355,    -8.622195,
      -0.23191702, 2.0485356,   3.9379985,   1.5916302,   -1.4516805,  -0.0843819,  -7.8554378,
      -5.88308,    7.999766,    6.2572145,   -5.585321,   -4.0097756,  0.42382592,  6.160884,
      -3.631315,   -8.333449,   2.770595,    7.8495173,   3.3331623,   4.940415,    3.6207345,
      -0.037517,   -11.034698,  -3.185103,   -6.614664,   -3.2177854,  -2.0792234,  -6.8879867,
      7.821685,    -8.455084,   1.0784642,   4.0033927,   2.7343264,   2.6052725,   -4.1224284,
      -0.89305353, -6.8267674,  -4.9715133,  8.880253,    5.6994023,   -5.9695024,  -4.9181266,
      1.3017995,   7.972617,    -3.9452884,  -10.424556,  2.4504194,   6.21529,     0.93840516,
      4.2070026,   6.159839,    0.91979957,  -8.706724,   -4.317946,   -6.6823545,  -3.0388,
      -2.464262,   -7.3716645,  1.3926703,   6.544412,    -5.6251183,  -5.122411,   -8.622049,
      -2.3905911,  3.9138813,   1.9779967,   -0.05011125, 0.13310997,  7.229751,    -9.742043,
      -8.08724,    1.2426697,   -7.9230795,  -3.3162494,  -7.129571,   -3.5488048,  7.4701195,
      -5.2357526,  0.5917681,   -6.272206,   6.342328,    -2.909731,   -4.991607,   -8.845513,
      3.3228495,   7.033246,    -7.8180246,  8.214469,    6.3910093,   9.185153,    -6.20472,
      -7.713809,   -3.8481297,  3.5579286,   0.7078448,   -3.2893546,  7.384514,    -4.448121,
      3.0104196,   9.492943,    8.024847,    4.9114385,   9.965594,    -3.014036,   5.182494,
      -5.8806014,  2.5312455,   -5.9926524,  4.474469,    6.3717875,   6.993105,    6.493093,
      -8.935534,   3.004074,    -8.055647,   8.315765,    -1.3026813,  8.250377,    0.02606229,
      6.8508425,   9.655665,    -7.0116496,  -0.41060972, -10.049198,  7.897801,    6.7791023,
      8.3362,      -9.821014,   2.491157,    3.5160472,   -1.6228812,  7.398063,    -8.769123,
      -3.1743705,  3.2827861,   -6.497855,   10.831924,   5.2761307,   -9.704417,   4.3817043,
      -3.9841619,  -8.111647,   1.1883026,   -8.115312,   -2.9240117,  -5.8879666,  4.20928,
      -0.3587938,  6.935672,    -10.177582,  0.48819053,  3.1250648,   2.9306343,   3.082544,
      -3.477687,   -1.3768549,  -7.4922366,  -3.756631,   10.039836,   3.6670392,   -5.9761434,
      -4.4728765,  3.244255,    7.027899,    -2.3806512,  -10.4100685, 1.605716,    7.7953773,
      0.5408159,   1.7156523,   3.824097,    -1.0604783,  -10.142124,  -5.246805,   -6.5283823,
      -4.579547,   -2.42714,    -6.709197,   2.7782338,   7.33353,     -6.454507,   -2.9929368,
      -7.8362985,  -2.695445,   2.4900775,   1.6682367,   0.4641757,   -1.0495365,  6.9631333,
      -9.291356,   -8.23837,    -0.34263706, -8.275113,   -2.8454232,  -5.0864096,  -2.681942,
      7.5450225,   -6.2517986,  0.06810654,  -6.470652,   4.9042645,   -1.8369255,  -6.6937943,
      -7.9625087,  2.8510258,   6.180508,    -8.282598,   7.919079,    1.4897474,   6.7217417,
      -4.2459426,  -4.114431,   -8.375707,   -2.143264,   5.6972933,   1.5574739,   0.39375135,
      1.7930849,   5.1737595,   -7.826241,   -5.160268,   -0.80433255, -7.839536,   -5.2620406,
      -5.4643164,  -3.185536,   6.620315,    -7.065227,   1.0524757,   -6.125088,   5.7126627,
      -1.6161644,  -3.852159,   -9.164279,   2.7005782,   5.946544,    -8.468236,   8.2145405,
      1.1035942,   6.590157,    -4.0461283,  -4.8090615,  -7.6702685,  -2.1121511,  5.1147075,
      1.6128504,   2.0064135,   1.0544407,   6.0038295,   -7.8282537,  -4.801278,   0.32349443,
      -8.0649805,  -4.372714,   -5.61336,    -5.21394,    8.176595,    -5.4753284,  1.7800134,
      -8.267283,   7.2133374,   -0.16594432, -6.317046,   -9.490406,   4.1261597,   5.473317,
      -7.7551675,  7.007468,    7.478628,    -8.801905,   0.10975724,  3.5478222,   4.797803,
      1.3825226,   -3.357369,   0.99262005,  -6.94877,    -5.4781394,  9.632604,    5.7492557,
      -5.9014316,  -3.1632116,  2.340859,    8.708098,    -3.1255999,  -8.848661,   4.5612836,
      8.455157,    0.73460823,  4.112301,    4.392744,    -0.30759293, -6.8036823,  -3.0331545,
      -8.269506,   -2.82415,    -0.9411246,  -5.993506,   2.1618164,   -8.716055,   -0.7432543,
      -10.255819,  3.095418,    2.5131428,   4.752442,    0.9907621,   7.8279433,   7.85814,
      0.50430876,  5.2840405,   4.457291,    0.03330028,  -0.40692952, 3.9244103,   -2.117118,
      7.6977615,   8.759009,    -4.2157164,  -9.136053,   3.247858,    4.668686,    0.76162136,
      5.3833632,   -9.231471,   0.44309422,  8.380872,    6.7211227,   -3.091507,   2.173508,
      -9.038242,   -1.3666698,  -9.819077,   0.37825826,  2.3898845,   4.2440815,   1.9161536,
      7.24787,     6.9124637,   1.6238527,   5.1140285,   3.1935842,   1.02845,     -1.1273454,
      5.638998,    -2.497932,   8.342559,    8.586319,    -2.9069402,  -7.6387944,  3.5975037,
      4.4115705,   0.41506064,  4.9078383,   -9.68327,    1.8159529,   9.744613,    8.40622,
      -4.495336,   9.244892,    -8.789869,   1.3158468,   4.018167,    3.3922846,   2.652022,
      -2.7495477,  0.2528986,   -8.268324,   -6.004913,   10.428784,   6.6580734,   -5.537176,
      -1.7177434,  2.7504628,   6.7735,      -2.4454272,  -9.998361,   2.9483433,   6.8266654,
      2.3787718,   4.472637,    2.5871701,   0.7355365,   -7.7027745,  -4.1879907,  -7.172832,
      -4.1843605,  -0.03646783, -5.419406,   6.958486,    11.011111,   -7.1821184,  -7.956423,
      -3.408451,   4.6850276,   -2.348787,   -4.398289,   6.9787564,   -3.8324208,  5.967827,
      8.433518,    4.660108,    5.5657144,   9.964243,    -1.3515275,  6.404833,    -6.4805903,
      2.4379845,   -6.0816774,  1.752272,    5.3771873,   6.9613523,   6.9788294,   -6.3894596,
      3.7521114,   -6.8034263,  6.4458385,   -0.7233525,  10.512529,   4.362273,    9.231461,
      -6.3382263,  -7.659,      -3.461823,   4.71463,     0.17817476,  -3.685746,   7.2962036,
      -4.6489477,  5.218017,    11.546999,   4.7218375,   6.8498397,   9.281103,    -3.900459,
      6.844054,    -7.0886965,  -0.05019227, -8.233724,   5.5808983,   6.374517,    8.321048,
      7.969449,    -7.3478637,  1.4917561,   -8.003144,   4.780668,    -1.1981848,  7.753739,
      2.0260844,   -8.880096,   -3.4258451,  -7.141975,   1.9637157,   1.814725,    5.311151,
      1.4831505,   7.8483663,   7.257948,    1.395786,    6.417756,    5.376912,    0.59505713,
      0.00062552,  3.6634305,   -4.159713,   7.3571978,   10.966816,   -2.5419605,  -8.466229,
      1.904205,    5.6338267,   -0.52567476, 5.59736,     -8.361799,   0.5009981,   8.460681,
      7.3891273,   -3.5272243,  5.0552278,   9.921456,    -7.69693,    -7.286378,   -1.9198836,
      3.1666567,   -2.5832257,  -2.2445817,  9.888111,    -5.076563,   5.677401,    7.497946,
      5.662994,    5.414262,    8.566503,    -2.5530663,  7.1032815,   -6.0612082,  1.3419591,
      -4.9595256,  4.3377542,   4.3790717,   6.793512,    8.383502,    -7.1278043,  3.3240774,
      -9.379446,   6.838661,    -0.81241214, 8.694813,    0.79141915,  7.632467,    8.575382,
      -8.533798,   0.28954387,  -7.5675836,  5.8653326,   8.97235,     7.1649346,   -10.575289,
      0.9359381,   5.02381,     -0.5609511,  5.543464,    -7.69131,    -2.1792977,  2.4729247,
      -6.1917787,  10.373678,   7.6549597,   -8.809486,   5.5657206,   -3.3169382,  -8.042887,
      2.0874746,   -7.079005,   -3.33398,    -3.6843317,  4.0172358,   -2.0754814,  1.1726758,
      7.4618697,   6.9483604,   -8.469206,   0.7401797,   -10.318176,  8.384557,    10.5476265,
      9.146971,    -9.250223,   0.6290606,   4.4941425,   -0.7514017,  7.2271705,   -8.309598,
      -1.4761636,  4.0140634,   -6.021102,   9.132852,    5.6610966,   -11.249811,  8.359293,
      -1.9445792,  -7.7393436,  -0.3931331,  -8.824441,   -2.5995944,  -2.5714035,  4.140213,
      -3.6863053,  5.517265,    9.020411,    -4.9286127,  -7.871219,   -3.7446704,  2.5179656,
      -1.4543481,  -2.2703636,  7.010597,    -3.6436229,  6.753862,    7.4129915,   7.1406755,
      5.653706,    9.5445175,   0.15698843,  4.761813,    -7.698002,   1.6870106,   -4.5410123,
      4.171763,    5.3747005,   6.341021,    7.456738,    -8.231657,   2.763487,    -9.208167,
      6.676799,    -1.1957736,  10.062605,   4.0975976,   7.312957,    -2.4981596,  -2.9658387,
      -8.150425,   -2.1075552,  2.64375,     1.6636052,   1.1483809,   0.09276015,  5.8556347,
      -7.8481026,  -5.9913163,  -0.02840613, -9.937289,   -1.0486673,  -5.2340155,  -3.83912,
      7.7165728,   -8.409944,   0.80863273,  -6.9119215,  7.5712357,   0.36031485,  -6.056131,
      -8.470033,   1.8678337,   3.0121377,   -7.3096333,  8.205484,    5.262654,    8.774514,
      -4.7603083,  -7.2096143,  -4.437014,   3.6080024,   -1.624254,   -4.2787876,  8.880863,
      -4.8984556,  5.1782074,   9.944454,    3.911282,    3.5396595,   8.867042,    -1.2006199,
      5.393288,    -5.6455317,  0.7829499,   -4.0338907,  2.479272,    6.5080743,   8.582535,
      7.0097537,   -6.9823785,  3.984318,    -7.225381,   5.3135114,   -1.0391048,  8.951443,
      -0.70119005, -8.510742,   -0.42949116, -10.9224825, 2.8176029,   1.6800792,   5.778404,
      1.7269998,   7.1975236,   7.7258267,   2.7632928,   5.3399253,   3.4650044,   0.01971426,
      -1.6468811,  4.114996,    -1.5110453,  6.8689218,   8.269899,    -3.1568048,  -7.0344677,
      1.2911975,   5.950357,    0.19028673,  4.657226,    -8.199647,   2.246055,    8.989509,
      5.3101015,   -4.2400866};

    std::vector<float> X_embedded = {
      -0.41849962, -0.53906363, 0.46958843,  -0.35832694, -0.23779503, -0.29751351, -0.01072748,
      -0.21353109, -0.54769957, -0.55086273, 0.37093949,  -0.12714292, -0.06639574, -0.36098689,
      -0.13060696, -0.07362658, -1.01205945, -0.39285606, 0.2864089,   -0.32031146, -0.19595343,
      0.08900568,  -0.04813879, -0.06563424, -0.42655188, -0.69014251, 0.51459783,  -0.1942696,
      -0.07767916, -0.6119386,  0.04813685,  -0.22557008, -0.56890118, -0.60293794, 0.43429622,
      -0.09240723, -0.00624062, -0.25800395, -0.1886092,  0.01655941,  -0.01961523, -0.14147359,
      0.41414487,  -0.8512944,  -0.61199242, -0.18586016, 0.14024924,  -0.41635606, -0.02890144,
      0.1065347,   0.39700791,  -1.14060664, -0.95313865, 0.14416681,  0.17306046,  -0.53189689,
      -0.98987544, -0.67918193, 0.41787854,  -0.20878236, -0.06612862, 0.03502904,  -0.03765266,
      -0.0980606,  -0.00971657, 0.29432917,  0.36575687,  -1.1645509,  -0.89094597, 0.03718805,
      0.2310573,   -0.38345811, -0.10401925, -0.10653082, 0.38469055,  -0.88302094, -0.80197543,
      0.03548668,  0.02775662,  -0.54374295, 0.03379983,  0.00923623,  0.29320273,  -1.05263519,
      -0.93360096, 0.03778313,  0.12360487,  -0.56437284, 0.0644429,   0.33432651,  0.36450726,
      -1.22978747, -0.83822101, -0.18796451, 0.34888434,  -0.3801491,  -0.45327303, -0.59747899,
      0.39697698,  -0.15616602, -0.06159166, -0.40301991, -0.11725303, -0.11913263, -0.12406619,
      -0.11227967, 0.43083835,  -0.90535849, -0.81646025, 0.10012121,  -0.0141237,  -0.63747931,
      0.04805023,  0.34190539,  0.50725192,  -1.17861414, -0.74641538, -0.09333111, 0.27992678,
      -0.56214809, 0.04970971,  0.36249384,  0.57705611,  -1.16913795, -0.69849908, 0.10957897,
      0.27983218,  -0.62088525, 0.0410459,   0.23973398,  0.40960434,  -1.14183664, -0.83321381,
      0.02149482,  0.21720445,  -0.49869928, -0.95655465, -0.51680422, 0.45761383,  -0.08351214,
      -0.12151554, 0.00819737,  -0.20813803, -0.01055793, 0.25319234,  0.36154974,  0.1822421,
      -1.15837133, -0.92209691, -0.0501582,  0.08535917,  -0.54003763, -1.08675635, -1.04009593,
      0.09408128,  0.07009826,  -0.01762833, -0.19180447, -0.18029785, -0.20342001, 0.04034991,
      0.1814747,   0.36906669,  -1.13532007, -0.8852452,  0.0782818,   0.16825101,  -0.50301319,
      -0.29128098, -0.65341312, 0.51484352,  -0.38758236, -0.22531103, -0.55021971, 0.10804344,
      -0.3521522,  -0.38849035, -0.74110794, 0.53761131,  -0.25142813, -0.1118066,  -0.47453368,
      0.06347904,  -0.23796193, -1.02682328, -0.47594091, 0.39515916,  -0.2782529,  -0.16566519,
      0.08063579,  0.00810116,  -0.06213913, -1.059654,   -0.62496334, 0.53698546,  -0.11806234,
      0.00356161,  0.11513405,  -0.14213292, 0.04102662,  -0.36622161, -0.73686272, 0.48323864,
      -0.27338892, -0.14203401, -0.41736352, 0.03332564,  -0.21907479, -0.06396769, 0.01831361,
      0.46263444,  -1.01878166, -0.86486858, 0.17622118,  -0.01249686, -0.74530888, -0.9354887,
      -0.5027945,  0.38170099,  -0.15547098, 0.00677824,  -0.04677663, -0.13541745, 0.07253501,
      -0.97933143, -0.58001202, 0.48235369,  -0.18836913, -0.02430783, 0.07572441,  -0.08101331,
      0.00630076,  -0.16881248, -0.67989182, 0.46083611,  -0.43910736, -0.29321918, -0.38735861,
      0.07669903,  -0.29749861, -0.40047669, -0.56722462, 0.33168188,  -0.13118173, -0.06672747,
      -0.56856316, -0.26269144, -0.14236671, 0.10651901,  0.4962585,   0.38848072,  -1.06653547,
      -0.64079332, -0.47378591, 0.43195483,  -0.04856951, -0.9840439,  -0.70610428, 0.34028092,
      -0.2089237,  -0.05382041, 0.01625874,  -0.02080803, -0.12535211, -0.04146428, -1.24533033,
      0.48944879,  0.0578458,   0.26708388,  -0.90321028, 0.35377088,  -0.36791429, -0.35382384,
      -0.52748734, 0.42854419,  -0.31744713, -0.19174226, -0.39073724, -0.03258846, -0.19978228,
      -0.36185205, -0.57412046, 0.43681973,  -0.25414538, -0.12904905, -0.46334973, -0.03123853,
      -0.11303604, -0.87073672, -0.45441297, 0.41825858,  -0.25303507, -0.21845073, 0.10248682,
      -0.11045569, -0.10002795, -0.00572806, 0.16519061,  0.42651513,  -1.11417019, -0.83789682,
      0.02995787,  0.16843079,  -0.53874511, 0.03056994,  0.17877036,  0.49632853,  -1.03276777,
      -0.74778616, -0.03971953, 0.10907949,  -0.67385727, -0.9523471,  -0.56550741, 0.40409449,
      -0.2703723,  -0.10175014, 0.13605487,  -0.06306008, -0.01768126, -0.4749442,  -0.56964815,
      0.39389887,  -0.19248079, -0.04161081, -0.38728487, -0.20341556, -0.12656988, -0.35949609,
      -0.46137866, 0.28798422,  -0.06603147, -0.04363992, -0.60343552, -0.23565227, -0.10242701,
      -0.06792886, 0.09689897,  0.33259571,  -0.98854214, -0.84444433, 0.00673901,  0.13457057,
      -0.43145794, -0.51500046, -0.50821936, 0.38000089,  0.0132636,   0.0580942,   -0.40157595,
      -0.11967677, 0.02549113,  -0.10350953, 0.22918226,  0.40411913,  -1.05619383, -0.71218503,
      -0.02197581, 0.26422262,  -0.34765676, 0.06601537,  0.21712676,  0.34723559,  -1.20982027,
      -0.95646334, 0.00793948,  0.27620381,  -0.43475035, -0.67326003, -0.6137197,  0.43724492,
      -0.17666136, -0.06591748, -0.18937394, -0.07400128, -0.06881691, -0.5201112,  -0.61088628,
      0.4225319,   -0.18969463, -0.06921366, -0.33993208, -0.06990873, -0.10288513, -0.70659858,
      -0.56003648, 0.46628812,  -0.16090363, -0.0185108,  -0.1431348,  -0.1128775,  -0.0078648,
      -0.02323332, 0.04292452,  0.39291084,  -0.94897962, -0.63863206, -0.16546988, 0.23698957,
      -0.30633628};

    raft::handle_t handle;

    cudaStream_t stream = handle.get_stream();
    auto allocator      = handle.get_device_allocator();

    float* d_X          = (float*)allocator->allocate(X.size() * sizeof(float), stream);
    float* d_X_embedded = (float*)allocator->allocate(X_embedded.size() * sizeof(float), stream);

    raft::update_device(d_X, X.data(), X.size(), stream);
    raft::update_device(d_X_embedded, X_embedded.data(), X_embedded.size(), stream);

    // euclidean test
    score = trustworthiness_score<float, raft::distance::DistanceType::L2SqrtUnexpanded>(
      handle, d_X, d_X_embedded, 50, 30, 8, 5);

    allocator->deallocate(d_X, X.size() * sizeof(float), stream);
    allocator->deallocate(d_X_embedded, X_embedded.size() * sizeof(float), stream);
  }

  void SetUp() override { basicTest(); }

  void TearDown() override {}

 protected:
  double score;
  std::shared_ptr<raft::mr::device::allocator> allocator;
};

typedef TrustworthinessScoreTest TrustworthinessScoreTestF;
TEST_F(TrustworthinessScoreTestF, Result) { ASSERT_TRUE(0.9375 < score && score < 0.9379); }
};  // namespace Score
};  // namespace MLCommon
