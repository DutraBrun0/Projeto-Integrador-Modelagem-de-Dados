# Dicionário de Dados — ERP Start Campos

> Representa exatamente o banco implementado em [`sql/ddl/01_estrutura.sql`](../../sql/ddl/01_estrutura.sql) (MySQL 8.0.16 ou superior).
> Se o script mudar, este dicionário deve mudar junto.

## Convenções

- **PK** chave primária · **FK** chave estrangeira (tabela.coluna referenciada e ação ao excluir/alterar) · **NULL** se o valor pode ficar vazio · **UNIQUE** se o valor não se repete.
- Identificadores das tabelas fortes: `INT AUTO_INCREMENT`.
- Valores monetários: `DECIMAL(10,2)`.
- CPF, CNPJ, CEP e telefone são texto (`CHAR`), não número: são identificadores, não quantidades, e podem começar com zero (Aula 9). A massa de dados guarda CPF e CNPJ só com dígitos.
- Valores que não são armazenados e são calculados nas consultas: valor da venda = soma de `Quantidade × (preco_unitario − desconto_unitario)` dos itens; valor da compra = soma de `quantidade × valor_pago` dos itens.
- FK sem ação indicada usa o padrão do MySQL (`RESTRICT`): o registro referenciado não pode ser excluído enquanto estiver em uso.

## Ordem de criação das tabelas

A mesma do script: primeiro as tabelas independentes, depois as que dependem delas.

`cliente` → `categoria` → `cargo` → `forma_Pagamento` → `Nota_Fiscal` → `fornecedor` → `cliente_email` → `cliente_telefone` → `funcionario` → `produto` → `fornecedor_endereco` → `historico_salario` → `estoque` → `funcionario_telefone` → `funcionario_email` → `venda` → `compra` → `movimentacao_estoque` → `item_venda` → `venda_pagamento` → `item_compra` → `pos_venda`

## Tabelas

### cliente

**Descrição:** Clientes da loja.  
**Classificação:** Forte  
**Chave primária:** `id_cliente`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_cliente` | Identificador do cliente. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `sobrenome` | Sobrenome. | VARCHAR | 50 | Não | — | Não | Não | — | — |
| `nome` | Nome. | VARCHAR | 50 | Não | — | Não | Não | — | — |
| `CPF` | CPF, somente dígitos. | CHAR | 11 | Não | — | Não | Sim | — | Não se repete (RF05) |
| `data_nascimento` | Data de nascimento. | DATE | — | Não | — | Sim | Não | — | — |
| `tipo_cliente` | Pessoa física ou jurídica. | VARCHAR | 30 | Não | — | Não | Não | — | CHECK (tipo_cliente IN ('Pessoa Física', 'Pessoa Jurídica')) |

### categoria

**Descrição:** Categorias do catálogo (consoles, jogos e acessórios).  
**Classificação:** Forte  
**Chave primária:** `id_categoria`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_categoria` | Identificador da categoria. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `tipo_categoria` | Nome da categoria. | VARCHAR | 30 | Não | — | Não | Não | — | CHECK (tipo_categoria IN ('JOGOS','ACESSORIOS','CONSOLES')); Lista fechada no CHECK |

### cargo

**Descrição:** Cargos dos funcionários.  
**Classificação:** Forte  
**Chave primária:** `id_cargo`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_cargo` | Identificador do cargo. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `cargo` | Nome do cargo. | VARCHAR | 20 | Não | — | Não | Não | — | CHECK (cargo IN ('VENDEDOR')); Lista fechada no CHECK |

### forma_Pagamento

**Descrição:** Formas de pagamento aceitas.  
**Classificação:** Forte  
**Chave primária:** `id_forma_Pagamento`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_forma_Pagamento` | Identificador da forma de pagamento. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `tipo_forma_pagamento` | Nome da forma de pagamento. | VARCHAR | 30 | Não | — | Não | Não | — | CHECK (tipo_forma_pagamento IN ('CREDITO','DEBITO','PIX','PARCELADO')); RF19 |

### Nota_Fiscal

