module MarchingSquares

export bin_img, bit_cells, disambig_saddle_pts!;

#! Binary image
function bin_img(gdata::Matrix, iso_value::Real)
  f = (x) -> begin; y::UInt8 = (x < iso_value) ? 0 : 1; y; end;
  return map(f, gdata);
end

#! Representation of contour by bits
#!
#! \param   bin_img   Binary image representation
#! \return            Bit respresentation
function bit_cells(bin_img::Matrix{UInt8})
  const nrows   =   size(bin_img, 1) - 1;
  const ncols   =   size(bin_img, 2) - 1;
  cell_values   =   zeros(UInt8, (nrows, ncols));
  
  for j=1:ncols, i=1:nrows
    cell_values[i, j]  |=    bin_img[i, j];
    cell_values[i, j]  <<=   1;

    cell_values[i, j]  |=    bin_img[i, j+1];
    cell_values[i, j]  <<=   1;

    cell_values[i, j]  |=    bin_img[i+1, j+1];
    cell_values[i, j]  <<=   1;

    cell_values[i, j]  |=    bin_img[i+1, j];
  end
  
  return cell_values;
end

#! Disambiguate saddle points
#!
#! \param   cell_values   Bit representation of the contour
#! \param   data          Original data set
#! \param   iso_value     Iso value
function disambig_saddle_pts!(cell_values::Matrix{UInt8}, data::Matrix,
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
