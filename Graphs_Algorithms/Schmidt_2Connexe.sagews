g = Graph(6)

g.add_edges([[0, 1], [0, 2], [1, 2], [2, 3], [2, 4], [
            3, 5], [5, 6], [4, 6]])  # exemple du projet
# g.add_edges([[0,1],[1,2],[1,3],[2,4],[3,4],[4,6],[5,6],[6,8],[5,7],[7,8],[5,9],[9,10],[9,11],[10,12],[11,12],[12,13],[11,13]]) #exemple 2 du projet
g.show()

# --------------------------------------parcours en profondeur--------------------------------------------


def pp(g):
    c = {}
    p = {}
    cc = []
    lcc = []
    res = []
    cyc = []
    cycle = []
    connexe = True
    for v in (g.vertices()):
        c[v] = "blanc"
        p[v] = None
    date = 0
    i = 0
    for v in (g.vertices()):
        if (len(lcc) > 1):
            connexe = False
        if (c[v] == "blanc"):
            visiter_pp(g, v, date, c, p, cc, cyc, cycle)
            cc.reverse()
            lcc.append(cc.copy())
            cc.clear()
    return lcc, connexe, cycle, p


def visiter_pp(g, u, date, c, p, cc, cyc, cycle):
    d = {}
    f = {}
    c[u] = "gris"
    date = date+1
    d[u] = date
    for v in g.neighbors(u):
        if (c[v] == "blanc"):
            c[v] = "gris"
            p[v] = u
            visiter_pp(g, v, date, c, p, cc, cyc, cycle)
        elif (c[v] == "gris" and v != p[u]):
            x = u
            while(x != p[v]):
                cyc.append(x)
                x = p[x]
            cycle.append(cyc.copy())
            cyc.clear()
    c[u] = "noir"
    date = date+1
    f[u] = date
    cc.append(u)

# --------------------------------------retrouver les points d'articulation--------------------------------------------
# ----------------------------------------plus les composantes 2-connexe--------------------------------------------


def point_artic(G):
    g = G.copy()
    cc, connexe, cycles, p = pp(g)
    l = []
    for v in g.vertices():
        g.delete_vertex(v)
        cc, connexe, cycles, p = pp(g)
        if connexe == False:
            l.append(v)
        g = G.copy()
    if len(l) != 0:
        t = []
        cc, co, cyc, p = pp(G)
        print("\n\n\nles points d'articulation sont :", l)
        print("les composantes 2-conexe du graphe sont : ", cyc)

# --------------------------------------retrouver les composantes 2-arêtes-connexe--------------------------------------------


def arete_connexe(G):
    g = G.copy()
    lcc, connexe, cycles, p = pp(g)
    l = []
    for e in g.edges():
        g.delete_edge(e)
        cc, connexe, cycles, p = pp(g)
        if connexe == False:
            l.append(e)
        g = G.copy()
    if len(l) != 0:
        print("\n\n\nles composantes 2-arêtes connexes du graphe sont :")
        h = G.copy()
        for e in l:
            h.delete_edge(e)
        lcc, c, cyc, p = pp(h)
        for i in lcc:
            if len(i) < 2:
                lcc.remove(i)
        print(lcc)

# --------------------------------------tester si il existe des cycles différents de C1--------------------------------------------


def cycle_diff_c1(g):
    lcc, c, cyc, p = pp(g)
    for i in range(1, len(cyc)):
        if (cyc[0] != cyc[i]):
            return True
        return False

# --------------------------------------tester si il y a des arêtes qui n'appartiennent a aucun cycle--------------------------------------------


def arete_dans_cycle(g):
    lcc, c, cyc, p = pp(g)
    h = DiGraph(g.copy())
    h.delete_edges(h.edge_iterator())
    e = h.copy()
    for i in range(1, len(p)):
        h.add_edge([list(p.keys())[i], list(p.values())[i]])
        e.add_edge([list(p.values())[i], list(p.keys())[i]])
    print("graphe reliant tous les sommets vers la racine")
    h.show()
    l = []
    l = list(set(list(g.edges())) - set(list(e.edges())))

    for i in l:
        h.add_edge([i[0], i[1]])
    print("orientation des cycles")
    h.show()
    cc, c, cyc, p = pp(h)
    find = False
    t = h.copy()
    for j in range(len(cyc)):
        for i in t.edges():
            if (i[0] in cyc[j] and i[1] in cyc[j]):
                find = True
                t.delete_edges([i])
    return t

# -------------------------------------------------fonction de schmidt-------------------------------------------------------------


def schmidt(g):
    if (len(g.vertices()) < 2):
        print("ce graphe ne peut pas etre 2-arêtes-connexe car il a moins de 2 sommets")
    elif (len(g.vertices()) < 3):
        print("ce graphe ne peut pas etre 2-connexe car il a moins de 3 sommets")
    else:
        lcc, c, cyc, p = pp(g)
        if c:
            t = arete_dans_cycle(g)
            if len(t.edges()) == 0:
                if (cycle_diff_c1(g)):
                    print("2-arêtes-connexe mais pas 2-connexe")
                    point_artic(g)
                else:
                    print("2-connexe")
            else:
                print("\nle graphe a des arêtes qui n'appartiennent a aucun cycle, ces arêtes sont :", t.edges(
                ), "\nAlors le graphe n'est ni 2-connexe ni 2-arêtes-connexe")
                arete_connexe(g)
                point_artic(g)
        else:
            print("ce graphe n'est pas connexe")
            arete_connexe(g)
            point_artic(g)


schmidt(g)