**Descrição:** Notas fiscais que documentam as compras feitas aos fornecedores.  
**Classificação:** Forte  
**Chave primária:** `id_nota_fiscal`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_nota_fiscal` | Identificador da nota. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `numero_nota` | Número da nota fiscal. | VARCHAR | 50 | Não | — | Não | Sim | — | Não se repete |
| `valor_pago` | Valor total da nota (soma dos itens da compra). | DECIMAL | 10,2 | Não | — | Não | Não | — | Conferido pela auditoria A5 |
| `data_emissao` | Data de emissão da nota. | DATE | — | Não | — | Não | Não | — | — |
| `valor_impostos` | Valor dos impostos destacados na nota. | DECIMAL | 10,2 | Não | — | Não | Não | — | — |

### fornecedor

**Descrição:** Fornecedores de produtos.  
**Classificação:** Forte  
**Chave primária:** `id_fornecedor`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_fornecedor` | Identificador do fornecedor. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `nome_fornecedor` | Nome ou razão social. | VARCHAR | 100 | Não | — | Não | Não | — | — |
| `cnpj` | CNPJ do fornecedor. | CHAR | 18 | Não | — | Não | Sim | — | Não se repete |

### cliente_email

**Descrição:** E-mails dos clientes (atributo multivalorado separado na 1FN).  
**Classificação:** Forte (vinda da 1FN)  
**Chave primária:** `id_cliente_email`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_cliente_email` | Identificador do e-mail. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `email` | Endereço de e-mail. | VARCHAR | 250 | Não | — | Não | Não | — | — |
| `tipo_email` | Comercial ou pessoal. | VARCHAR | 30 | Não | — | Não | Não | — | CHECK (tipo_email IN ('Comercial', 'Pessoal')) |
| `id_cliente` | Cliente dono do e-mail. | INT | — | Não | cliente(id_cliente) · ON DELETE CASCADE | Sim | Não | — | Excluir o cliente exclui seus e-mails |

### cliente_telefone

**Descrição:** Telefones dos clientes (atributo multivalorado separado na 1FN).  
**Classificação:** Forte (vinda da 1FN)  
**Chave primária:** `id_cliente_telefone`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_cliente_telefone` | Identificador do telefone. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `DDD` | Código de área. | CHAR | 3 | Não | — | Não | Não | — | — |
| `DDI` | Código do país. | CHAR | 5 | Não | — | Não | Não | — | — |
| `Codigo_operadora` | Código da operadora para ligação. | CHAR | 5 | Não | — | Sim | Não | — | — |
| `numero` | Número do telefone. | CHAR | 10 | Não | — | Não | Não | — | — |
| `tipo_cliente_telefone` | Residencial, particular ou comercial. | VARCHAR | 30 | Não | — | Não | Não | — | CHECK (tipo_cliente_telefone IN ('RESIDENCIAL', 'PARTICULAR','COMERCIAL')) |
| `id_cliente` | Cliente dono do telefone. | INT | — | Não | cliente(id_cliente) · ON DELETE CASCADE | Não | Não | — | Excluir o cliente exclui seus telefones |

### funcionario

**Descrição:** Funcionários que registram vendas, compras, movimentações e atendimentos.  
**Classificação:** Forte  
**Chave primária:** `id_funcionario`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_funcionario` | Identificador do funcionário. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `nome` | Nome. | VARCHAR | 50 | Não | — | Não | Não | — | — |
| `sobrenome` | Sobrenome. | VARCHAR | 50 | Não | — | Não | Não | — | — |
| `CPF` | CPF do funcionário. | CHAR | 14 | Não | — | Não | Sim | — | Não se repete |
| `data_admissao` | Data de admissão. | DATE | — | Não | — | Não | Não | — | — |
| `id_cargo` | Cargo do funcionário. | INT | — | Não | cargo(id_cargo) · ON DELETE RESTRICT ON UPDATE CASCADE | Não | Não | — | Cargo em uso não pode ser excluído |

### produto

**Descrição:** Produtos comercializados; o seminovo é cadastrado como produto próprio.  
**Classificação:** Forte  
**Chave primária:** `id_Produto`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_Produto` | Identificador do produto. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `Nome_produto` | Nome comercial (o seminovo traz "(seminovo)" no nome). | VARCHAR | 100 | Não | — | Não | Não | — | — |
| `preco_unitario` | Preço de venda de tabela. | DECIMAL | 10,2 | Não | — | Não | Não | — | CHECK (preco_unitario >= 0) |
| `id_Categoria` | Categoria do produto. | INT | — | Não | categoria(id_categoria) · ON DELETE RESTRICT ON UPDATE CASCADE | Não | Não | — | Exatamente uma categoria (RN01) |

### fornecedor_endereco

