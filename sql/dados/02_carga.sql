-- =====================================================================
-- ERP START CAMPOS — 02_carga.sql (massa de dados)
-- Executar depois de 01_estrutura.sql, em banco vazio.
-- Os identificadores são informados explicitamente para que as chaves
-- estrangeiras e as consultas de teste sejam previsíveis.
-- Período simulado: agosto a novembro de 2026.
-- Convenções adotadas (ver dicionário de dados):
--   * item_compra.valor_pago  = valor pago POR UNIDADE;
--   * Nota_Fiscal.valor_pago  = valor total da nota (soma dos itens);
--   * item_venda.desconto_unitario = desconto POR UNIDADE;
--   * valor da venda = soma de Quantidade × (preco_unitario − desconto_unitario);
--   * estoque.quantidade_atual = entradas − saídas registradas em movimentacao_estoque;
--   * CPF e CNPJ armazenados somente com dígitos.
-- =====================================================================

USE sistema_comercial;

-- Categorias (valores aceitos pelo CHECK)
INSERT INTO categoria (id_categoria, tipo_categoria) VALUES
(1, 'CONSOLES'),
(2, 'JOGOS'),
(3, 'ACESSORIOS');

-- Cargo (único valor aceito pelo CHECK)
INSERT INTO cargo (id_cargo, cargo) VALUES
(1, 'VENDEDOR');

-- Formas de pagamento
INSERT INTO forma_Pagamento (id_forma_Pagamento, tipo_forma_pagamento) VALUES
(1, 'CREDITO'),
(2, 'DEBITO'),
(3, 'PIX'),
(4, 'PARCELADO');

-- Clientes
INSERT INTO cliente (id_cliente, sobrenome, nome, CPF, data_nascimento, tipo_cliente) VALUES
(1, 'Oliveira', 'Lucas', '39053344705', '1998-03-14', 'Pessoa Física'),
(2, 'Santos', 'Mariana', '52998224725', '2001-07-22', 'Pessoa Física'),
(3, 'Pereira', 'Gabriel', '11144477735', '1995-11-02', 'Pessoa Física'),
(4, 'Costa', 'Juliana', '27493867055', '1989-05-30', 'Pessoa Física'),
(5, 'Almeida', 'Rafael', '86288366757', '2004-01-18', 'Pessoa Física'),
(6, 'Ribeiro', 'Beatriz', '74625183020', '1999-09-09', 'Pessoa Física'),
(7, 'Souza', 'Thiago', '63157212088', '1992-12-25', 'Pessoa Física'),
(8, 'Souza', 'Camila', '18452769013', '1994-04-11', 'Pessoa Física');

INSERT INTO cliente_email (id_cliente_email, email, tipo_email, id_cliente) VALUES
(1, 'lucas.oliveira@email.com', 'Pessoal', 1),
(2, 'lucas@oliveiratech.com.br', 'Comercial', 1),
(3, 'mariana.santos@email.com', 'Pessoal', 2),
(4, 'gabriel.pereira@email.com', 'Pessoal', 3),
(5, 'juliana.costa@email.com', 'Pessoal', 4),
(6, 'rafa.almeida@email.com', 'Pessoal', 5),
(7, 'bia.ribeiro@email.com', 'Pessoal', 6),
(8, 'thiago.souza@email.com', 'Pessoal', 7),
(9, 'camila.souza@email.com', 'Pessoal', 8);

