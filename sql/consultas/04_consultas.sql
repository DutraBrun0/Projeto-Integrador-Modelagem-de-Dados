-- =====================================================================
-- ERP START CAMPOS — 04_consultas.sql
-- DML (SELECT, JOIN, UPDATE, DELETE) e consultas gerenciais.
-- Executar depois de 01_estrutura.sql e 02_carga.sql.
--
-- Regra de cálculo usada em todas as consultas de valor:
--   valor de um item de venda = Quantidade × (preco_unitario − desconto_unitario)
--   valor de uma venda        = soma dos seus itens
-- Só entram no faturamento as vendas com Status_Venda = 'CONCLUIDO'.
-- =====================================================================

USE sistema_comercial;

-- =====================================================================
-- PARTE 1 — CONSULTAS BÁSICAS (SELECT e JOIN)
-- =====================================================================

-- Q1. Catálogo: produtos com a categoria, o preço e o saldo em estoque.
SELECT p.id_Produto, p.Nome_produto, c.tipo_categoria, p.preco_unitario,
       e.quantidade_atual, e.quantidade_minima
FROM produto p
JOIN categoria c ON c.id_categoria = p.id_Categoria
LEFT JOIN estoque e ON e.id_produto = p.id_Produto
ORDER BY c.tipo_categoria, p.Nome_produto;

-- Q2. Contatos dos clientes: telefones e e-mails (cliente → tabelas da 1FN).
SELECT cl.id_cliente, CONCAT(cl.nome, ' ', cl.sobrenome) AS cliente,
       t.DDD, t.numero, t.tipo_cliente_telefone, em.email, em.tipo_email
FROM cliente cl
LEFT JOIN cliente_telefone t ON t.id_cliente = cl.id_cliente
LEFT JOIN cliente_email em ON em.id_cliente = cl.id_cliente
ORDER BY cl.id_cliente;

-- Q3. Detalhe de uma venda: cliente, vendedor, itens e valor de cada item (venda 4).
SELECT v.id_venda, v.Data_Venda, v.Status_Venda,
       CONCAT(cl.nome, ' ', cl.sobrenome) AS cliente,
       CONCAT(f.nome, ' ', f.sobrenome) AS vendedor,
       p.Nome_produto, iv.Quantidade, iv.preco_unitario, iv.desconto_unitario,
       iv.Quantidade * (iv.preco_unitario - iv.desconto_unitario) AS valor_item
FROM venda v
JOIN cliente cl ON cl.id_cliente = v.id_Cliente
JOIN funcionario f ON f.id_funcionario = v.id_Funcionario
JOIN item_venda iv ON iv.id_venda = v.id_venda
JOIN produto p ON p.id_Produto = iv.id_produto
WHERE v.id_venda = 4;

-- Q4. Pagamentos de cada venda, com a forma usada (venda com mais de uma forma: RN11).
SELECT vp.id_Venda, fp.tipo_forma_pagamento, vp.valor_pago
FROM venda_pagamento vp
JOIN forma_Pagamento fp ON fp.id_forma_Pagamento = vp.id_forma_pagamento
ORDER BY vp.id_Venda, vp.id_venda_pagamento;

-- Q5. Compras com fornecedor, funcionário responsável e nota fiscal.
SELECT co.id_compra, co.data_compra, fo.nome_fornecedor,
       CONCAT(f.nome, ' ', f.sobrenome) AS responsavel,
       nf.numero_nota, nf.data_emissao, nf.valor_pago AS valor_nota, nf.valor_impostos
FROM compra co
JOIN fornecedor fo ON fo.id_fornecedor = co.id_fornecedor
JOIN funcionario f ON f.id_funcionario = co.id_funcionario
JOIN Nota_Fiscal nf ON nf.id_nota_fiscal = co.id_nota_fiscal
ORDER BY co.data_compra;

-- Q6. Endereços dos fornecedores (um fornecedor pode ter sede, filial, armazém...).
SELECT fo.nome_fornecedor, fe.tipo_endereco, fe.logradouro, fe.numero, fe.cidade, fe.estado
FROM fornecedor fo
JOIN fornecedor_endereco fe ON fe.id_fornecedor = fo.id_fornecedor
ORDER BY fo.nome_fornecedor, fe.tipo_endereco;

-- Q7. Histórico de atendimentos do cliente (RF24): vendas e pós-venda do cliente 2.
SELECT v.id_venda, v.Data_Venda, v.Status_Venda,
       pv.data_atendimento, pv.motivo_contato, pv.status_atendimento
FROM venda v
LEFT JOIN pos_venda pv ON pv.id_venda = v.id_venda
WHERE v.id_Cliente = 2
ORDER BY v.Data_Venda;

-- =====================================================================
-- PARTE 2 — ALTERAÇÕES (UPDATE e DELETE)
-- =====================================================================

