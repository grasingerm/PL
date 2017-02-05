using PyPlot;

function plot_vec_2d(u::Vector{Float64}; label="")
  plot([0.0; u[1]], [0.0; u[2]], label=label);
end

function plot_vec_3d(u::Vector{Float64}; label="")
  plot([0.0; u[1]], [0.0; u[2]], [0.0; u[3]], label=label);
end

function plot_transform_2d(u::Vector{Float64}, A::Matrix{Float64}; 
                           plot_eigvecs::Bool = false)
  v = A * u;
  plot_vec_2d(u; label="u");
  plot_vec_2d(v; label="v");
  if plot_eigvecs
    D, V = eig(A);
    println("λ = \n$D");
    plot_vec_2d(map(x -> real(x), V[:, 1]); label="\$\\psi_1\$");
    plot_vec_2d(map(x -> real(x), V[:, 2]); label="\$\\psi_2\$");
  end
  legend();
  scale = max(norm(u, 2), norm(v, 2));
  xlim([-scale, scale]);
  ylim([-scale, scale]);
  show();
end

function plot_transform_3d(u::Vector{Float64}, A::Matrix{Float64};
                           plot_eigvecs::Bool=false)
  v = A * u;
  scale = max(norm(u, 2), norm(v, 2));
  subplot(111, projection="3d");
  plot_vec_3d(u; label="u");
  plot_vec_3d(v; label="v");
  if plot_eigvecs
    D, V = eig(A);
    println("λ = \n$D");
    plot_vec_2d(map(x -> real(x), V[:, 1]); label="\$\\psi_1\$");
    plot_vec_2d(map(x -> real(x), V[:, 2]); label="\$\\psi_2\$");
    plot_vec_2d(map(x -> real(x), V[:, 3]); label="\$\\psi_3\$");
  end
  legend();
  xlim([-scale, scale]);
  ylim([-scale, scale]);
  zlim([-scale, scale]);
  show();
end

function rotation_matrix_2d(theta::Real)
  return [cos(theta) -sin(theta); sin(theta) cos(theta)];
end

function rotation_matrix_x(theta::Real)
  return [1.0 0.0 0.0; 0.0 cos(theta) sin(theta); 0.0 -sin(theta) cos(theta)];
end

function rotation_matrix_y(theta::Real)
  return [cos(theta) 0.0 -sin(theta); 0.0 1.0 0.0; sin(theta) 0.0 cos(theta)];
end

function rotation_matrix_z(theta::Real)
  return [cos(theta) sin(theta) 0.0; -sin(theta) cos(theta) 0.0; 0.0 0.0 1.0; ];
end
