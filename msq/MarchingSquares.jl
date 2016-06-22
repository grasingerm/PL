module MarchingSquares

export bin_img, bit_cells, disambig_saddle_pts!;
export lininterp_cells;
export Point2D, Line2D;

#! Binary image
function bin_img(gdata::Matrix{Float64}, iso_value::Real)
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
    cell_values[i, j]  |=    bin_img[i, j+1];
    cell_values[i, j]  <<=   1;

    cell_values[i, j]  |=    bin_img[i+1, j+1];
    cell_values[i, j]  <<=   1;

    cell_values[i, j]  |=    bin_img[i+1, j];
    cell_values[i, j]  <<=   1;

    cell_values[i, j]  |=    bin_img[i, j];
  end
  
  return cell_values;
end

#! Disambiguate saddle points
#!
#! \param   cell_values   Bit representation of the contour
#! \param   data          Original data set
#! \param   iso_value     Iso value
function disambig_saddle_pts!(cell_values::Matrix{UInt8}, data::Matrix{Float64},
                              iso_value::Real)

  const nrows, ncols  =   size(cell_values);

  for j=1:ncols, i=1:nrows
    if cell_values[i, j] == 5
      if mean(data[i:i+1, j:j+1]) < iso_value
        cell_values[i, j] <<= 1;
      end
    elseif cell_values[i, j] == 10
      if mean(data[i:i+1, j:j+1]) > iso_value
        cell_values[i, j] >>= 1;
      end
    end
  end
end

# Very simple point type
type Point2D
  x::Float64
  y::Float64

  Point2D(x::Float64, y::Float64) = new(x, y);
  Point2D(pt::Point2D)            = new(pt.x, pt.y);
end

# Very simple line type
type Line2D
  a::Point2D
  b::Point2D

  Line2D(a::Point2D, b::Point2D)  = new(a, b);
  Line2D(l::Line2D)               = new(l.a, l.b);
end

#! Find interface lines that intersects cell walls
#!
#! \param   cell_values     Bit representation of cellular interfaces
#! \param   data            Original data
#! \param   iso_value       Iso value
#! \return                  Matrix of vector of lines
function lininterp_cells(cell_values::Matrix{UInt8}, data::Matrix{Float64},
                         iso_value::Real)

  const nrows, ncols = size(cell_values);
  lines              = Array{Vector{Line2D}}(nrows, ncols);

  for j=1:ncols, i=1:nrows
    lines[i, j] = lininterp_cell(cell_values[i, j], i, j, data, iso_value);  
  end

  return lines;
end

# Helper macros
macro _lininterp_north(data, iso_value, i, j)
  return :(0.5 - ($iso_value - $data[i+1,j+1]) / 
                 ($data[i,j+1] - $data[i+1,j+1]));
end

macro _lininterp_east(data, iso_value, i, j)
  return :(0.5 - ($iso_value - $data[i+1,j+1]) / 
                 ($data[i+1,j] - $data[i+1,j+1]));
end

macro _lininterp_south(data, iso_value, i, j)
  return :(0.5 - ($iso_value - $data[i+1,j]) / 
                 ($data[i,j] - $data[i+1,j]));
end

macro _lininterp_west(data, iso_value, i, j)
  return :(0.5 - ($iso_value - $data[i,j+1]) / 
                 ($data[i,j] - $data[i,j+1]));
end

