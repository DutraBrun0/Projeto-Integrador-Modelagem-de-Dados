## 15. Dicionário de dados

O dicionário de dados apresenta os campos das entidades do sistema, seus respectivos tipos de dados, tamanhos, possibilidade de valores nulos, chaves e regras de negócio.  
Para esta etapa, foram considerados tipos compatíveis com MySQL.

###  Cliente

| Nome do campo | Tipo de dado | Tamanho / precisão | Nulo? | Chave | Descrição / regra de negócio |
|---|---|---|:---:|:---:|---|
| id_cliente | INT | — | NÃO | PK | Identificador único do cliente. |
| nome | VARCHAR | 100 | NÃO | — | Nome completo do cliente. |
| cpf | CHAR | 11 | SIM | UNIQUE | CPF do cliente. Não pode se repetir quando informado. |
| telefone | VARCHAR | 20 | SIM | — | Telefone principal de contato do cliente. |
| email | VARCHAR | 150 | SIM | UNIQUE | E-mail do cliente. Não pode se repetir quando informado. |
| data_cadastro | DATETIME | — | NÃO | — | Data e hora do cadastro do cliente. |
| status | VARCHAR | 20 | NÃO | — | Situação do cadastro, como ativo ou inativo. |

### PerfilAcesso

| Nome do campo | Tipo de dado | Tamanho / precisão | Nulo? | Chave | Descrição / regra de negócio |
|---|---|---|:---:|:---:|---|
| id_perfil | INT | — | NÃO | PK | Identificador único do perfil de acesso. |
| nome | VARCHAR | 50 | NÃO | UNIQUE | Nome do perfil de acesso. |
| descricao | VARCHAR | 255 | NÃO | — | Descrição das permissões do perfil. |

### Funcionario

| Nome do campo | Tipo de dado | Tamanho / precisão | Nulo? | Chave | Descrição / regra de negócio |
|---|---|---|:---:|:---:|---|
| id_funcionario | INT | — | NÃO | PK | Identificador único do funcionário. |
| id_perfil | INT | — | NÃO | FK | Perfil de acesso associado ao funcionário. |
| nome | VARCHAR | 100 | NÃO | — | Nome completo do funcionário. |
| cpf | CHAR | 11 | NÃO | UNIQUE | CPF do funcionário. Não pode se repetir. |
| cargo | VARCHAR | 50 | NÃO | — | Cargo exercido pelo funcionário. |
| email | VARCHAR | 150 | SIM | UNIQUE | E-mail profissional do funcionário. |
| login | VARCHAR | 50 | NÃO | UNIQUE | Login utilizado para acesso ao sistema. |
| senha_hash | VARCHAR | 255 | NÃO | — | Senha armazenada de forma protegida. |
| status | VARCHAR | 20 | NÃO | — | Situação do funcionário no sistema. |

### Categoria

| Nome do campo | Tipo de dado | Tamanho / precisão | Nulo? | Chave | Descrição / regra de negócio |
|---|---|---|:---:|:---:|---|
| id_categoria | INT | — | NÃO | PK | Identificador único da categoria. |
| nome | VARCHAR | 100 | NÃO | UNIQUE | Nome da categoria. |
| descricao | VARCHAR | 255 | SIM | — | Descrição da categoria. |
| status | VARCHAR | 20 | NÃO | — | Situação da categoria. |

### Produto