-- Telefones — clientes 7 e 8 moram juntos e têm o mesmo telefone residencial (aparece na auditoria de duplicidade)
INSERT INTO cliente_telefone (id_cliente_telefone, DDD, DDI, Codigo_operadora, numero, tipo_cliente_telefone, id_cliente) VALUES
(1, '11', '55', '15', '987650001', 'PARTICULAR', 1),
(2, '11', '55', NULL, '33330001', 'COMERCIAL', 1),
(3, '11', '55', '21', '987650002', 'PARTICULAR', 2),
(4, '12', '55', '41', '987650003', 'PARTICULAR', 3),
(5, '11', '55', '15', '987650004', 'PARTICULAR', 4),
(6, '11', '55', '31', '987650005', 'PARTICULAR', 5),
(7, '13', '55', '21', '987650006', 'PARTICULAR', 6),
(8, '11', '55', NULL, '44440007', 'RESIDENCIAL', 7),
(9, '11', '55', NULL, '44440007', 'RESIDENCIAL', 8);

-- Funcionários
INSERT INTO funcionario (id_funcionario, nome, sobrenome, CPF, data_admissao, id_cargo) VALUES
(1, 'Ana', 'Lima', '12345678909', '2024-02-01', 1),
(2, 'Bruno', 'Martins', '98765432100', '2024-06-10', 1),
(3, 'Carla', 'Nunes', '45678912374', '2025-01-15', 1),
(4, 'Diego', 'Ramos', '32165498716', '2025-03-03', 1);

-- Histórico de salários — a funcionária 1 teve reajuste (registro antigo encerrado)
INSERT INTO historico_salario (id_historico_salario, salario, data_inicio, data_fim, id_funcionario) VALUES
(1, 2100.00, '2024-02-01', '2025-01-31', 1),
(2, 2450.00, '2025-02-01', NULL, 1),
(3, 2100.00, '2024-06-10', NULL, 2),
(4, 2100.00, '2025-01-15', NULL, 3),
(5, 2200.00, '2025-03-03', NULL, 4);

INSERT INTO funcionario_telefone (id_funcionario_telefone, DDD, DDI, Codigo_operadora, numero, tipo_telefone, id_funcionario) VALUES
(1, '11', '55', '15', '912340001', 'PARTICULAR', 1),
(2, '11', '55', '15', '912340002', 'PARTICULAR', 2),
(3, '11', '55', '21', '912340003', 'PARTICULAR', 3),
(4, '11', '55', '41', '912340004', 'PARTICULAR', 4),
(5, '11', '55', NULL, '30300000', 'COMERCIAL', 1);

INSERT INTO funcionario_email (id_funcionario_email, email, tipo_email, id_funcionario) VALUES
(1, 'ana@startcampos.com.br', 'CORPORATIVO', 1),
(2, 'bruno@startcampos.com.br', 'CORPORATIVO', 2),
(3, 'carla@startcampos.com.br', 'CORPORATIVO', 3),
(4, 'diego@startcampos.com.br', 'CORPORATIVO', 4),
(5, 'ana.lima@email.com', 'PESSOAL', 1);

-- Produtos (o seminovo é um produto próprio, identificado no nome)
INSERT INTO produto (id_Produto, Nome_produto, preco_unitario, id_Categoria) VALUES
(1, 'PlayStation 5 Slim 825GB', 3799.00, 1),
(2, 'PlayStation 5 Slim 825GB (seminovo)', 2999.00, 1),
(3, 'Xbox Series S 512GB', 2599.00, 1),
(4, 'Nintendo Switch OLED', 2399.00, 1),
(5, 'Nintendo Switch (seminovo)', 1499.00, 1),
(6, 'EA Sports FC 26 - PS5', 299.90, 2),
(7, 'The Legend of Zelda: Tears of the Kingdom', 349.90, 2),
(8, 'Forza Horizon 5 - Xbox', 199.90, 2),
(9, 'Controle DualSense Branco', 449.90, 3),
(10, 'Headset HyperX Cloud Stinger 2', 299.90, 3),
(11, 'Cabo HDMI 2.1 2m', 59.90, 3),
(12, 'Base de carregamento DualSense', 189.90, 3);