**Descrição:** Endereços dos fornecedores (sede, filial, armazém, fábrica).  
**Classificação:** Forte (vinda da 1FN)  
**Chave primária:** `id_fornecedor_endereco`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_fornecedor_endereco` | Identificador do endereço. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `cep` | CEP (com hífen). | CHAR | 9 | Não | — | Não | Não | — | — |
| `logradouro` | Rua ou avenida. | VARCHAR | 150 | Não | — | Não | Não | — | — |
| `numero` | Número. | VARCHAR | 20 | Não | — | Não | Não | — | — |
| `bairro` | Bairro. | VARCHAR | 100 | Não | — | Não | Não | — | — |
| `cidade` | Cidade. | VARCHAR | 100 | Não | — | Não | Não | — | — |
| `estado` | UF. | CHAR | 2 | Não | — | Não | Não | — | — |
| `tipo_endereco` | Sede, filial, armazém ou fábrica. | VARCHAR | 30 | Não | — | Não | Não | — | CHECK (tipo_endereco IN ('SEDE', 'FILIAL', 'ARMAZÉM', 'FÁBRICA')) |
| `id_fornecedor` | Fornecedor dono do endereço. | INT | — | Não | fornecedor(id_fornecedor) · ON DELETE CASCADE ON UPDATE CASCADE | Não | Não | — | Excluir o fornecedor exclui seus endereços |

### historico_salario

**Descrição:** Salários de cada funcionário ao longo do tempo.  
**Classificação:** Forte  
**Chave primária:** `id_historico_salario`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_historico_salario` | Identificador do registro. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `salario` | Valor do salário. | DECIMAL | 10,2 | Não | — | Não | Não | — | CHECK (salario >= 0) |
| `data_inicio` | Início da vigência. | DATE | — | Não | — | Não | Não | — | — |
| `data_fim` | Fim da vigência (vazio = salário atual). | DATE | — | Não | — | Sim | Não | — | Auditoria A12 |
| `id_funcionario` | Funcionário. | INT | — | Não | funcionario(id_funcionario) · ON DELETE CASCADE ON UPDATE CASCADE | Não | Não | — | — |

### estoque

**Descrição:** Saldo atual e estoque mínimo de cada produto (1:1 com produto).  
**Classificação:** Forte  
**Chave primária:** `id_estoque`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_estoque` | Identificador do registro de estoque. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `quantidade_atual` | Saldo atual do produto. | INT | — | Não | — | Não | Não | — | CHECK (quantidade_atual >= 0); Nunca negativo (RN05); conferido pela auditoria A7 |
| `quantidade_minima` | Quantidade que dispara a reposição. | INT | — | Não | — | Não | Não | — | CHECK (quantidade_minima >= 0); RF13 |
| `id_produto` | Produto. | INT | — | Não | produto(id_Produto) · ON DELETE CASCADE ON UPDATE CASCADE | Não | Sim | — | Um registro de estoque por produto (1:1) |

### funcionario_telefone

**Descrição:** Telefones dos funcionários (1FN).  
**Classificação:** Forte (vinda da 1FN)  
**Chave primária:** `id_funcionario_telefone`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_funcionario_telefone` | Identificador do telefone. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `DDD` | Código de área. | CHAR | 3 | Não | — | Não | Não | — | — |
| `DDI` | Código do país. | CHAR | 5 | Não | — | Não | Não | — | — |
| `Codigo_operadora` | Código da operadora. | CHAR | 5 | Não | — | Sim | Não | — | — |
| `numero` | Número do telefone. | CHAR | 10 | Não | — | Não | Não | — | — |
| `tipo_telefone` | Residencial, particular ou comercial. | VARCHAR | 30 | Não | — | Não | Não | — | CHECK (tipo_telefone IN ('RESIDENCIAL', 'PARTICULAR', 'COMERCIAL')) |
| `id_funcionario` | Funcionário dono do telefone. | INT | — | Não | funcionario(id_funcionario) · ON DELETE CASCADE ON UPDATE CASCADE | Não | Não | — | — |

### funcionario_email

