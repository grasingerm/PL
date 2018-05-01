#include <boost/numeric/ublas/matrix.hpp>
#include <boost/numeric/ublas/io.hpp>
#include <cstdio>
#include <cmath>
#include <tuple>
#include <mpi.h>

int main(int argc, char* argv[])
{
  MPI_Init(&argc, &argv);

  int ntasks, taskid, rc;
  MPI_Comm_size(MPI_COMM_WORLD, &ntasks);
  MPI_Comm_rank(MPI_COMM_WORLD, &taskid);

  using namespace boost::numeric::ublas;
  const unsigned rows = 1000, cols = 1000;
  matrix<double> m (rows, cols);
  for (unsigned i = 0; i < m.size1(); ++i)
    for (unsigned j = 0; j < m.size2(); ++j)
      m(i, j) = (rand() % 10000 - 5000) / 100.0;

  unsigned total_elems = rows * cols;
  unsigned block_size = ceil(static_cast<double>(total_elems) 
                             / static_cast<double>(ntasks));
  unsigned begin_block = block_size * taskid;
  unsigned end_block = (taskid+1 == ntasks) ? total_elems :
                                              begin_block + block_size;
  
  //! lambda for mapping element number to row, col or i, j
  auto map_k_to_ij = [cols](unsigned k) 
                     {
                       unsigned i = k / cols;
                       unsigned j = k % cols;
                       return std::tuple<unsigned, unsigned> (i, j);
                     }

  double total_sum, local_sum = 0;
  for (unsigned k = begin_block; k < end_block; ++k)
  {
    unsigned i, j;
    std::tie(i, j) = map_k_to_ij(k);
    local_sum += m(i,j);
  }
  rc = MPI_Reduce(&local_sum, &total_sum, 1, MPI_DOUBLE, MPI_SUM, 0,
                  MPI_COMM_WORLD);
  if (rc != MPI_SUCCESS)
  {
    fprintf(stderr, "%d: failure on mpi_reduce\n", taskid);
    return -1;
  }
 
  if (taskid == 0)
    printf("The sum of all elements before is: %lf\n", total_sum);

  // multiple each element by 2
  for (unsigned k = begin_block; k < end_block; ++k)
  {
    unsigned i, j;
    std::tie(i, j) = map_k_to_ij(k);
    m(i,j) *= 2.0;
  }

  rc = MPI_Gather(&m.data()[begin_block], end_block - begin_block, MPI_DOUBLE,
                  &m.data()[begin_block], end_block - begin_block, MPI_DOUBLE,
                  0, MPI_COMM_WORLD);
  if (rc != MPI_SUCCESS) 
  { 
    fprintf("Shit hit the fan on %d\n", taskid); 
    return -1; 
  }

  rc = MPI_Scatter(&m.data(), m.size1*m.size2, MPI_DOUBLE, &m.data(),
                   m.size1*m.size2, MPI_DOUBLE, 0, MPI_COMM_WORLD);
  if (rc != MPI_SUCCESS) 
  { 
    fprintf("Shit hit the fan on %d\n", taskid); 
    return -1; 
  }
  
  local_sum = 0; total_sum = 0;
  for (unsigned k = begin_block; k < end_block; ++k)
  {
    unsigned i, j;
    std::tie(i, j) = map_k_to_ij(k);
    local_sum += m(i,j);
  }
  rc = MPI_Reduce(&local_sum, &total_sum, 1, MPI_DOUBLE, MPI_SUM, 0,
                  MPI_COMM_WORLD);
  if (rc != MPI_SUCCESS)
  {
    fprintf(stderr, "%d: failure on mpi_reduce\n", taskid);
    return -1;
  }
 
  if (taskid == 0)
    printf("The sum of all elements after is: %lf\n", total_sum);

  MPI_Finalize();

  return 0;
}