| Nome do campo | Tipo de dado | Tamanho / precisão | Nulo? | Chave | Descrição / regra de negócio |
|---|---|---|:---:|:---:|---|
| id_produto | INT | — | NÃO | PK | Identificador único do produto. |
| id_categoria | INT | — | NÃO | FK | Categoria à qual o produto pertence. |
| sku | VARCHAR | 30 | NÃO | UNIQUE | Código único do produto no catálogo. |
| nome | VARCHAR | 100 | NÃO | — | Nome comercial do produto. |
| descricao | VARCHAR | 255 | SIM | — | Descrição complementar do produto. |
| marca | VARCHAR | 80 | SIM | — | Marca ou fabricante do produto. |
| condicao | VARCHAR | 20 | NÃO | — | Indica se o produto é novo ou seminovo. |
| preco_venda | DECIMAL | 10,2 | NÃO | — | Preço de venda do produto. Não pode ser negativo. |
| estoque_minimo | INT | — | NÃO | — | Quantidade mínima para alerta de reposição. |
| controla_serie | BOOLEAN | — | NÃO | — | Indica se o produto possui controle por número de série. |
| status | VARCHAR | 20 | NÃO | — | Situação do produto no catálogo. |

### Fornecedor

| Nome do campo | Tipo de dado | Tamanho / precisão | Nulo? | Chave | Descrição / regra de negócio |
|---|---|---|:---:|:---:|---|
| id_fornecedor | INT | — | NÃO | PK | Identificador único do fornecedor. |
| razao_social | VARCHAR | 150 | NÃO | — | Razão social do fornecedor. |
| nome_fantasia | VARCHAR | 100 | SIM | — | Nome comercial do fornecedor. |
| cnpj | CHAR | 14 | SIM | UNIQUE | CNPJ do fornecedor. Não pode se repetir quando informado. |
| telefone | VARCHAR | 20 | SIM | — | Telefone principal de contato. |
| email | VARCHAR | 150 | SIM | — | E-mail do fornecedor. |
| status | VARCHAR | 20 | NÃO | — | Situação do fornecedor. |

### Fornecimento

| Nome do campo | Tipo de dado | Tamanho / precisão | Nulo? | Chave | Descrição / regra de negócio |
|---|---|---|:---:|:---:|---|
| id_fornecimento | INT | — | NÃO | PK | Identificador único do fornecimento. |
| id_fornecedor | INT | — | NÃO | FK | Fornecedor relacionado ao produto. |
| id_produto | INT | — | NÃO | FK | Produto oferecido pelo fornecedor. |
| preco_compra | DECIMAL | 10,2 | NÃO | — | Preço de compra informado pelo fornecedor. |
| prazo_entrega_dias | INT | — | NÃO | — | Prazo previsto para entrega em dias. |
| codigo_produto_fornecedor | VARCHAR | 50 | SIM | — | Código utilizado pelo fornecedor para identificar o produto. |
| quantidade_minima | INT | SIM | — | — | Quantidade mínima exigida para compra. |

**Regra:** a combinação `id_fornecedor + id_produto` não deve se repetir.

### Compra

| Nome do campo | Tipo de dado | Tamanho / precisão | Nulo? | Chave | Descrição / regra de negócio |
|---|---|---|:---:|:---:|---|
| id_compra | INT | — | NÃO | PK | Identificador único da compra. |
| id_fornecedor | INT | — | NÃO | FK | Fornecedor responsável pela compra. |
| id_funcionario | INT | — | NÃO | FK | Funcionário responsável pelo registro da compra. |
| data_compra | DATETIME | — | NÃO | — | Data e hora do registro da compra. |
| numero_documento | VARCHAR | 50 | SIM | — | Número da nota ou documento da compra. |
| status | VARCHAR | 20 | NÃO | — | Situação atual da compra. |
| valor_total | DECIMAL | 10,2 | NÃO | — | Valor total da compra. |

### ItemCompra

| Nome do campo | Tipo de dado | Tamanho / precisão | Nulo? | Chave | Descrição / regra de negócio |
|---|---|---|:---:|:---:|---|
| id_item_compra | INT | — | NÃO | PK | Identificador único do item da compra. |
| id_compra | INT | — | NÃO | FK | Compra à qual o item pertence. |
| id_produto | INT | — | NÃO | FK | Produto adquirido na compra. |
| quantidade | INT | — | NÃO | — | Quantidade comprada. Deve ser maior que zero. |
| custo_unitario | DECIMAL | 10,2 | NÃO | — | Custo pago por unidade do produto. |
| lote | VARCHAR | 50 | SIM | — | Identificação do lote, quando aplicável. |
| numero_serie | VARCHAR | 100 | SIM | — | Número de série do produto, quando aplicável. |

