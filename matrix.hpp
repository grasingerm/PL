#ifndef __MATRIX_HPP__
#define __MATRIX_HPP__

#include <memory>
#include <initializer_list>
#include <stdexcept>
#include <iostream>

namespace sst
{

/*! \brief A two dimensional generalization of the std::vector
 */
template <class T> class matrix {
public:
  /*! \brief Default constructor
   *
   * \return  Empty matrix
   */
  matrix<T>() : _n_rows(0), _n_cols(0), _data(nullptr), _insertion_index(0) {}
 
  /*! \brief Allocates and constructs and n by m matrix
   *
   * \param   n   Number of rows
   * \param   m   Number of columns
   * \return      n by m matrix
   */
  matrix<T>(const size_t n, const size_t m) :
    _n_rows(n), _n_cols(m), _data(new T[n*m]), _insertion_index(0) {};

  matrix<T>(const size_t n, const size_t m, const T value);

  matrix<T>(const std::initializer_list<std::initializer_list<T>> values);
  
  matrix<T>(const matrix<T>&);
  matrix<T>& operator=(const matrix<T>&);
  
  matrix<T>(matrix<T>&&);
  matrix<T>& operator=(matrix<T>&&);
  
  ~matrix<T>() { delete[] _data; }
  
  matrix<T>& operator<<(const T value);
  void reset_index() { _insertion_index = 0; }
       
  inline T& operator()(const size_t i, const size_t j) { 
    if (i >= _n_rows || j >= _n_cols) 
        throw std::out_of_range ("Trying to access matrix out of range."); 
    
    return _data[i*_n_cols + j];
  }

  inline const T& operator() (const size_t i, const size_t j) const { 
    if (i >= _n_rows || j >= _n_cols) 
        throw std::out_of_range ("Trying to access matrix out of range."); 
    
    return _data[i*_n_cols + j];
  }

  inline T& operator[](const size_t i, const size_t j) { 
    return (*this)(i, j); 
  }
  
  friend std::ostream& operator<< (std::ostream& stream, const matrix& a) {
    for (size_t i = 0; i < a._n_rows; ++i) {
        for (size_t j = 0; j < a._n_cols; ++j)
            stream << " " << a(i,j);
        stream << std::endl;
    }
    
    return stream;
  }
  
  void resize(const size_t, const size_t);

  inline size_t n_rows() const { return _n_rows; }
  inline size_t n_cols() const { return _n_cols; }

  typedef T* iterator;
  typedef const T* const_iterator;
  iterator begin() { return _data; }
  iterator end() { return (_data + _n_rows * _n_cols); }
  const_iterator begin() const { return _data; }
  const_iterator end() const { return (_data + _n_rows * _n_cols); }
  const_iterator cbegin() const { return _data; }
  const_iterator cend() const { return (_data + _n_rows * _n_cols); }
        
private:
  T* _data;
  size_t _n_rows;
  size_t _n_cols;
  size_t _insertion_index;
};

/*! \brief Allocates and fills an n by m matrix
 *
 * \param   n       Number of rows
 * \param   m       Number of columns
 * \param   value   Value to be assigned to every element of the matrix
 * \return          Filled, n by m matrix
 */
template <class T> matrix<T>::matrix(const size_t n, const size_t m, 
                                     const T value) : matrix<T>(n,m) { 
  for (auto& elem : *this) elem = value;
}

/*! \brief Initializes a matrix with initializer lists
 *
 * Requires that each row of the 2D initializer list be of equal size
 *
 * \param   values  Values to be assigned to elements of the matrix
 * \return          Matrix
 */
template <class T> matrix<T>::matrix
  (const std::initializer_list<std::initializer_list<T>> values) 
  : matrix<T>(values.size(), values.begin()->size()) {
  
  size_t i = 0, j = 0;
  for (auto& row : values) {

    if (row.size() != _n_cols) 
      throw std::invalid_argument("All rows must be the same size");

    for (auto& val : row) {
      (*this)(i, j) = val;
      ++j;
    }
    ++i;
  }

}

/*! \brief Copy constructor
 *
 * \param   a   Matrix to be copied
 * \return      Copied matrix
 */
template <class T> matrix<T>::matrix(const matrix<T>& a) 
  : _n_rows(a._n_rows), _n_cols(a._n_cols) {
  _data = new T[_n_rows*_n_cols];
  for (size_t i = 0; i < _n_rows; ++i)
      for (size_t j = 0; j < _n_cols; ++j)
          (*this)(i,j) = a(i,j);
}

/*! \brief Assignment operator
 *
 * \param   a   Matrix to be copied
 * \return      Copied matrix
 */
template <class T> matrix<T>& matrix<T>::operator=(const matrix<T>& a)
{
  resize(a._n_rows, a._n_cols);
  _insertion_index = 0;
  
  for (size_t i = 0; i < _n_rows; ++i)
      for (size_t j = 0; j < _n_cols; ++j)
          (*this)(i,j) = a(i,j);
  
  return *this;
}

/*! \brief Copy constructor
 *
 * \param   a   Matrix to be copied
 * \return      Copied matrix
 */
template <class T> matrix<T>::matrix(matrix<T>&& a) 
  : _n_rows(a._n_rows), _n_cols(a._n_cols), _data(a._data), _insertion_index(0) {
  a._data = nullptr; /* ensure nothing funny happens when a is deleted */
}

/*! \brief Assignment operator
 *
 * \param   a   Matrix to be copied
 * \return      Copied matrix
 */
template <class T> matrix<T>& matrix<T>::operator=(matrix<T>&& a) {
  _insertion_index = 0;
  
  /* delete old memory, move rvalue memory in */
  T* p = _data;
  _data = a._data;
  delete[] p;
  
  _n_rows = a._n_rows;
  _n_cols = a._n_cols;
  
  a._data = nullptr;
  
  return *this;
}

/*! \brief Insertion operator
 *
 * \param   value   Value to be inserted into next element
 * \return          Reference to the matrix
 */
template <class T> matrix<T>& matrix<T>::operator<<(const T value) {
  _data[_insertion_index] = value;
  _insertion_index++;
  if (_insertion_index == _n_rows*_n_cols) _insertion_index = 0;
  return *this;
}

/*! \brief Resize the matrix
 *
 * \param   n   Number of rows
 * \param   m   Number of columns
 */
template <class T> void matrix<T>::resize(const size_t n, const size_t m) {
  if (sizeof(_data)/sizeof(T) < n*m) {
      T* p = _data;
      _data = new T[n*m];
      delete[] p;
      _insertion_index = 0;
  }
  
  _n_rows = n;
  _n_cols = m;
}

} // namespace sst

#endif /* __MINEAR_HPP__ */