#! Linear interpolation along a cell boundary
#!
#! \param   cell_value    Bit representation of interface in cell
#! \param   i             ith index of cell
#! \param   j             jth index of cell
#! \param   data          Original data
#! \param   iso_value     Iso value
#! \return                Array of lines that make up interface in cell
function lininterp_cell(cell_value::UInt8, i::Int, j::Int, 
                        data::Matrix{Float64}, iso_value::Real)

  if      cell_value    ==    0
    return Line2D[Line2D(Point2D(0.0, 0.0), Point2D(0.0, 0.0))];
  elseif  cell_value    ==    1
    const px  =   -0.5;
    const qy  =   -0.5;

    const py  =   @_lininterp_west(data, iso_value, i, j);
    const qx  =   @_lininterp_south(data, iso_value, i, j);

    return Line2D[Line2D(Point2D(px, py), Point2D(qx, qy))];

  elseif  cell_value    ==    2
    const py  =   -0.5;
    const qx  =   0.5;

    const px  =   @_lininterp_south(data, iso_value, i, j);
    const qy  =   @_lininterp_east(data, iso_value, i, j);

    return Line2D[Line2D(Point2D(px, py), Point2D(qx, qy))];

  elseif  cell_value    ==    3
    const px  =   -0.5;
    const qx  =   0.5;

    const py  =   @_lininterp_west(data, iso_value, i, j);
    const qy  =   @_lininterp_east(data, iso_value, i, j);

    return Line2D[Line2D(Point2D(px, py), Point2D(qx, qy))];

  elseif  cell_value    ==    4
    const py  =   0.5;
    const qx  =   0.5;

    const px  =   @_lininterp_north(data, iso_value, i, j); 
    const qy  =   @_lininterp_east(data, iso_value, i, j); 

    return Line2D[Line2D(Point2D(px, py), Point2D(qx, qy))];

  elseif  cell_value    ==    5
    const px1  =   -0.5;
    const qy1  =   0.5;

    const py1  =   @_lininterp_west(data, iso_value, i, j);
    const qx1  =   @_lininterp_north(data, iso_value, i, j);

    const py2  =   -0.5;
    const qx2  =   0.5;

    const px2  =   @_lininterp_south(data, iso_value, i, j);
    const qy2  =   @_lininterp_east(data, iso_value, i, j);

    return (Line2D[Line2D(Point2D(px1, py1), Point2D(qx1, qy1)), 
            Line2D(Point2D(px2, py2), Point2D(qx2, qy2))]);

  elseif  cell_value    ==    6
    const py  =   0.5;
    const qy  =   -0.5;

    const px  =   @_lininterp_north(data, iso_value, i, j);
    const qx  =   @_lininterp_south(data, iso_value, i, j);

    return Line2D[Line2D(Point2D(px, py), Point2D(qx, qy))];
    
  elseif  cell_value    ==    7
    const px  =   -0.5;
    const qy  =   0.5;

    const py  =   @_lininterp_west(data, iso_value, i, j);
    const qx  =   @_lininterp_north(data, iso_value, i, j);

    return Line2D[Line2D(Point2D(px, py), Point2D(qx, qy))];

  elseif  cell_value    ==    8
    const px  =   -0.5;
    const qy  =   0.5;

    const py  =   @_lininterp_west(data, iso_value, i, j);
    const qx  =   @_lininterp_north(data, iso_value, i, j);

    return Line2D[Line2D(Point2D(px, py), Point2D(qx, qy))];

  elseif  cell_value    ==    9
    const py  =   0.5;
    const qy  =   -0.5;

    const px  =   @_lininterp_north(data, iso_value, i, j);
    const qx  =   @_lininterp_south(data, iso_value, i, j);

    return Line2D[Line2D(Point2D(px, py), Point2D(qx, qy))];

  elseif  cell_value    ==   10
    const px1  =   -0.5;
    const qy1  =   -0.5;

    const py1  =   @_lininterp_west(data, iso_value, i, j);
    const qx1  =   @_lininterp_south(data, iso_value, i, j);

    const py2  =   0.5;
    const qx2  =   0.5;

    const px2  =   @_lininterp_north(data, iso_value, i, j);
    const qy2  =   @_lininterp_east(data, iso_value, i, j);

    return (Line2D[Line2D(Point2D(px1, py1), Point2D(qx1, qy1)), 
            Line2D(Point2D(px2, py2), Point2D(qx2, qy2))]);

  elseif  cell_value    ==   11
    const py  =   0.5;
    const qx  =   0.5;

    const px  =   @_lininterp_north(data, iso_value, i, j); 
    const qy  =   @_lininterp_east(data, iso_value, i, j); 

    return Line2D[Line2D(Point2D(px, py), Point2D(qx, qy))];

  elseif  cell_value    ==   12
    const px  =   -0.5;
    const qx  =   0.5;

    const py  =   @_lininterp_west(data, iso_value, i, j);
    const qy  =   @_lininterp_east(data, iso_value, i, j);

    return Line2D[Line2D(Point2D(px, py), Point2D(qx, qy))];

  elseif  cell_value    ==   13
    const py  =   -0.5;
    const qx  =   0.5;

    const px  =   @_lininterp_south(data, iso_value, i, j);
    const qy  =   @_lininterp_east(data, iso_value, i, j);

    return Line2D[Line2D(Point2D(px, py), Point2D(qx, qy))];

  elseif  cell_value    ==   14
    const px  =   -0.5;
    const qy  =   -0.5;

    const py  =   @_lininterp_west(data, iso_value, i, j);
    const qx  =   @_lininterp_south(data, iso_value, i, j);

    return Line2D[Line2D(Point2D(px, py), Point2D(qx, qy))];
    
  elseif  cell_value    ==   15
    return Line2D[Line2D(Point2D(0.0, 0.0), Point2D(0.0, 0.0))];
  else
    error("Cell value $(cell_value) invalid for 2D");
  end
end

#! Find the unit normal of a line
function _unormal(ln::Line2D)
  const dx =  ln.b.x - ln.a.x;
  const dy =  ln.b.y - ln.a.y;
  uns      =  Vector{Float64}[[-dy, dx], [dy, -dx]];

  return map!(u -> u / norm(u, 2), uns);
end

#! Convert a grid of vectors of lines to unit normals 
function _lines_to_normal(lines_grid::Matrix{Vector{Line2D}})
  return map(lns -> map(ln -> _unormal(ln), lns), lines_grid);
end

end # module
