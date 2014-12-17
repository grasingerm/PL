#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#define _USE_MATH_DEFINES
#include <math.h>

#define M_PI 3.1415926535897932384626433832795028841

struct vector
{
  unsigned int n_avail;
  unsigned int n_elems;
  double* data;
};

struct vector* vec_alloc (unsigned int size)
{
  struct vector* vec = (struct vector *) malloc (sizeof (struct vector));
  if (vec == NULL) return NULL;

  double* new_d = (double *) malloc (sizeof (double) * size);
  if (new_d == NULL)
  {
    free (vec);
    return NULL;
  }

  vec -> data = new_d;
  vec -> n_avail = size;
  vec -> n_elems = size;

  return vec;
}

void vec_destroy (struct vector* vec)
{
  free (vec -> data);
  free (vec);
}

void vec_resize (struct vector* vec, unsigned int new_size)
{
  if (new_size <= vec -> n_avail)
    vec -> n_elems = new_size;
  else
  {
    free (vec -> data); // do not need to check for NULL here as C std says so
    vec -> data = (double *) malloc (sizeof (double) * new_size);
    if (vec -> data == NULL)
    {
      vec -> n_avail = 0;
      vec -> n_elems = 0;
    }
    else
    {
      vec -> n_avail = new_size;
      vec -> n_elems = new_size;
    }
  }
}

double vec_mag (const struct vector* vec)
{
  unsigned int i;
  double sumsq = 0;

  for (i = 0; i < vec -> n_elems; i++)
    sumsq += (vec -> data [i] * vec -> data [i]);

  return sqrt (sumsq);
}

void vec_hex_mod (struct vector* vec, unsigned int i)
{
  vec -> data [0] = cos (M_PI / 3. * i);
  vec -> data [1] = sin (M_PI / 3. * i);
}

// TODO: make this work for arbitrary size vector
char* vec_to_str (const struct vector* vec, char* buffer, const size_t buffer_sz)
{
  snprintf (buffer, buffer_sz, "(%lf, %lf)", vec -> data[0], vec -> data[1]);
  return buffer;
}

#define N_VECS 6

int main ()
{
  unsigned int i;
  struct vector vecs [N_VECS] = { {0, 0, NULL} };
  char vts_buffer [128];
  const size_t vts_buffer_sz = sizeof (vts_buffer);

  for (i = 0; i < N_VECS; i++)
  {
    assert ( 
      vecs [i] . n_elems == vecs [i] . n_avail &&
      vecs [i] . n_elems == 0 &&
      "all vectors not initialized to size 0"
      );
    vec_resize ((vecs+i), 2);
    assert (vecs [i] . data != NULL && 
      "memory allocation failed during resize");
    assert ( 
      vecs [i] . n_elems == vecs [i] . n_avail &&
      vecs [i] . n_elems == 2 &&
      "all vectors not reinitialized to size 2"
      );
  }

  puts ("Lattice vectors:");
  for (i = 0; i < N_VECS; i++)
  {
    vec_hex_mod ((vecs+i), i+1);
    assert ( abs (vec_mag (vecs+i) - 1.0) < 0.001 && "not a unit vector" );
    printf ("%d, %s\n", i, vec_to_str (vecs+i, vts_buffer, vts_buffer_sz));
  }

  for (i = 0; i < N_VECS; i++)
    free ((vecs+i) -> data);

  return 0;
}