### Venda

| Nome do campo | Tipo de dado | Tamanho / precisão | Nulo? | Chave | Descrição / regra de negócio |
|---|---|---|:---:|:---:|---|
| id_venda | INT | — | NÃO | PK | Identificador único da venda. |
| id_cliente | INT | — | SIM | FK | Cliente associado à venda. Pode ser nulo em venda presencial sem identificação. |
| id_funcionario | INT | — | NÃO | FK | Funcionário responsável pela venda. |
| data_venda | DATETIME | — | NÃO | — | Data e hora da venda. |
| canal | VARCHAR | 20 | NÃO | — | Canal da venda, como físico ou online. |
| status | VARCHAR | 20 | NÃO | — | Situação atual da venda. |
| subtotal | DECIMAL | 10,2 | NÃO | — | Soma dos itens antes dos descontos. |
| desconto_total | DECIMAL | 10,2 | NÃO | — | Total dos descontos aplicados. |
| frete | DECIMAL | 10,2 | NÃO | — | Valor do frete da venda. |
| valor_total | DECIMAL | 10,2 | NÃO | — | Valor final da venda. |

### ItemVenda

| Nome do campo | Tipo de dado | Tamanho / precisão | Nulo? | Chave | Descrição / regra de negócio |
|---|---|---|:---:|:---:|---|
| id_item_venda | INT | — | NÃO | PK | Identificador único do item da venda. |
| id_venda | INT | — | NÃO | FK | Venda à qual o item pertence. |
| id_produto | INT | — | NÃO | FK | Produto vendido. |
| quantidade | INT | — | NÃO | — | Quantidade vendida. Deve ser maior que zero. |
| preco_unitario | DECIMAL | 10,2 | NÃO | — | Preço praticado na venda. |
| desconto | DECIMAL | 10,2 | NÃO | — | Desconto aplicado ao item. |
| numero_serie | VARCHAR | 100 | SIM | — | Número de série, quando o produto possuir controle individual. |

### Pagamento

| Nome do campo | Tipo de dado | Tamanho / precisão | Nulo? | Chave | Descrição / regra de negócio |
|---|---|---|:---:|:---:|---|
| id_pagamento | INT | — | NÃO | PK | Identificador único do pagamento. |
| id_venda | INT | — | NÃO | FK | Venda relacionada ao pagamento. |
| forma | VARCHAR | 30 | NÃO | — | Forma utilizada para pagamento. |
| valor | DECIMAL | 10,2 | NÃO | — | Valor registrado para o pagamento. |
| data_pagamento | DATETIME | SIM | — | — | Data e hora da confirmação do pagamento. |
| status | VARCHAR | 20 | NÃO | — | Situação do pagamento. |
| codigo_transacao | VARCHAR | 100 | SIM | UNIQUE | Código da transação, quando fornecido pelo meio de pagamento. |

### Entrega

| Nome do campo | Tipo de dado | Tamanho / precisão | Nulo? | Chave | Descrição / regra de negócio |
|---|---|---|:---:|:---:|---|
| id_entrega | INT | — | NÃO | PK | Identificador único da entrega. |
| id_venda | INT | — | NÃO | FK | Venda relacionada à entrega. |
| modalidade | VARCHAR | 30 | NÃO | — | Modalidade de recebimento ou envio. |
| destinatario | VARCHAR | 100 | NÃO | — | Pessoa responsável por receber o pedido. |
| logradouro | VARCHAR | 150 | NÃO | — | Rua ou avenida do endereço de entrega. |
| numero | VARCHAR | 10 | NÃO | — | Número do endereço. |
| complemento | VARCHAR | 50 | SIM | — | Complemento do endereço. |
| bairro | VARCHAR | 80 | NÃO | — | Bairro do endereço. |
| cidade | VARCHAR | 80 | NÃO | — | Cidade do endereço. |
| estado | CHAR | 2 | NÃO | — | UF do endereço. |
| cep | CHAR | 8 | NÃO | — | CEP do endereço. |
| valor_frete | DECIMAL | 10,2 | NÃO | — | Valor cobrado pelo frete. |
| codigo_rastreio | VARCHAR | 100 | SIM | — | Código utilizado para rastreamento. |
| status | VARCHAR | 20 | NÃO | — | Situação atual da entrega. |
| data_envio | DATETIME | SIM | — | — | Data e hora do envio. |
| data_conclusao | DATETIME | SIM | — | — | Data e hora da conclusão da entrega. |

