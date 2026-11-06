-- =====================================================================
-- ERP START CAMPOS — 03_testes_integridade.sql
-- Aula 9: regra → tentativa inválida → resposta esperada do SGBD.
--
-- TODOS os comandos abaixo DEVEM SER REJEITADOS pelo MySQL.
-- Executar depois de 01_estrutura.sql e 02_carga.sql.
-- No MySQL Workbench, marque "Continue SQL script execution on errors"
-- (Edit > Preferences > SQL Editor) ou execute um comando por vez.
-- No terminal: mysql --force -u root -p < 03_testes_integridade.sql
-- O print de cada erro deve ser salvo na pasta evidencias/.
-- =====================================================================

USE sistema_comercial;

-- ---------------------------------------------------------------------
-- T01 — PRIMARY KEY composta (item_venda)
-- Regra: o mesmo produto aparece uma única vez em cada venda; a quantidade
--        fica no campo Quantidade (PK = id_venda + id_produto).
-- Tentativa: incluir de novo o produto 1 na venda 1.
-- Esperado: ERROR 1062 — Duplicate entry '1-1' for key 'item_venda.PRIMARY'
-- ---------------------------------------------------------------------
INSERT INTO item_venda (Quantidade, preco_unitario, desconto_unitario, id_venda, id_produto)
VALUES (1, 3799.00, 0, 1, 1);

-- ---------------------------------------------------------------------
-- T02 — UNIQUE (cliente.CPF)
-- Regra: o CPF não se repete; evita cliente duplicado (RF05).
-- Tentativa: cadastrar outro cliente com o CPF do cliente 1.
-- Esperado: ERROR 1062 — Duplicate entry '39053344705' for key 'cliente.CPF'
-- ---------------------------------------------------------------------
INSERT INTO cliente (sobrenome, nome, CPF, data_nascimento, tipo_cliente)
VALUES ('Oliveira', 'Lucas Duplicado', '39053344705', '1998-03-14', 'Pessoa Física');

-- ---------------------------------------------------------------------
-- T03 — FOREIGN KEY (venda → cliente)
-- Regra: toda venda pertence a um cliente existente.
-- Tentativa: registrar venda para o cliente 999, que não existe.
-- Esperado: ERROR 1452 — Cannot add or update a child row: a foreign key constraint fails (fk_venda_cliente)
-- ---------------------------------------------------------------------
INSERT INTO venda (Data_Venda, Status_Venda, id_Cliente, id_Funcionario)
VALUES ('2026-11-06', 'EM ANDAMENTO', 999, 1);

-- ---------------------------------------------------------------------
-- T04 — FOREIGN KEY (item_compra → produto)
-- Regra: todo item de compra se refere a um produto cadastrado (RN27).
-- Tentativa: item de compra com o produto 500, inexistente.
-- Esperado: ERROR 1452 — foreign key constraint fails (fk_itemcompra_produto)
-- ---------------------------------------------------------------------
INSERT INTO item_compra (quantidade, valor_pago, id_compra, id_produto)
VALUES (1, 100.00, 1, 500);

-- ---------------------------------------------------------------------
-- T05 — NOT NULL (produto.Nome_produto)
-- Regra: todo produto precisa de nome para ser vendido e consultado.
-- Tentativa: cadastrar produto sem nome.
-- Esperado: ERROR 1048 — Column 'Nome_produto' cannot be null
-- ---------------------------------------------------------------------
INSERT INTO produto (Nome_produto, preco_unitario, id_Categoria)
VALUES (NULL, 99.90, 3);

-- ---------------------------------------------------------------------
-- T06 — CHECK de domínio (item_venda.Quantidade > 0)
-- Regra: não existe venda de quantidade zero ou negativa.
-- Tentativa: item com quantidade -2 na venda 15.
-- Esperado: ERROR 3819 — Check constraint 'item_venda_chk_1' is violated
-- ---------------------------------------------------------------------
INSERT INTO item_venda (Quantidade, preco_unitario, desconto_unitario, id_venda, id_produto)
VALUES (-2, 59.90, 0, 15, 11);

-- ---------------------------------------------------------------------
-- T07 — CHECK de domínio (venda.Status_Venda)
-- Regra: o ciclo de vida da venda só admite EM ANDAMENTO, PENDENTE e CONCLUIDO.
-- Tentativa: status 'ENTREGUE', que não faz parte do ciclo.
-- Esperado: ERROR 3819 — Check constraint 'venda_chk_1' is violated
-- ---------------------------------------------------------------------
INSERT INTO venda (Data_Venda, Status_Venda, id_Cliente, id_Funcionario)
VALUES ('2026-11-06', 'ENTREGUE', 1, 1);

-- ---------------------------------------------------------------------
-- T08 — CHECK (estoque.quantidade_atual >= 0) — regra do ERP
-- Regra: o saldo de estoque nunca fica negativo (RN05: não vender mais do que existe).
-- Tentativa: baixar 100 unidades do produto 2, que tem 3 em estoque.
-- Esperado: ERROR 3819 — Check constraint 'estoque_chk_1' is violated
-- ---------------------------------------------------------------------
UPDATE estoque SET quantidade_atual = quantidade_atual - 100 WHERE id_produto = 2;

-- ---------------------------------------------------------------------
-- T09 — UNIQUE (estoque.id_produto) — relacionamento 1:1
-- Regra: cada produto tem um único registro de estoque.
-- Tentativa: criar um segundo registro de estoque para o produto 1.
-- Esperado: ERROR 1062 — Duplicate entry '1' for key 'estoque.id_produto'
-- ---------------------------------------------------------------------
INSERT INTO estoque (quantidade_atual, quantidade_minima, id_produto)
VALUES (10, 2, 1);

-- ---------------------------------------------------------------------
-- T10 — ON DELETE RESTRICT (produto usado em venda) — regra do ERP
-- Regra: registros usados em operações não são excluídos (RN22).
-- Tentativa: excluir o produto 1, que já foi vendido.
-- Esperado: ERROR 1451 — Cannot delete or update a parent row: a foreign key constraint fails (uma das FKs que referenciam o produto: item_venda, item_compra ou movimentacao_estoque)
-- ---------------------------------------------------------------------
DELETE FROM produto WHERE id_Produto = 1;

-- ---------------------------------------------------------------------
-- T11 — ON DELETE RESTRICT (venda com pós-venda) — regra do ERP
-- Regra: uma venda com atendimento de pós-venda não pode desaparecer (RN22).
-- Tentativa: excluir a venda 7, que tem a devolução registrada no pós-venda 2.
-- Esperado: ERROR 1451 — foreign key constraint fails (fk_posvenda_venda)
-- ---------------------------------------------------------------------
DELETE FROM venda WHERE id_venda = 7;

-- ---------------------------------------------------------------------
-- T12 — CHECK de domínio (cliente.tipo_cliente)
-- Regra: o cliente é pessoa física ou jurídica.
-- Tentativa: tipo 'Empresa'.
-- Esperado: ERROR 3819 — Check constraint 'cliente_chk_1' is violated
-- ---------------------------------------------------------------------
INSERT INTO cliente (sobrenome, nome, CPF, data_nascimento, tipo_cliente)
VALUES ('Teste', 'Cliente', '00000000191', '2000-01-01', 'Empresa');
