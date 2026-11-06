"""Gera os arquivos .dot do DER conceitual v2 (notação de Chen) da Start Campos.

O DER representa, no nível conceitual, o banco implementado em sql/ddl/01_estrutura.sql.
Uso: python3 gerar_der.py  -> cria os .dot nesta pasta e em entidades/.
Renderização: ver docs/der/README.md (Graphviz + montar_paginas.py).
"""
from pathlib import Path

AQUI = Path(__file__).parent

COR_ENT = "#E8F2FC"
COR_REL = "#FFF4D6"
COR_NOVO = "#E6F6EA"
BORDA = "#1F5A8A"

# Entidades: nome -> tipo (forte ou associativa). Não há entidade fraca no modelo.
ENTIDADES = {
    "CLIENTE": "forte", "FUNCIONARIO": "forte", "CARGO": "forte", "HISTORICO_SALARIO": "forte",
    "CATEGORIA": "forte", "PRODUTO": "forte", "ESTOQUE": "forte", "MOVIMENTACAO_ESTOQUE": "forte",
    "FORNECEDOR": "forte", "NOTA_FISCAL": "forte", "COMPRA": "forte", "ITEM_COMPRA": "associativa",
    "VENDA": "forte", "ITEM_VENDA": "associativa", "FORMA_PAGAMENTO": "forte",
    "VENDA_PAGAMENTO": "forte", "POS_VENDA": "forte",
}
# Elementos que não existiam no DER da primeira entrega
NOVAS = {"CARGO", "HISTORICO_SALARIO", "ESTOQUE", "NOTA_FISCAL", "FORMA_PAGAMENTO"}

# Relacionamentos: (id, rótulo, entidade A, card. A, entidade B, card. B, identificador?)
# Leitura: uma ocorrência de A se liga a "card. A" ocorrências de B; uma de B, a "card. B" de A.
RELS = [
    ("r_realiza", "realiza", "CLIENTE", "(0,N)", "VENDA", "(1,1)", False),
    ("r_reg_venda", "registra", "FUNCIONARIO", "(0,N)", "VENDA", "(1,1)", False),
    ("r_recebe", "recebe", "VENDA", "(0,N)", "VENDA_PAGAMENTO", "(1,1)", False),
    ("r_usa", "é paga com", "FORMA_PAGAMENTO", "(0,N)", "VENDA_PAGAMENTO", "(1,1)", False),
    ("r_origina_pv", "origina", "VENDA", "(0,N)", "POS_VENDA", "(1,1)", False),
    ("r_atende_pv", "atende", "FUNCIONARIO", "(0,N)", "POS_VENDA", "(1,1)", False),
    ("r_ocupa", "ocupa", "CARGO", "(0,N)", "FUNCIONARIO", "(1,1)", False),
    ("r_recebe_sal", "recebe", "FUNCIONARIO", "(0,N)", "HISTORICO_SALARIO", "(1,1)", False),
    ("r_classifica", "classifica", "CATEGORIA", "(0,N)", "PRODUTO", "(1,1)", False),
    ("r_controla", "controla", "PRODUTO", "(0,1)", "ESTOQUE", "(1,1)", False),
    ("r_possui_mov", "possui", "PRODUTO", "(0,N)", "MOVIMENTACAO_ESTOQUE", "(1,1)", False),
    ("r_executa", "executa", "FUNCIONARIO", "(0,N)", "MOVIMENTACAO_ESTOQUE", "(1,1)", False),
    ("r_atende_c", "atende", "FORNECEDOR", "(0,N)", "COMPRA", "(1,1)", False),
    ("r_reg_compra", "registra", "FUNCIONARIO", "(0,N)", "COMPRA", "(1,1)", False),
    ("r_documenta", "documenta", "NOTA_FISCAL", "(0,N)", "COMPRA", "(1,1)", False),
]
# Associativas (N:N): (entidade, rótulo, A, card. A, B, card. B)
ASSOC = [
    ("ITEM_VENDA", "contém", "VENDA", "(0,N)", "PRODUTO", "(0,N)"),
    ("ITEM_COMPRA", "contém", "COMPRA", "(0,N)", "PRODUTO", "(0,N)"),
]