### MovimentacaoEstoque

| Nome do campo | Tipo de dado | Tamanho / precisão | Nulo? | Chave | Descrição / regra de negócio |
|---|---|---|:---:|:---:|---|
| id_movimentacao | INT | — | NÃO | PK | Identificador único da movimentação de estoque. |
| id_produto | INT | — | NÃO | FK | Produto relacionado à movimentação. |
| id_funcionario | INT | — | NÃO | FK | Funcionário responsável pela movimentação. |
| tipo | VARCHAR | 20 | NÃO | — | Tipo da movimentação: entrada, saída, reserva, liberação ou ajuste. |
| quantidade | INT | — | NÃO | — | Quantidade movimentada. Deve ser maior que zero. |
| data_hora | DATETIME | — | NÃO | — | Data e hora da movimentação. |
| motivo | VARCHAR | 255 | SIM | — | Motivo da movimentação, obrigatório para ajustes manuais. |
| saldo_posterior | INT | — | NÃO | — | Saldo do estoque após a movimentação. |
| referencia_origem | VARCHAR | 50 | SIM | — | Operação que originou a movimentação, quando aplicável. |

### PosVenda

| Nome do campo | Tipo de dado | Tamanho / precisão | Nulo? | Chave | Descrição / regra de negócio |
|---|---|---|:---:|:---:|---|
| id_pos_venda | INT | — | NÃO | PK | Identificador único da solicitação de pós-venda. |
| id_item_venda | INT | — | NÃO | FK | Item da venda relacionado à solicitação. |
| id_cliente | INT | — | NÃO | FK | Cliente responsável pela solicitação. |
| id_funcionario | INT | — | NÃO | FK | Funcionário responsável pelo atendimento. |
| tipo | VARCHAR | 20 | NÃO | — | Tipo de solicitação: troca, devolução ou garantia. |
| data_solicitacao | DATETIME | — | NÃO | — | Data e hora da abertura da solicitação. |
| motivo | VARCHAR | 255 | NÃO | — | Motivo informado pelo cliente. |
| status | VARCHAR | 20 | NÃO | — | Situação da solicitação. |
| prazo | DATE | — | NÃO | — | Data limite para tratamento da solicitação. |
| resolucao | VARCHAR | 255 | SIM | — | Solução ou justificativa final. |
| data_conclusao | DATETIME | SIM | — | — | Data e hora do encerramento da solicitação. |

### Observações gerais

- `PK` representa **chave primária**.
- `FK` representa **chave estrangeira**.
- `UNIQUE` indica que o valor não deve se repetir.
- Campos financeiros utilizam `DECIMAL(10,2)`.
- Campos de identificação utilizam `INT`.
- Campos de data e hora utilizam `DATETIME`.
- Campos de texto utilizam `VARCHAR` com tamanho definido de acordo com a finalidade.
- As chaves estrangeiras representam os relacionamentos definidos no modelo lógico.
- A entidade `Fornecimento` utiliza `id_fornecedor` e `id_produto` para representar a relação entre fornecedor e produto.
- `Entrega` possui o endereço dividido em campos para representar o atributo composto `endereco` do modelo conceitual.