**Descrição:** E-mails dos funcionários (1FN).  
**Classificação:** Forte (vinda da 1FN)  
**Chave primária:** `id_funcionario_email`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_funcionario_email` | Identificador do e-mail. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `email` | Endereço de e-mail. | VARCHAR | 250 | Não | — | Não | Não | — | — |
| `tipo_email` | Corporativo ou pessoal. | VARCHAR | 30 | Não | — | Não | Não | — | CHECK (tipo_email IN ('CORPORATIVO', 'PESSOAL')) |
| `id_funcionario` | Funcionário dono do e-mail. | INT | — | Não | funcionario(id_funcionario) · ON DELETE CASCADE ON UPDATE CASCADE | Não | Não | — | — |

### venda

**Descrição:** Vendas realizadas.  
**Classificação:** Forte  
**Chave primária:** `id_venda`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_venda` | Identificador da venda. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `Data_Venda` | Data da venda. | DATE | — | Não | — | Sim | Não | — | — |
| `Status_Venda` | Situação da venda no ciclo de vida. | VARCHAR | 30 | Não | — | Não | Não | — | CHECK (Status_Venda IN ('CONCLUIDO','PENDENTE','EM ANDAMENTO')); EM ANDAMENTO permite venda sem itens; CONCLUIDO exige item (RN03, auditoria A1) |
| `id_Cliente` | Cliente da venda. | INT | — | Não | cliente(id_Cliente) · ON DELETE RESTRICT ON UPDATE CASCADE | Não | Não | — | Toda venda tem cliente (RN08 revisada) |
| `id_Funcionario` | Funcionário que registrou. | INT | — | Não | funcionario(id_funcionario) · ON DELETE RESTRICT ON UPDATE CASCADE | Não | Não | — | RN10 |

### compra

**Descrição:** Compras feitas aos fornecedores.  
**Classificação:** Forte  
**Chave primária:** `id_compra`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_compra` | Identificador da compra. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `data_compra` | Data e hora da compra. | DATETIME | — | Não | — | Sim | Não | CURRENT_TIMESTAMP | — |
| `id_funcionario` | Funcionário responsável. | INT | — | Não | funcionario(id_funcionario) · ON DELETE RESTRICT ON UPDATE CASCADE | Não | Não | — | RN14 |
| `id_fornecedor` | Fornecedor da compra. | INT | — | Não | fornecedor(id_fornecedor) · ON DELETE RESTRICT ON UPDATE CASCADE | Não | Não | — | RN14 |
| `id_nota_fiscal` | Nota fiscal da compra. | INT | — | Não | Nota_Fiscal(id_nota_fiscal) · ON DELETE RESTRICT ON UPDATE CASCADE | Não | Não | — | Uma nota por compra: conferido pela auditoria A6 |

### movimentacao_estoque

**Descrição:** Histórico de entradas, saídas e ajustes de estoque.  
**Classificação:** Forte  
**Chave primária:** `id_movimentacao`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_movimentacao` | Identificador da movimentação. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `tipo_movimentacao` | Entrada, saída ou ajuste. | VARCHAR | 20 | Não | — | Não | Não | — | CHECK (tipo_movimentacao IN ('ENTRADA', 'SAIDA', 'AJUSTE')); RF12; ajustes conferidos pela auditoria A8 |
| `quantidade` | Quantidade movimentada (o sentido vem do tipo). | INT | — | Não | — | Não | Não | — | CHECK (quantidade > 0) |
| `data_movimentacao` | Data e hora da movimentação. | DATETIME | — | Não | — | Sim | Não | — | RNF03 |
| `id_produto` | Produto movimentado. | INT | — | Não | produto(id_Produto) · ON DELETE RESTRICT ON UPDATE CASCADE | Não | Não | — | RN28 |
| `id_funcionario` | Responsável pela movimentação. | INT | — | Não | funcionario(id_funcionario) · ON DELETE RESTRICT ON UPDATE CASCADE | Não | Não | — | RN29 |

### item_venda

**Descrição:** Produtos de cada venda (resolve o N:N Venda × Produto).  
**Classificação:** Associativa  
**Chave primária:** `(id_venda, id_produto)`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `Quantidade` | Quantidade vendida. | INT | — | Não | — | Não | Não | — | CHECK (Quantidade > 0) |
| `preco_unitario` | Preço praticado nesta venda. | DECIMAL | 10,2 | Não | — | Não | Não | — | Pode diferir do preço de tabela |
| `desconto_unitario` | Desconto por unidade. | DECIMAL | 10,2 | Não | — | Não | Não | — | RF17; auditoria A11 |
| `id_venda` | Venda. | INT | — | Sim | venda(id_venda) · ON DELETE CASCADE ON UPDATE CASCADE | Não | Não | — | Excluir a venda exclui seus itens; Parte da PK composta |
| `id_produto` | Produto vendido. | INT | — | Sim | produto(id_Produto) · ON DELETE RESTRICT ON UPDATE CASCADE | Não | Não | — | RN04; Parte da PK composta |