-- U1. Concluir a venda 13 depois de receber o restante do pagamento.
--     Primeiro registra o pagamento que faltava (R$ 449,80), depois muda o status.
INSERT INTO venda_pagamento (valor_pago, id_Venda, id_forma_pagamento)
VALUES (449.80, 13, 3);

UPDATE venda
SET Status_Venda = 'CONCLUIDO'
WHERE id_venda = 13;

--     A venda concluída baixa o estoque (RN06): movimentação de saída + saldo.
INSERT INTO movimentacao_estoque (tipo_movimentacao, quantidade, data_movimentacao, id_produto, id_funcionario)
VALUES ('SAIDA', 1, '2026-11-06 10:00:00', 6, 2),
       ('SAIDA', 1, '2026-11-06 10:00:00', 9, 2);

UPDATE estoque SET quantidade_atual = quantidade_atual - 1 WHERE id_produto IN (6, 9);

-- U2. Reajustar em 5% o preço dos jogos (categoria JOGOS).
UPDATE produto
SET preco_unitario = ROUND(preco_unitario * 1.05, 2)
WHERE id_Categoria = (SELECT id_categoria FROM categoria WHERE tipo_categoria = 'JOGOS');

-- U3. Encerrar o atendimento de garantia 1 (headset trocado pelo fabricante).
UPDATE pos_venda
SET status_atendimento = 'RESOLVIDO'
WHERE id_pos_venda = 1;

-- D1. Excluir a venda 14: ficou EM ANDAMENTO, sem itens e sem pagamento (carrinho abandonado).
--     Pode ser excluída porque não é uma operação concluída (RN22).
DELETE FROM venda
WHERE id_venda = 14
  AND Status_Venda = 'EM ANDAMENTO'
  AND NOT EXISTS (SELECT 1 FROM item_venda iv WHERE iv.id_venda = 14)
  AND NOT EXISTS (SELECT 1 FROM venda_pagamento vp WHERE vp.id_Venda = 14);

-- D2. Excluir o e-mail comercial antigo do cliente 1, a pedido dele.
DELETE FROM cliente_email
WHERE id_cliente_email = 2;

-- =====================================================================
-- PARTE 3 — CONSULTAS GERENCIAIS
-- Cada consulta: pergunta do gestor → SQL → decisão que ela apoia.
-- =====================================================================

-- G1. Quais produtos mais vendem, em quantidade e em faturamento?
--     Decisão: priorizar compras e exposição dos campeões de venda.
SELECT p.Nome_produto,
       SUM(iv.Quantidade) AS unidades_vendidas,
       SUM(iv.Quantidade * (iv.preco_unitario - iv.desconto_unitario)) AS faturamento
FROM item_venda iv
JOIN venda v ON v.id_venda = iv.id_venda
JOIN produto p ON p.id_Produto = iv.id_produto
WHERE v.Status_Venda = 'CONCLUIDO'
GROUP BY p.id_Produto, p.Nome_produto
ORDER BY faturamento DESC;

-- G2. Como o faturamento evoluiu mês a mês?
--     Decisão: perceber sazonalidade e planejar estoque para os meses fortes.
SELECT DATE_FORMAT(v.Data_Venda, '%Y-%m') AS mes,
       COUNT(DISTINCT v.id_venda) AS vendas,
       SUM(iv.Quantidade * (iv.preco_unitario - iv.desconto_unitario)) AS faturamento
FROM venda v
JOIN item_venda iv ON iv.id_venda = v.id_venda
WHERE v.Status_Venda = 'CONCLUIDO'
GROUP BY DATE_FORMAT(v.Data_Venda, '%Y-%m')
ORDER BY mes;

-- G3. Qual é o ticket médio das vendas concluídas?
--     Decisão: definir metas e campanhas de venda casada (console + jogo + acessório).
SELECT COUNT(*) AS vendas_concluidas,
       ROUND(AVG(t.valor_venda), 2) AS ticket_medio
FROM (
    SELECT v.id_venda, SUM(iv.Quantidade * (iv.preco_unitario - iv.desconto_unitario)) AS valor_venda
    FROM venda v
    JOIN item_venda iv ON iv.id_venda = v.id_venda
    WHERE v.Status_Venda = 'CONCLUIDO'
    GROUP BY v.id_venda
) t;

-- G4. Quais clientes mais compram?
--     Decisão: programa de fidelidade e ofertas personalizadas.
SELECT CONCAT(cl.nome, ' ', cl.sobrenome) AS cliente,
       COUNT(DISTINCT v.id_venda) AS compras,
       SUM(iv.Quantidade * (iv.preco_unitario - iv.desconto_unitario)) AS total_gasto
FROM cliente cl
JOIN venda v ON v.id_Cliente = cl.id_cliente
JOIN item_venda iv ON iv.id_venda = v.id_venda
WHERE v.Status_Venda = 'CONCLUIDO'
GROUP BY cl.id_cliente, cl.nome, cl.sobrenome
ORDER BY total_gasto DESC;

