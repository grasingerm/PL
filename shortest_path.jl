using Graphs, SimpleWeightedGraphs

g = SimpleWeightedGraph(5);

add_edge!(g, 1, 2, eps());
add_edge!(g, 2, 1, eps());
add_edge!(g, 2, 3, 5.0);
add_edge!(g, 3, 2, 5.0);
add_edge!(g, 1, 4, 1.0);
add_edge!(g, 4, 1, 1.0);
add_edge!(g, 2, 4, 2.0);
add_edge!(g, 4, 2, 2.0);
add_edge!(g, 2, 5, 2.0);
add_edge!(g, 5, 2, 2.0);
add_edge!(g, 3, 5, 5.0);
add_edge!(g, 5, 3, 5.0);
add_edge!(g, 4, 5, 1.0);
add_edge!(g, 5, 4, 1.0);

for i=1:5
  println("=============== $i =================");
  vidx = 1;
  for path in enumerate_paths(dijkstra_shortest_paths(g, i))
    @show vidx, path
    vidx += 1
  end
  println("=============== $i =================");
end