-- Fornecedores
INSERT INTO fornecedor (id_fornecedor, nome_fornecedor, cnpj) VALUES
(1, 'Distribuidora GameMax Ltda', '12345678000195'),
(2, 'TecnoImport Eletrônicos S.A.', '98765432000110'),
(3, 'Seminovos Brasil Comércio Ltda', '45678912000133');

-- Endereços — o fornecedor 1 tem sede e armazém
INSERT INTO fornecedor_endereco (id_fornecedor_endereco, cep, logradouro, numero, bairro, cidade, estado, tipo_endereco, id_fornecedor) VALUES
(1, '01310-100', 'Avenida Paulista', '1500', 'Bela Vista', 'São Paulo', 'SP', 'SEDE', 1),
(2, '07034-911', 'Rodovia Hélio Smidt', 's/n', 'Cumbica', 'Guarulhos', 'SP', 'ARMAZÉM', 1),
(3, '88301-000', 'Rua Hercílio Luz', '320', 'Centro', 'Itajaí', 'SC', 'SEDE', 2),
(4, '12245-000', 'Avenida São João', '88', 'Jardim Esplanada', 'São José dos Campos', 'SP', 'SEDE', 3);

-- Notas fiscais de compra — a nota 6 tem R$ 35,00 a mais que a soma dos itens (frete cobrado pelo fornecedor; aparece na auditoria)
INSERT INTO Nota_Fiscal (id_nota_fiscal, numero_nota, valor_pago, data_emissao, valor_impostos) VALUES
(1, '001000001', 21850.00, '2026-08-03', 3933.00),
(2, '002000002', 11970.00, '2026-08-10', 2154.60),
(3, '003000003', 14450.00, '2026-08-17', 2601.00),
(4, '001000004', 13040.00, '2026-09-05', 2347.20),
(5, '001000005', 13210.00, '2026-10-02', 2377.80),
(6, '002000006', 4715.00, '2026-10-20', 848.70);

-- Compras
INSERT INTO compra (id_compra, data_compra, id_funcionario, id_fornecedor, id_nota_fiscal) VALUES
(1, '2026-08-03 10:00:00', 4, 1, 1),
(2, '2026-08-10 14:30:00', 4, 2, 2),
(3, '2026-08-17 09:15:00', 4, 3, 3),
(4, '2026-09-05 11:00:00', 4, 1, 4),
(5, '2026-10-02 16:45:00', 4, 1, 5),
(6, '2026-10-20 10:20:00', 4, 2, 6);

-- Itens das compras (valor_pago por unidade)
INSERT INTO item_compra (quantidade, valor_pago, id_compra, id_produto) VALUES
(5, 3100.00, 1, 1),
(10, 320.00, 1, 9),
(15, 210.00, 1, 6),
(4, 2100.00, 2, 3),
(10, 130.00, 2, 8),
(8, 190.00, 2, 10),
(30, 25.00, 2, 11),
(4, 2300.00, 3, 2),
(5, 1050.00, 3, 5),
(5, 1900.00, 4, 4),
(12, 240.00, 4, 7),
(6, 110.00, 4, 12),
(3, 3080.00, 5, 1),
(10, 205.00, 5, 6),
(6, 320.00, 5, 9),
(2, 2100.00, 6, 3),
(20, 24.00, 6, 11);

-- Vendas — 13 está PENDENTE (pagamento parcial); 14 e 15 estão EM ANDAMENTO (14 ainda sem itens, permitido pelo ciclo de vida)
INSERT INTO venda (id_venda, Data_Venda, Status_Venda, id_Cliente, id_Funcionario) VALUES
(1, '2026-08-12', 'CONCLUIDO', 1, 1),
(2, '2026-08-15', 'CONCLUIDO', 2, 2),
(3, '2026-08-22', 'CONCLUIDO', 3, 1),
(4, '2026-08-28', 'CONCLUIDO', 4, 3),
(5, '2026-09-03', 'CONCLUIDO', 5, 2),
(6, '2026-09-10', 'CONCLUIDO', 1, 1),
(7, '2026-09-18', 'CONCLUIDO', 6, 3),
(8, '2026-09-25', 'CONCLUIDO', 7, 2),
(9, '2026-10-05', 'CONCLUIDO', 2, 1),
(10, '2026-10-12', 'CONCLUIDO', 8, 3),
(11, '2026-10-19', 'CONCLUIDO', 3, 2),
(12, '2026-10-26', 'CONCLUIDO', 4, 1),
(13, '2026-11-02', 'PENDENTE', 5, 2),
(14, '2026-11-04', 'EM ANDAMENTO', 6, 3),
(15, '2026-11-05', 'EM ANDAMENTO', 1, 1);

