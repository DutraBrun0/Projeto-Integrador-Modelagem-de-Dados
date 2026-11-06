-- =====================================================================
-- ERP START CAMPOS — 05_auditoria.sql
-- Consultas de auditoria: procuram situações que merecem verificação.
-- Executar depois de 01_estrutura.sql e 02_carga.sql.
--
-- Cada consulta responde: "O que esta consulta está verificando?"
-- Resultado vazio = nenhuma inconsistência encontrada.
-- Várias regras abaixo envolvem mais de uma tabela e por isso não cabem
-- em PK, FK, UNIQUE ou CHECK (Aula 9): a auditoria é a forma de verificá-las.
-- =====================================================================

USE sistema_comercial;

-- A1. Vendas concluídas sem nenhum item (RN03 — ciclo de vida da venda).
--     A venda pode existir sem itens enquanto está EM ANDAMENTO,
--     mas não pode ser concluída assim.
SELECT v.id_venda, v.Data_Venda, v.Status_Venda
FROM venda v
WHERE v.Status_Venda = 'CONCLUIDO'
  AND NOT EXISTS (SELECT 1 FROM item_venda iv WHERE iv.id_venda = v.id_venda);

-- A2. Vendas concluídas cujo valor pago é diferente do valor da venda (RN12).
SELECT v.id_venda, t.valor_venda, COALESCE(p.valor_pago, 0) AS valor_pago,
       t.valor_venda - COALESCE(p.valor_pago, 0) AS diferenca
FROM venda v
JOIN (SELECT id_venda, SUM(Quantidade * (preco_unitario - desconto_unitario)) AS valor_venda
      FROM item_venda GROUP BY id_venda) t ON t.id_venda = v.id_venda
LEFT JOIN (SELECT id_Venda, SUM(valor_pago) AS valor_pago
           FROM venda_pagamento GROUP BY id_Venda) p ON p.id_Venda = v.id_venda
WHERE v.Status_Venda = 'CONCLUIDO'
  AND t.valor_venda <> COALESCE(p.valor_pago, 0);

-- A3. Vendas pendentes ou em andamento: o que ainda falta receber.
--     Acompanha vendas paradas e pagamentos parciais.
SELECT v.id_venda, v.Data_Venda, v.Status_Venda,
       COALESCE(t.valor_venda, 0) AS valor_venda,
       COALESCE(p.valor_pago, 0) AS valor_pago,
       COALESCE(t.valor_venda, 0) - COALESCE(p.valor_pago, 0) AS falta_receber
FROM venda v
LEFT JOIN (SELECT id_venda, SUM(Quantidade * (preco_unitario - desconto_unitario)) AS valor_venda
           FROM item_venda GROUP BY id_venda) t ON t.id_venda = v.id_venda
LEFT JOIN (SELECT id_Venda, SUM(valor_pago) AS valor_pago
           FROM venda_pagamento GROUP BY id_Venda) p ON p.id_Venda = v.id_venda
WHERE v.Status_Venda IN ('PENDENTE', 'EM ANDAMENTO')
ORDER BY v.Data_Venda;

-- A4. Compras sem nenhum item (RN15).
SELECT co.id_compra, co.data_compra
FROM compra co
WHERE NOT EXISTS (SELECT 1 FROM item_compra ic WHERE ic.id_compra = co.id_compra);

-- A5. Notas fiscais cujo valor é diferente da soma dos itens da compra.
--     Pode indicar frete, desconto ou erro de digitação: precisa ser conferido.
SELECT co.id_compra, nf.numero_nota, nf.valor_pago AS valor_nota,
       SUM(ic.quantidade * ic.valor_pago) AS soma_itens,
       nf.valor_pago - SUM(ic.quantidade * ic.valor_pago) AS diferenca
FROM compra co
JOIN Nota_Fiscal nf ON nf.id_nota_fiscal = co.id_nota_fiscal
JOIN item_compra ic ON ic.id_compra = co.id_compra
GROUP BY co.id_compra, nf.numero_nota, nf.valor_pago
HAVING nf.valor_pago <> SUM(ic.quantidade * ic.valor_pago);

-- A6. A mesma nota fiscal ligada a mais de uma compra.
--     O banco permite (compra.id_nota_fiscal não é UNIQUE), mas no negócio
--     cada nota documenta uma única compra.
SELECT co.id_nota_fiscal, COUNT(*) AS compras_com_a_mesma_nota
FROM compra co
GROUP BY co.id_nota_fiscal
HAVING COUNT(*) > 1;