# Atributos: (nome, tipo, subatributos)  tipo: id | s | multi | comp | multicomp | deriv
ATRIBUTOS = {
    "CLIENTE": [("id_cliente", "id", None), ("nome", "s", None), ("sobrenome", "s", None), ("CPF", "s", None),
                ("data_nascimento", "s", None), ("tipo_cliente", "s", None),
                ("telefone", "multicomp", ["DDI", "DDD", "Codigo_operadora", "numero", "tipo"]),
                ("email", "multicomp", ["email", "tipo"])],
    "FUNCIONARIO": [("id_funcionario", "id", None), ("nome", "s", None), ("sobrenome", "s", None), ("CPF", "s", None),
                    ("data_admissao", "s", None),
                    ("telefone", "multicomp", ["DDI", "DDD", "Codigo_operadora", "numero", "tipo"]),
                    ("email", "multicomp", ["email", "tipo"])],
    "CARGO": [("id_cargo", "id", None), ("cargo", "s", None)],
    "HISTORICO_SALARIO": [("id_historico_salario", "id", None), ("salario", "s", None),
                          ("data_inicio", "s", None), ("data_fim", "s", None)],
    "CATEGORIA": [("id_categoria", "id", None), ("tipo_categoria", "s", None)],
    "PRODUTO": [("id_Produto", "id", None), ("Nome_produto", "s", None), ("preco_unitario", "s", None)],
    "ESTOQUE": [("id_estoque", "id", None), ("quantidade_atual", "s", None), ("quantidade_minima", "s", None)],
    "MOVIMENTACAO_ESTOQUE": [("id_movimentacao", "id", None), ("tipo_movimentacao", "s", None),
                             ("quantidade", "s", None), ("data_movimentacao", "s", None)],
    "FORNECEDOR": [("id_fornecedor", "id", None), ("nome_fornecedor", "s", None), ("cnpj", "s", None),
                   ("endereco", "multicomp", ["cep", "logradouro", "numero", "bairro", "cidade", "estado", "tipo_endereco"])],
    "NOTA_FISCAL": [("id_nota_fiscal", "id", None), ("numero_nota", "s", None), ("valor_pago", "s", None),
                    ("data_emissao", "s", None), ("valor_impostos", "s", None)],
    "COMPRA": [("id_compra", "id", None), ("data_compra", "s", None), ("valor_compra", "deriv", None)],
    "ITEM_COMPRA": [("quantidade", "s", None), ("valor_pago", "s", None)],
    "VENDA": [("id_venda", "id", None), ("Data_Venda", "s", None), ("Status_Venda", "s", None),
              ("valor_venda", "deriv", None)],
    "ITEM_VENDA": [("Quantidade", "s", None), ("preco_unitario", "s", None), ("desconto_unitario", "s", None)],
    "FORMA_PAGAMENTO": [("id_forma_Pagamento", "id", None), ("tipo_forma_pagamento", "s", None)],
    "VENDA_PAGAMENTO": [("id_venda_pagamento", "id", None), ("valor_pago", "s", None)],
    "POS_VENDA": [("id_pos_venda", "id", None), ("data_atendimento", "s", None), ("motivo_contato", "s", None),
                  ("descricao_ocorrencia", "s", None), ("status_atendimento", "s", None)],
}


def cabecalho(titulo, layout="dot"):
    return [
        "digraph DER {",
        f'  graph [layout={layout}, rankdir=LR, splines=true, nodesep=0.45, ranksep=0.9, '
        f'pad=0.4, fontname="Helvetica", labelloc=t, fontsize=26, '
        f'label=<<B>{titulo}</B><BR/><FONT POINT-SIZE="14">Notação de Chen · cardinalidade (mínimo, máximo) · verde = elemento novo na entrega final</FONT>>];',
        '  node [fontname="Helvetica", fontsize=13];',
        '  edge [dir=none, fontname="Helvetica", fontsize=12, color="#36536B", fontcolor="#7A1F1F"];',
    ]


