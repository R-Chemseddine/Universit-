g = Graph(6)
g.add_edges([[0,1],[0,2],[1,2],[1,3],[1,4],[1,5],[2,5],[2,6],[3,7],[4,5],[4,7],[4,8],[5,6],[6,9],[7,8],[8,9]]) #graphe ayant une orientation
#g.add_edges([[0,1],[1,2],[2,3],[2,4],[3,0],[2,0],[4,5],[5,6],[6,7],[7,5],[4,1],[4,8],[5,7],[8,9],[4,9]]) #graphe ne pouvant pas avoir d'orientation
g.show()

#--------------------------------------parcours en profondeur--------------------------------------------

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
        if (len(lcc)>1):
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
            visiter_pp(g, v, date, c, p, cc,cyc, cycle)
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


#--------------------------------retrouver les arêtes déconnectantes---------------------------------------

def arete_dec(G):
    g = G.copy()
    deco = False
    lcc, connexe, cycles,p = pp(g)
    if connexe == False :
        return "le graphe n'est pas connexe"
    l = []
    for e in g.edges():
        g.delete_edge(e)
        cc, connexe, cycles,p = pp(g)
        if connexe == False:
            l.append(e)
        g = G.copy()
    if len(l) != 0:
        deco = True
        print("le graphe ne peut pas avoir d'orientation fortement connexe car il a des arêtes déconnectantes, et elles sont :", l)
    return l, deco

#-----------------------------------------retrouver l'orientation-----------------------------------------------

def orientation_FC(g):
    l, deco = arete_dec(g)
    if (not deco):
        lcc, c, cyc, p = pp(g)
        h = DiGraph(g.copy())
        h.delete_edges(h.edge_iterator())
        e = h.copy()
        # reconstruire l'arbre de parcours en profondeur
        for i in range(1, len(p)):
            h.add_edge([list(p.keys())[i],list(p.values())[i]])
            e.add_edge([list(p.values())[i],list(p.keys())[i]])

        # orienter les arêtes arrières
        l =[]
        l = list(set(list(g.edges())) - set(list(e.edges())))
        for i in l:
            h.add_edge([i[0], i[1]])
        print("l'orientation du graphe fortement connexe :")
        h.show()


orientation_FC(g)