-- Itens das vendas (desconto_unitario por unidade)
INSERT INTO item_venda (Quantidade, preco_unitario, desconto_unitario, id_venda, id_produto) VALUES
(1, 3799.00, 0, 1, 1),
(1, 449.90, 20.00, 1, 9),
(2, 299.90, 0, 2, 6),
(1, 299.90, 0, 2, 10),
(1, 2999.00, 0, 3, 2),
(1, 2599.00, 0, 4, 3),
(1, 199.90, 0, 4, 8),
(2, 59.90, 0, 5, 11),
(1, 2399.00, 0, 6, 4),
(1, 349.90, 0, 6, 7),
(1, 1499.00, 0, 7, 5),
(2, 449.90, 30.00, 8, 9),
(1, 189.90, 0, 8, 12),
(1, 3799.00, 100.00, 9, 1),
(1, 299.90, 0, 9, 6),
(2, 349.90, 0, 10, 7),
(1, 299.90, 0, 11, 10),
(1, 59.90, 0, 11, 11),
(1, 2599.00, 0, 12, 3),
(1, 299.90, 0, 13, 6),
(1, 449.90, 0, 13, 9),
(1, 189.90, 0, 15, 12);

-- Pagamentos — vendas 4 e 12 foram pagas com duas formas (RN11); a venda 13 tem só um pagamento parcial
INSERT INTO venda_pagamento (id_venda_pagamento, valor_pago, id_Venda, id_forma_pagamento) VALUES
(1, 4228.90, 1, 1),
(2, 899.70, 2, 3),
(3, 2999.00, 3, 4),
(4, 1500.00, 4, 2),
(5, 1298.90, 4, 3),
(6, 119.80, 5, 3),
(7, 2748.90, 6, 1),
(8, 1499.00, 7, 3),
(9, 1029.70, 8, 1),
(10, 3998.90, 9, 4),
(11, 699.80, 10, 2),
(12, 359.80, 11, 3),
(13, 2000.00, 12, 1),
(14, 599.00, 12, 3),
(15, 300.00, 13, 3);

-- Pós-venda
INSERT INTO pos_venda (id_pos_venda, data_atendimento, motivo_contato, descricao_ocorrencia, status_atendimento, id_venda, id_funcionario) VALUES
(1, '2026-09-01 15:00:00', 'Garantia', 'Headset apresentando chiado no lado esquerdo após duas semanas de uso.', 'EM ANDAMENTO', 2, 2),
(2, '2026-09-20 11:30:00', 'Devolução', 'Cliente desistiu da compra dentro do prazo de 7 dias; console devolvido sem marcas de uso.', 'RESOLVIDO', 7, 3),
(3, '2026-10-08 18:10:00', 'Dúvida', 'Cliente pediu orientação para vincular a conta da PSN ao console.', 'RESOLVIDO', 9, 1);