### venda_pagamento

**Descrição:** Pagamentos recebidos em cada venda; uma venda pode ter vários (RN11).  
**Classificação:** Forte  
**Chave primária:** `id_venda_pagamento`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_venda_pagamento` | Identificador do pagamento. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `valor_pago` | Valor recebido. | DECIMAL | 10,2 | Não | — | Não | Não | — | Soma = valor da venda concluída (RN12, auditoria A2) |
| `id_Venda` | Venda paga. | INT | — | Não | venda(id_Venda) · ON DELETE CASCADE ON UPDATE CASCADE | Não | Não | — | RN11 |
| `id_forma_pagamento` | Forma usada. | INT | — | Não | forma_Pagamento(id_forma_Pagamento) · ON DELETE RESTRICT ON UPDATE CASCADE | Não | Não | — | RF19 |

### item_compra

**Descrição:** Produtos de cada compra (resolve o N:N Compra × Produto).  
**Classificação:** Associativa  
**Chave primária:** `(id_compra, id_produto)`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `quantidade` | Quantidade comprada. | INT | — | Não | — | Não | Não | — | CHECK (quantidade > 0) |
| `valor_pago` | Valor pago por unidade. | DECIMAL | 10,2 | Não | — | Não | Não | — | CHECK (valor_pago >= 0) |
| `id_compra` | Compra. | INT | — | Sim | compra(id_compra) · ON DELETE CASCADE ON UPDATE CASCADE | Não | Não | — | Excluir a compra exclui seus itens; Parte da PK composta |
| `id_produto` | Produto comprado. | INT | — | Sim | produto(id_Produto) · ON DELETE RESTRICT ON UPDATE CASCADE | Não | Não | — | RN27; Parte da PK composta |

### pos_venda

**Descrição:** Atendimentos de pós-venda (garantia, devolução, troca, dúvida).  
**Classificação:** Forte  
**Chave primária:** `id_pos_venda`

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra / Restrição |
|---|---|---|---|:---:|---|:---:|:---:|---|---|
| `id_pos_venda` | Identificador do atendimento. | INT | — | Sim | — | Não | Sim | — | AUTO_INCREMENT; Identidade |
| `data_atendimento` | Data e hora do atendimento. | DATETIME | — | Não | — | Sim | Não | — | — |
| `motivo_contato` | Motivo (garantia, devolução, troca, dúvida). | VARCHAR | 100 | Não | — | Não | Não | — | RF23 |
| `descricao_ocorrencia` | Descrição do caso. | TEXT | — | Não | — | Não | Não | — | — |
| `status_atendimento` | Situação do atendimento. | VARCHAR | 30 | Não | — | Não | Não | — | CHECK (status_atendimento IN ('PENDENTE', 'EM ANDAMENTO', 'RESOLVIDO', 'CANCELADO')); Auditoria A13 |
| `id_venda` | Venda atendida. | INT | — | Não | venda(id_venda) · ON DELETE RESTRICT ON UPDATE CASCADE | Não | Não | — | Venda com pós-venda não pode ser excluída (RN22) |
| `id_funcionario` | Funcionário responsável. | INT | — | Não | funcionario(id_funcionario) · ON DELETE RESTRICT ON UPDATE CASCADE | Não | Não | — | RN30 |

## Regras que envolvem mais de uma tabela

Não cabem em PK, FK, UNIQUE ou CHECK (Aula 9). Ficam documentadas e são verificadas pelas consultas de [`sql/auditoria/05_auditoria.sql`](../../sql/auditoria/05_auditoria.sql).

| Regra | Tabelas | Auditoria |
|---|---|---|
| Venda concluída tem ao menos um item (RN03) | venda, item_venda | A1 |
| Pagamentos de uma venda concluída somam o valor da venda (RN12) | venda, item_venda, venda_pagamento | A2 |
| Compra tem ao menos um item (RN15) | compra, item_compra | A4 |
| Valor da nota = soma dos itens da compra | Nota_Fiscal, compra, item_compra | A5 |
| Uma nota fiscal documenta uma única compra | compra | A6 |
| Saldo do estoque = entradas − saídas das movimentações | estoque, movimentacao_estoque | A7 |
| Todo produto tem registro de estoque | produto, estoque | A9 |
| Um único salário em vigor por funcionário | historico_salario | A12 |
