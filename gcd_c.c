// Demonstration program for Greatest Common Divisor (GCD)
// using recursive Euclid method
//
// Compile this program:
//  unix>  make
// Run this program:
//  unix>  ./gcd

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

#include "gcd.h"

// Global values for random number generator.
// Initialize the random number generator with fixed values
// for demonstration purposes.
uint32_t m_w = 50000;
uint32_t m_z = 60000;

int main()
{
  uint32_t a, b;

  for(int i=0; i<10; i++)
    {
      a = random_in_range(1,100000);
      b = random_in_range(1,100000);
  printf("%d\n%d\n", a,b);

     // printf("GCD(%d,%d) = %d\n", a, b, gcd(a, b));
    }
  return 0;
}

// Find greatest common divisor (GCD)
// of two numbers (a, b) using recursive Euclid method
uint32_t gcd(uint32_t a, uint32_t b)
{
  if ((a % b) == 0)
    return b; 

  return gcd(b, a % b);
}


// Generate random number in range [low, high]
// (i.e. including low and high)
uint32_t random_in_range(uint32_t low, uint32_t high)
{
  uint32_t range = high-low+1;
  uint32_t rand_num = get_random();

  return (rand_num % range) + low;
}


// Generate random 32-bit unsigned number
// based on multiply-with-carry method shown
// at http://en.wikipedia.org/wiki/Random_number_generation
uint32_t get_random()
{
  uint32_t result;
  
  //printf("%d\n",(m_z >>16));
  m_z = 36969 * (m_z & 65535) + (m_z >> 16);
  m_w = 18000 * (m_w & 65535) + (m_w >> 16);
  result = (m_z << 16) + m_w;  /* 32-bit result */
  return result;
}