-- Movimentações — entradas das compras, saídas das vendas concluídas (RN06) e entrada da devolução do pós-venda 2
INSERT INTO movimentacao_estoque (id_movimentacao, tipo_movimentacao, quantidade, data_movimentacao, id_produto, id_funcionario) VALUES
(1, 'ENTRADA', 5, '2026-08-03 10:00:00', 1, 4),
(2, 'ENTRADA', 10, '2026-08-03 10:00:00', 9, 4),
(3, 'ENTRADA', 15, '2026-08-03 10:00:00', 6, 4),
(4, 'ENTRADA', 4, '2026-08-10 14:30:00', 3, 4),
(5, 'ENTRADA', 10, '2026-08-10 14:30:00', 8, 4),
(6, 'ENTRADA', 8, '2026-08-10 14:30:00', 10, 4),
(7, 'ENTRADA', 30, '2026-08-10 14:30:00', 11, 4),
(8, 'SAIDA', 1, '2026-08-12 17:00:00', 1, 1),
(9, 'SAIDA', 1, '2026-08-12 17:00:00', 9, 1),
(10, 'SAIDA', 2, '2026-08-15 17:00:00', 6, 2),
(11, 'SAIDA', 1, '2026-08-15 17:00:00', 10, 2),
(12, 'ENTRADA', 4, '2026-08-17 09:15:00', 2, 4),
(13, 'ENTRADA', 5, '2026-08-17 09:15:00', 5, 4),
(14, 'SAIDA', 1, '2026-08-22 17:00:00', 2, 1),
(15, 'SAIDA', 1, '2026-08-28 17:00:00', 3, 3),
(16, 'SAIDA', 1, '2026-08-28 17:00:00', 8, 3),
(17, 'SAIDA', 2, '2026-09-03 17:00:00', 11, 2),
(18, 'ENTRADA', 5, '2026-09-05 11:00:00', 4, 4),
(19, 'ENTRADA', 12, '2026-09-05 11:00:00', 7, 4),
(20, 'ENTRADA', 6, '2026-09-05 11:00:00', 12, 4),
(21, 'SAIDA', 1, '2026-09-10 17:00:00', 4, 1),
(22, 'SAIDA', 1, '2026-09-10 17:00:00', 7, 1),
(23, 'SAIDA', 1, '2026-09-18 17:00:00', 5, 3),
(24, 'ENTRADA', 1, '2026-09-20 12:00:00', 5, 3),
(25, 'SAIDA', 2, '2026-09-25 17:00:00', 9, 2),
(26, 'SAIDA', 1, '2026-09-25 17:00:00', 12, 2),
(27, 'ENTRADA', 3, '2026-10-02 16:45:00', 1, 4),
(28, 'ENTRADA', 10, '2026-10-02 16:45:00', 6, 4),
(29, 'ENTRADA', 6, '2026-10-02 16:45:00', 9, 4),
(30, 'SAIDA', 1, '2026-10-05 17:00:00', 1, 1),
(31, 'SAIDA', 1, '2026-10-05 17:00:00', 6, 1),
(32, 'SAIDA', 2, '2026-10-12 17:00:00', 7, 3),
(33, 'SAIDA', 1, '2026-10-19 17:00:00', 10, 2),
(34, 'SAIDA', 1, '2026-10-19 17:00:00', 11, 2),
(35, 'ENTRADA', 2, '2026-10-20 10:20:00', 3, 4),
(36, 'ENTRADA', 20, '2026-10-20 10:20:00', 11, 4),
(37, 'SAIDA', 1, '2026-10-26 17:00:00', 3, 1);

-- Estoque — saldo igual a entradas − saídas, exceto o cabo HDMI (produto 11): a contagem física achou 1 unidade a menos (aparece na auditoria)
INSERT INTO estoque (id_estoque, quantidade_atual, quantidade_minima, id_produto) VALUES
(1, 6, 3, 1),
(2, 3, 2, 2),
(3, 4, 2, 3),
(4, 4, 5, 4),
(5, 5, 2, 5),
(6, 22, 5, 6),
(7, 9, 4, 7),
(8, 9, 3, 8),
(9, 13, 4, 9),
(10, 6, 3, 10),
(11, 46, 10, 11),
(12, 5, 6, 12);
