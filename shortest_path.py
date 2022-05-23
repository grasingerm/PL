import networkx as nx

g = nx.DiGraph()
g.add_nodes_from(range(1, 6))

#g.add_weighted_edges_from([(1, 2, 6.0), (2, 1, 6.0), (2, 3, 5.0),
#                           (3, 2, 5.0), (1, 4, 1.0), (4, 1, 1.0),
#                           (2, 4, 2.0), (4, 2, 2.0), (2, 5, 2.0),
#                           (5, 2, 2.0), (3, 5, 5.0), (5, 3, 5.0),
#                           (4, 5, 1.0), (5, 4, 1.0)])
g.add_edge(1, 2, weight=6.0)
g.add_edge(2, 1, weight=6.0)
g.add_edge(2, 3, weight=5.0)
g.add_edge(3, 2, weight=5.0)
g.add_edge(1, 4, weight=1.0)
g.add_edge(4, 1, weight=1.0)
g.add_edge(2, 4, weight=2.0)
g.add_edge(4, 2, weight=2.0)
g.add_edge(2, 5, weight=2.0)
g.add_edge(5, 2, weight=2.0)
g.add_edge(3, 5, weight=5.0)
g.add_edge(5, 3, weight=5.0)
g.add_edge(4, 5, weight=1.0)
g.add_edge(5, 4, weight=1.0)

sps = nx.shortest_path(g, weight="weight")
for (k, v) in sps.items():
    print(k)
    print("==========")
    for (subk, subv) in v.items():
        print(subk, ": ", subv)
    print()

print(nx.shortest_path(g, source=1, target=2))
