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

typedef enum codes { LIN_SUCCESS, LIN_DIM_ERROR } lin_err_t;

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

void vec_zero (struct vector* vec)
{
  unsigned int i;
  for (i = 0; i < vec -> n_elems; i++)
    vec -> data [i] = 0;
}

lin_err_t vec_add2 (const struct vector* u, const struct vector* v, 
  struct vector* result)
{
  unsigned int i;

  if (u -> n_elems != v -> n_elems || u -> n_elems != result -> n_elems)
    return LIN_DIM_ERROR;

  vec_zero (result);

  for (i = 0; i < u -> n_elems; i++)
    result -> data [i] = u -> data [i] + v -> data [i];

  return LIN_SUCCESS;
}

lin_err_t vec_add (unsigned int n, struct vector* result, ...)
{
  va_list args;
  unsigned int i, a, dim = result -> n_elems;
  struct vector* pv;

  vec_zero (result);

  va_start (args, result);

  for (i = 0; i < n; i++)
  {
    pv = va_arg (args, struct vector*);

    if (pv -> n_elems != dim)
      return LIN_DIM_ERROR;

    for (a = 0; a < dim; a++)
      result -> data [a] += pv -> data [a];
  }

  va_end (args);

  return LIN_SUCCESS;
}

lin_err_t vec_dot (const struct vector* u, const struct vector* v, double* res)
{
  unsigned int i;
  double sum = 0;

  if (u -> n_elems != v -> n_elems)
    return LIN_DIM_ERROR;

  for (i = 0; i < u -> n_elems; i++)
    sum += u -> data [i] * v -> data [i];

  *res = sum;
  return LIN_SUCCESS;
}

bool vec_equal (const struct vector* u, const struct vector* v, 
  const double tol)
{
  unsigned int i;

  if (u -> n_elems != v -> n_elems)
    return false;

  for (i = 0; i < u -> n_elems; i++)
    if (abs (u->data[i] - v->data[i]) > tol)
      return false;

  return true;
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
  char vts_buffer2 [128];
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
  fputc ('\n', stdout);

  double m11 = 0, m12 = 0, m22 = 0;
  puts ("Velocity moments:");
  for (i = 0; i < N_VECS; i++)
  {
    m11 += vecs [i] . data [0] * vecs [i] . data [0];
    m12 += vecs [i] . data [0] * vecs [i] . data [1];
    m22 += vecs [i] . data [1] * vecs [i] . data [1];
  }
  printf ("m11 = %.2lf, m12 = %.2lf, m22 = %.2lf\n", m11, m12, m22);
  fputc ('\n', stdout);


  double dat1[2], dat2[2];
  struct vector res1 = { 2, 2, dat1 }, res2 = { 2, 2, dat2 };
  puts ("Momentum conservation of collisions:");

  vec_add2 (vecs+2, vecs+5, &res1);
  vec_add2 (vecs+0, vecs+3, &res2);
  assert (vec_equal (&res1, &res2, 1e-3) 
    && "collision 'a1' doesn't conserve momentum");
  printf ("a1| pre: %s, post: %s\n", 
    vec_to_str (&res1, vts_buffer, vts_buffer_sz),
    vec_to_str (&res2, vts_buffer2, vts_buffer_sz)
    );

  vec_add (3, &res1, vecs+0, vecs+2, vecs+4);
  vec_add (3, &res2, vecs+1, vecs+3, vecs+5);
  assert (vec_equal (&res1, &res2, 1e-3) 
    && "collision 'b' doesn't conserve momentum");
  printf ("b| pre: %s, post: %s\n", 
    vec_to_str (&res1, vts_buffer, vts_buffer_sz),
    vec_to_str (&res2, vts_buffer2, vts_buffer_sz)
    );

  vec_add (4, &res1, vecs+0, vecs+1, vecs+3, vecs+4);
  vec_add (4, &res2, vecs+1, vecs+2, vecs+4, vecs+5);
  assert (vec_equal (&res1, &res2, 1e-3) 
    && "collision 'c1' doesn't conserve momentum");
  printf ("c1| pre: %s, post: %s\n", 
    vec_to_str (&res1, vts_buffer, vts_buffer_sz),
    vec_to_str (&res2, vts_buffer2, vts_buffer_sz)
    );

  vec_add (3, &res1, vecs+2, vecs+3, vecs+5);
  vec_add (3, &res2, vecs+1, vecs+3, vecs+4);
  assert (vec_equal (&res1, &res2, 1e-3) 
    && "collision 'd1' doesn't conserve momentum");
  printf ("d1| pre: %s, post: %s\n", 
    vec_to_str (&res1, vts_buffer, vts_buffer_sz),
    vec_to_str (&res2, vts_buffer2, vts_buffer_sz)
    );
  fputc ('\n', stdout);


  for (i = 0; i < N_VECS; i++)
    free ((vecs+i) -> data);

  return 0;
}
