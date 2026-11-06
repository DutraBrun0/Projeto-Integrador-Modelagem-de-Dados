"""Monta as páginas de atributos do DER v2 e o PDF completo a partir dos PNGs gerados pelo Graphviz."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

AQUI = Path(__file__).parent
ENT = AQUI / "entidades"
F = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"
FR = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
AREAS = [
    ("1-clientes-funcionarios", "Clientes e funcionários", ["cliente", "funcionario", "cargo", "historico_salario"]),
    ("2-catalogo-estoque", "Catálogo e estoque", ["categoria", "produto", "estoque", "movimentacao_estoque"]),
    ("3-compras", "Compras e fornecedores", ["fornecedor", "compra", "item_compra", "nota_fiscal"]),
    ("4-vendas", "Vendas, pagamentos e pós-venda", ["venda", "item_venda", "forma_pagamento", "venda_pagamento", "pos_venda"]),
]
LEGENDA = ("Retângulo: entidade · □ com ◇: entidade associativa · Elipse: atributo · Elipse dupla: multivalorado "
           "(com seus componentes) · Elipse tracejada: derivado · Sublinhado: identificador · Verde: novo na entrega final")
W, CEL = 3300, 1000

def pagina(titulo, nomes):
    cols = 3 if len(nomes) > 4 else 2
    rows = -(-len(nomes) // cols)
    H = 230 + rows * (CEL + 60)
    pg = Image.new("RGB", (W, H), "white")
    d = ImageDraw.Draw(pg)
    d.text((W // 2, 70), f"DER CONCEITUAL v2 — {titulo} (atributos)", font=ImageFont.truetype(F, 60), fill="#123A5A", anchor="mm")
    d.text((W // 2, 150), LEGENDA, font=ImageFont.truetype(FR, 22), fill="#566B7F", anchor="mm")
    cw = W // cols
    for i, n in enumerate(nomes):
        im = Image.open(ENT / f"{n}.png").convert("RGB")
        k = min((cw - 60) / im.width, CEL / im.height, 1.8)
        im = im.resize((int(im.width * k), int(im.height * k)), Image.LANCZOS)
        r, c = divmod(i, cols)
        x = c * cw + (cw - im.width) // 2
        y = 220 + r * (CEL + 60) + (CEL - im.height) // 2
        pg.paste(im, (x, y))
    return pg

paginas = [Image.open(AQUI / "der-v2-visao-geral.png").convert("RGB")]
for arq, titulo, nomes in AREAS:
    pg = pagina(titulo, nomes)
    pg.save(AQUI / f"der-v2-{arq}.png", optimize=True)
    paginas.append(pg)
paginas[0].save(AQUI / "der-conceitual-v2.pdf", save_all=True, append_images=paginas[1:], resolution=150)
print("ok")
