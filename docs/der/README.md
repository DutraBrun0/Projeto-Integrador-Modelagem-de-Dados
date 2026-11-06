# DER Conceitual

| Versão | Pasta | Situação |
|---|---|---|
| v2 — entrega final | [`v2/`](v2/) | **Versão atual**, coerente com o banco implementado |
| v1 — primeira entrega | [`v1-primeira-entrega/`](v1-primeira-entrega/) | Histórico da evolução do modelo |

## DER v2

- [Visão integrada: entidades, relacionamentos e cardinalidades](v2/der-v2-visao-geral.png)
- [Atributos — Clientes e funcionários](v2/der-v2-1-clientes-funcionarios.png)
- [Atributos — Catálogo e estoque](v2/der-v2-2-catalogo-estoque.png)
- [Atributos — Compras e fornecedores](v2/der-v2-3-compras.png)
- [Atributos — Vendas, pagamentos e pós-venda](v2/der-v2-4-vendas.png)
- [Todas as páginas em PDF](v2/der-conceitual-v2.pdf)

O DER continua **conceitual**: não tem chaves estrangeiras nem tipos de dados. As chaves e os tipos estão no [modelo lógico](../modelo-logico/modelo-logico.md) e no [dicionário de dados](../dicionario-dados/dicionario-dados.md).

### O que mudou da v1 para a v2

- Novas entidades (em verde): **Cargo**, **HistoricoSalario**, **Estoque**, **NotaFiscal** e **FormaPagamento**.
- Venda `(0,N)` ItemVenda: a venda em andamento pode existir sem itens (devolutiva).
- Cliente obrigatório na venda (RN08 revisada).
- Endereço do fornecedor como atributo multivalorado e composto.
- Saíram do modelo nesta versão: Fornecimento, PerfilAcesso, Entrega, número de série e origem da movimentação (ver README, seções 5.5 e 15).

### Legenda

- Retângulo: entidade
- Retângulo envolvendo losango: entidade associativa
- Losango: relacionamento
- Elipse: atributo · Elipse dupla: multivalorado (com seus componentes) · Elipse tracejada: derivado
- Atributo sublinhado: identificador
- Pares como `(0,N)` e `(1,1)`: cardinalidade mínima e máxima
- Preenchimento verde: elemento novo na entrega final

### Como editar

O DER v2 é gerado com [Graphviz](https://graphviz.org/) a partir de [`v2/gerar_der.py`](v2/gerar_der.py), que contém as entidades, os atributos, os relacionamentos e as cardinalidades em listas fáceis de alterar.

```bash
cd docs/der/v2
python3 gerar_der.py
dot -Tpng -Gdpi=110 der-v2-visao-geral.dot -o der-v2-visao-geral.png
for f in entidades/*.dot; do dot -Tpng -Gdpi=100 "$f" -o "${f%.dot}.png"; done
python3 montar_paginas.py      # páginas de atributos e PDF (requer Pillow)
```