def no_entidade(nome):
    cor = COR_NOVO if nome in NOVAS else COR_ENT
    return (f'  {nome} [shape=box, style="filled", fillcolor="{cor}", color="{BORDA}", '
            f'penwidth=2, label=<<B>{nome}</B>>, width=2.3, height=0.7];')


def no_associativa(nome, rotulo):
    return [
        f"  subgraph cluster_{nome} {{",
        f'    style="filled"; fillcolor="{COR_ENT}"; color="{BORDA}"; penwidth=2; '
        f'label=<<B>{nome}</B>>; fontsize=13; margin=10;',
        f'    {nome} [shape=diamond, style=filled, fillcolor="{COR_REL}", color="{BORDA}", '
        f'label="{rotulo}", width=1.6, height=0.9];',
        "  }",
    ]


def visao_geral():
    linhas = cabecalho("DER CONCEITUAL v2 — START CAMPOS (visão integrada)")
    for e, t in ENTIDADES.items():
        if t != "associativa":
            linhas.append(no_entidade(e))
    for nome, rot, a, ca, b, cb in ASSOC:
        linhas += no_associativa(nome, rot)
        linhas.append(f'  {a} -> {nome} [label="{ca}"];')
        linhas.append(f'  {nome} -> {b} [label="{cb}"];')
    for rid, rot, a, ca, b, cb, ident in RELS:
        cor = COR_NOVO if (a in NOVAS or b in NOVAS) else COR_REL
        linhas.append(f'  {rid} [shape=diamond, style=filled, fillcolor="{cor}", color="{BORDA}", '
                      f'label="{rot}", fontsize=11, width=1.3, height=0.7];')
        linhas.append(f'  {a} -> {rid} [label="{ca}"];')
        linhas.append(f'  {rid} -> {b} [label="{cb}"];')
    linhas.append("}")
    return "\n".join(linhas)


def rotulo_atr(nome, tipo):
    if tipo == "id":
        return f"<<U>{nome}</U>>"
    return f'"{nome}"'


def estrela_entidade(e):
    """Uma entidade com seus atributos (layout radial), para as páginas de atributos."""
    linhas = [
        "graph E {",
        f'  graph [layout=twopi, root={e}, ranksep=1.25, overlap=false, pad=0.25, '
        f'fontname="Helvetica", splines=true];',
        '  node [fontname="Helvetica", fontsize=13];',
        '  edge [color="#36536B"];',
    ]
    if ENTIDADES[e] == "associativa":
        linhas.append(f'  {e} [shape=box, style="filled,rounded", fillcolor="{COR_ENT}", color="{BORDA}", '
                      f'penwidth=2, label=<<B>{e}</B><BR/><FONT POINT-SIZE="11">(associativa: ◇ dentro do □)</FONT>>];')
    else:
        linhas.append(no_entidade(e).replace("width=2.3, height=0.7", "width=2.6, height=0.8"))
    for i, (atr, tipo, subs) in enumerate(ATRIBUTOS[e]):
        nid = f"a{i}"
        estilo = "dashed" if tipo == "deriv" else "solid"
        per = 2 if tipo in ("multi", "multicomp") else 1
        linhas.append(f'  {nid} [shape=ellipse, style="{estilo}", peripheries={per}, '
                      f'label={rotulo_atr(atr, tipo)}];')
        linhas.append(f"  {e} -- {nid};")
        for j, sub in enumerate(subs or []):
            linhas.append(f'  {nid}_{j} [shape=ellipse, label="{sub}", fontsize=11];')
            linhas.append(f"  {nid} -- {nid}_{j};")
    linhas.append("}")
    return "\n".join(linhas)


if __name__ == "__main__":
    (AQUI / "der-v2-visao-geral.dot").write_text(visao_geral(), encoding="utf-8")
    pasta = AQUI / "entidades"
    pasta.mkdir(exist_ok=True)
    for f in pasta.glob("*.dot"):
        f.unlink()
    for e in ENTIDADES:
        (pasta / f"{e.lower()}.dot").write_text(estrela_entidade(e), encoding="utf-8")
    print("ok")