-- G5. Quais produtos estão abaixo (ou no limite) do estoque mínimo?
--     Decisão: repor antes de faltar (RF13).
SELECT p.Nome_produto, e.quantidade_atual, e.quantidade_minima,
       e.quantidade_minima - e.quantidade_atual AS faltam_para_o_minimo
FROM estoque e
JOIN produto p ON p.id_Produto = e.id_produto
WHERE e.quantidade_atual <= e.quantidade_minima
ORDER BY faltam_para_o_minimo DESC;

-- G6. Qual vendedor mais faturou?
--     Decisão: acompanhar desempenho e definir comissões.
SELECT CONCAT(f.nome, ' ', f.sobrenome) AS vendedor,
       COUNT(DISTINCT v.id_venda) AS vendas,
       SUM(iv.Quantidade * (iv.preco_unitario - iv.desconto_unitario)) AS faturamento
FROM funcionario f
JOIN venda v ON v.id_Funcionario = f.id_funcionario
JOIN item_venda iv ON iv.id_venda = v.id_venda
WHERE v.Status_Venda = 'CONCLUIDO'
GROUP BY f.id_funcionario, f.nome, f.sobrenome
ORDER BY faturamento DESC;

-- G7. Qual é a participação de cada forma de pagamento no valor recebido?
--     Decisão: negociar taxas com as operadoras das formas mais usadas.
SELECT fp.tipo_forma_pagamento,
       COUNT(*) AS pagamentos,
       SUM(vp.valor_pago) AS valor_recebido,
       ROUND(100 * SUM(vp.valor_pago) / (SELECT SUM(valor_pago) FROM venda_pagamento), 1) AS percentual
FROM venda_pagamento vp
JOIN forma_Pagamento fp ON fp.id_forma_Pagamento = vp.id_forma_pagamento
GROUP BY fp.id_forma_Pagamento, fp.tipo_forma_pagamento
ORDER BY valor_recebido DESC;

-- G8. Qual categoria traz mais faturamento?
--     Decisão: distribuir espaço da loja e verba de compras entre consoles, jogos e acessórios.
SELECT c.tipo_categoria,
       SUM(iv.Quantidade) AS unidades,
       SUM(iv.Quantidade * (iv.preco_unitario - iv.desconto_unitario)) AS faturamento
FROM item_venda iv
JOIN venda v ON v.id_venda = iv.id_venda
JOIN produto p ON p.id_Produto = iv.id_produto
JOIN categoria c ON c.id_categoria = p.id_Categoria
WHERE v.Status_Venda = 'CONCLUIDO'
GROUP BY c.id_categoria, c.tipo_categoria
ORDER BY faturamento DESC;

-- G9. Qual é a margem bruta média de cada produto (preço praticado × custo médio de compra)?
--     Decisão: rever preços de produtos com margem baixa.
SELECT p.Nome_produto,
       ROUND(vend.preco_medio_venda, 2) AS preco_medio_venda,
       ROUND(comp.custo_medio, 2) AS custo_medio_compra,
       ROUND(100 * (vend.preco_medio_venda - comp.custo_medio) / vend.preco_medio_venda, 1) AS margem_percentual
FROM produto p
JOIN (SELECT iv.id_produto,
             SUM(iv.Quantidade * (iv.preco_unitario - iv.desconto_unitario)) / SUM(iv.Quantidade) AS preco_medio_venda
      FROM item_venda iv
      JOIN venda v ON v.id_venda = iv.id_venda
      WHERE v.Status_Venda = 'CONCLUIDO'
      GROUP BY iv.id_produto) vend ON vend.id_produto = p.id_Produto
JOIN (SELECT ic.id_produto, SUM(ic.quantidade * ic.valor_pago) / SUM(ic.quantidade) AS custo_medio
      FROM item_compra ic
      GROUP BY ic.id_produto) comp ON comp.id_produto = p.id_Produto
ORDER BY margem_percentual;

-- G10. Quanto a loja comprou de cada fornecedor e quanto pagou de impostos?
--      Decisão: concentrar compras nos fornecedores mais vantajosos.
SELECT fo.nome_fornecedor,
       COUNT(co.id_compra) AS compras,
       SUM(nf.valor_pago) AS total_comprado,
       SUM(nf.valor_impostos) AS total_impostos
FROM fornecedor fo
JOIN compra co ON co.id_fornecedor = fo.id_fornecedor
JOIN Nota_Fiscal nf ON nf.id_nota_fiscal = co.id_nota_fiscal
GROUP BY fo.id_fornecedor, fo.nome_fornecedor
ORDER BY total_comprado DESC;

-- G11. Quais são os motivos de pós-venda e como está o atendimento?
--      Decisão: identificar problemas recorrentes e cobrar prazos da equipe.
SELECT pv.motivo_contato, pv.status_atendimento, COUNT(*) AS atendimentos
FROM pos_venda pv
GROUP BY pv.motivo_contato, pv.status_atendimento
ORDER BY atendimentos DESC;