-- A7. Saldo do estoque diferente do saldo calculado pelas movimentações.
--     estoque.quantidade_atual é um valor guardado; as movimentações são o histórico.
--     Os dois precisam bater (entradas − saídas).
SELECT p.Nome_produto, e.quantidade_atual AS saldo_registrado,
       COALESCE(m.saldo_movimentacoes, 0) AS saldo_movimentacoes,
       e.quantidade_atual - COALESCE(m.saldo_movimentacoes, 0) AS diferenca
FROM estoque e
JOIN produto p ON p.id_Produto = e.id_produto
LEFT JOIN (SELECT id_produto,
                  SUM(CASE WHEN tipo_movimentacao = 'ENTRADA' THEN quantidade
                           WHEN tipo_movimentacao = 'SAIDA'   THEN -quantidade
                           ELSE 0 END) AS saldo_movimentacoes
           FROM movimentacao_estoque GROUP BY id_produto) m ON m.id_produto = e.id_produto
WHERE e.quantidade_atual <> COALESCE(m.saldo_movimentacoes, 0);

-- A8. Movimentações do tipo AJUSTE (RN17).
--     O tipo AJUSTE não informa se a quantidade entrou ou saiu, e não há campo
--     de motivo: todo ajuste precisa ser conferido manualmente com o responsável.
SELECT m.id_movimentacao, m.data_movimentacao, p.Nome_produto, m.quantidade,
       CONCAT(f.nome, ' ', f.sobrenome) AS responsavel
FROM movimentacao_estoque m
JOIN produto p ON p.id_Produto = m.id_produto
JOIN funcionario f ON f.id_funcionario = m.id_funcionario
WHERE m.tipo_movimentacao = 'AJUSTE';

-- A9. Produtos sem registro de estoque (o produto existe, mas não tem saldo nem mínimo).
SELECT p.id_Produto, p.Nome_produto
FROM produto p
WHERE NOT EXISTS (SELECT 1 FROM estoque e WHERE e.id_produto = p.id_Produto);

-- A10. Possíveis clientes duplicados: mesmo telefone ou mesmo e-mail em cadastros diferentes (RF05).
SELECT 'telefone' AS dado_repetido, CONCAT(t1.DDD, ' ', t1.numero) AS valor,
       t1.id_cliente AS cliente_1, t2.id_cliente AS cliente_2
FROM cliente_telefone t1
JOIN cliente_telefone t2
  ON t1.DDD = t2.DDD AND t1.numero = t2.numero AND t1.id_cliente < t2.id_cliente
UNION ALL
SELECT 'e-mail', e1.email, e1.id_cliente, e2.id_cliente
FROM cliente_email e1
JOIN cliente_email e2
  ON e1.email = e2.email AND e1.id_cliente < e2.id_cliente;

-- A11. Itens vendidos com desconto maior que o preço (valor negativo).
SELECT iv.id_venda, iv.id_produto, iv.preco_unitario, iv.desconto_unitario
FROM item_venda iv
WHERE iv.desconto_unitario > iv.preco_unitario;

-- A12. Funcionários com mais de um salário em vigor (data_fim vazia em mais de um registro).
SELECT hs.id_funcionario, COUNT(*) AS salarios_em_vigor
FROM historico_salario hs
WHERE hs.data_fim IS NULL
GROUP BY hs.id_funcionario
HAVING COUNT(*) > 1;

-- A13. Pós-venda aberto há mais de 30 dias (prazo de atendimento — RN20).
SELECT pv.id_pos_venda, pv.data_atendimento, pv.motivo_contato, pv.status_atendimento,
       DATEDIFF(CURDATE(), pv.data_atendimento) AS dias_em_aberto
FROM pos_venda pv
WHERE pv.status_atendimento IN ('PENDENTE', 'EM ANDAMENTO')
  AND DATEDIFF(CURDATE(), pv.data_atendimento) > 30;

-- A14. Pós-venda registrado para venda que não foi concluída.
SELECT pv.id_pos_venda, v.id_venda, v.Status_Venda
FROM pos_venda pv
JOIN venda v ON v.id_venda = pv.id_venda
WHERE v.Status_Venda <> 'CONCLUIDO';
