# alblas
Aarch64/ARMv8 Localized Basic Linear Algebra Subroutine, or Alblas. Similarity to my name is coincidental.

## Background

ARMv8/Aarch64 is poorly documented. In 2018, I pioneered a few assembly classes using Amazon AWS ARM instances, two years before Apple made the jump into ARM. The Hennesy and Patterson textbook uses many examples of linear algebra subroutines to explain assembmly-level optimizations. Due to extensive experience in SIMD and low-level coding, I decided to redo the well known BLAS library, but to optimize it by hand at the assembly level.
