module MarchingSquares

#! Binary image
macro bin_img(data, iso_value)
  return :(map(x -> (x < $iso_value) ? 0 : 1, $data));
end

#! Representation of contour by bits
#!
#! \param   bin_img   Binary image representation
#! \return            Bit respresentation
function bit_cells(bin_img::Matrix{Int})
  const nrows   =   size(bin_img, 1) - 1;
  const ncols   =   size(bin_img, 2) - 1;
  cell_values   =   ones(Int, (nrows, ncols));
  
  for j=1:ncols, i=1:nrows
    cells[i, j]  |=    bin_img[i, j];
    cells[i, j]  <<=   1;

    cells[i, j]  |=    bin_img[i, j+1];
    cells[i, j]  <<=   1;

    cells[i, j]  |=    bin_img[i+1, j+1];
    cells[i, j]  <<=   1;

    cells[i, j]  |=    bin_img[i+1, j];
  end
  
  return cell_values;
end

#! Disambiguate saddle points
#!
#! \param   cell_values   Bit representation of the contour
#! \param   data          Original data set
#! \param   iso_value     Iso value
function disambig_saddle_pts!(cell_values::Matrix{Int}, data::Matrix,
                              iso_value::Real)

  const nrows, ncols  =   size(cell_values);

  for j=1:ncols, i=1:nrows
    if cell_values[i, j] == 5
      if mean(data[i:i+1, j:j+1]) < iso_value
        cell_values[i, j] <<= 1;
      end
    elseif cell_values[i, j] == 5
      if mean(data[i:i+1, j:j+1]) > iso_value
        cell_values[i, j] >>= 1;
      end
    end
  end
end

end # m dule
