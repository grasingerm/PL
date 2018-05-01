#include <cmath>
#include "gtest/gtest.h"

using namespace std;

TEST(SquareRootTest, PositiveNos) {
  EXPECT_EQ(18.0, sqrt(324.0));
  EXPECT_EQ(25.4, sqrt(645.16));
  EXPECT_EQ(50.3321, sqrt(2533.310224));
}

TEST(SquareRootTest, Zero) {
  ASSERT_EQ(0.0, sqrt(0.0));
}

int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
