#include <cstdio>
#include <cstdlib>
#include <cmath>

int main(int argc, char** argv) {
  // double const target = 0.55586;
  // double const target = 0.41684035014589412255106294289287;
  double target = 0.33344448149383127709236412137379;
  if (1 < argc)
    target = atof(argv[1]);

  double minError = 10.0;
  int r1 = 100, r2 = 100;

  for (int i = 1; i < 100; i++) {
    int j = int(0.5 + target * 1e4 / i);
    if (j > 200) continue;

    double error = std::abs(target - i * j * 1e-4);
    if (error < minError || error == minError && i + j < r1 + r2) {
      r1 = i;
      r2 = j;
      minError = error;
    }
  }

  std::printf("target = %.10g\n", target);
  std::printf("result : %dx%d (err = %fe+4)\n", r1, r2, minError * 1e4);
  return 0;
}
