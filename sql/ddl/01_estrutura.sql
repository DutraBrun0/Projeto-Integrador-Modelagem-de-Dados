create database sistema_comercial;
use sistema_comercial;	

CREATE TABLE cliente (
id_cliente INT AUTO_INCREMENT PRIMARY KEY,
sobrenome VARCHAR(50) NOT NULL,
nome VARCHAR(50) NOT NULL,
CPF CHAR(11) NOT NULL UNIQUE,
data_nascimento DATE,
tipo_cliente VARCHAR(30) NOT NULL CHECK (tipo_cliente IN ('Pessoa Física', 'Pessoa Jurídica'))
);

CREATE TABLE categoria (
id_categoria INT AUTO_INCREMENT PRIMARY KEY,
tipo_categoria VARCHAR(30) NOT NULL CHECK (tipo_categoria IN ('JOGOS','ACESSORIOS','CONSOLES'))
);

CREATE TABLE cargo (
id_cargo INT AUTO_INCREMENT PRIMARY KEY,
cargo VARCHAR(20) NOT NULL CHECK (cargo IN ('VENDEDOR'))
);

CREATE TABLE forma_Pagamento (
id_forma_Pagamento INT AUTO_INCREMENT PRIMARY KEY,
tipo_forma_pagamento VARCHAR(30) NOT NULL CHECK (tipo_forma_pagamento IN ('CREDITO','DEBITO','PIX','PARCELADO'))
);

CREATE TABLE Nota_Fiscal (
id_nota_fiscal INT AUTO_INCREMENT PRIMARY KEY,
numero_nota VARCHAR(50) NOT NULL UNIQUE,
valor_pago DECIMAL(10,2) NOT NULL,
data_emissao DATE NOT NULL,
valor_impostos DECIMAL(10,2) NOT NULL
);
CREATE TABLE fornecedor (
id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
nome_fornecedor VARCHAR(100) NOT NULL,
cnpj CHAR(18) NOT NULL UNIQUE
);

CREATE TABLE cliente_email (
id_cliente_email INT AUTO_INCREMENT PRIMARY KEY,
email VARCHAR (250) NOT NULL,
tipo_email VARCHAR(30) NOT NULL CHECK (tipo_email IN ('Comercial', 'Pessoal')),
id_cliente INT,
CONSTRAINT fk_cliente_cliente_email FOREIGN KEY (id_cliente) 
REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

CREATE TABLE cliente_telefone (
id_cliente_telefone INT AUTO_INCREMENT PRIMARY KEY,
DDD CHAR(3) NOT NULL,
DDI CHAR(5) NOT NULL,
Codigo_operadora CHAR(5),
numero CHAR(10) NOT NULL,
tipo_cliente_telefone VARCHAR(30) NOT NULL CHECK (tipo_cliente_telefone IN ('RESIDENCIAL', 'PARTICULAR','COMERCIAL')),
id_cliente INT NOT NULL,
CONSTRAINT fk_cliente_cliente_telefone FOREIGN KEY (id_cliente) 
REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

CREATE TABLE funcionario (
id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(50) NOT NULL,
sobrenome VARCHAR(50) NOT NULL,
CPF CHAR(14) NOT NULL UNIQUE,
data_admissao DATE NOT NULL,
id_cargo INT NOT NULL,
CONSTRAINT fk_func_cargo FOREIGN KEY (id_cargo) 
REFERENCES cargo(id_cargo) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE produto (
id_Produto INT AUTO_INCREMENT PRIMARY KEY,
Nome_produto VARCHAR(100) NOT NULL,
preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario >= 0),
id_Categoria INT NOT NULL,
CONSTRAINT fk_produto_categoria FOREIGN KEY (id_Categoria) 
REFERENCES categoria(id_categoria) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE fornecedor_endereco (
id_fornecedor_endereco INT AUTO_INCREMENT PRIMARY KEY,
cep CHAR(9) NOT NULL,
logradouro VARCHAR(150) NOT NULL,
numero VARCHAR(20) NOT NULL,
bairro VARCHAR(100) NOT NULL,
cidade VARCHAR(100) NOT NULL,
estado CHAR(2) NOT NULL,
tipo_endereco VARCHAR(30) NOT NULL CHECK (tipo_endereco IN ('SEDE', 'FILIAL', 'ARMAZÉM', 'FÁBRICA')),
id_fornecedor INT NOT NULL,
CONSTRAINT fk_fornecedor_endereco FOREIGN KEY (id_fornecedor) 
REFERENCES fornecedor(id_fornecedor) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE historico_salario (
id_historico_salario INT AUTO_INCREMENT PRIMARY KEY,
salario DECIMAL(10,2) NOT NULL CHECK (salario >= 0),
data_inicio DATE NOT NULL,
data_fim DATE,
id_funcionario INT NOT NULL,
CONSTRAINT fk_hist_salario_func FOREIGN KEY (id_funcionario) 
REFERENCES funcionario(id_funcionario) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE estoque (
id_estoque INT AUTO_INCREMENT PRIMARY KEY,
quantidade_atual INT NOT NULL CHECK (quantidade_atual >= 0),
quantidade_minima INT NOT NULL CHECK (quantidade_minima >= 0),
id_produto INT NOT NULL UNIQUE,
CONSTRAINT fk_estoque_produto FOREIGN KEY (id_produto) 
REFERENCES produto(id_Produto) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE funcionario_telefone (
id_funcionario_telefone INT AUTO_INCREMENT PRIMARY KEY,
DDD CHAR(3) NOT NULL,
DDI CHAR(5) NOT NULL,
Codigo_operadora CHAR(5),
numero CHAR(10) NOT NULL,
tipo_telefone VARCHAR(30) NOT NULL CHECK (tipo_telefone IN ('RESIDENCIAL', 'PARTICULAR', 'COMERCIAL')),
id_funcionario INT NOT NULL,
CONSTRAINT fk_funcionario_telefone FOREIGN KEY (id_funcionario) 
REFERENCES funcionario(id_funcionario) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE funcionario_email (
id_funcionario_email INT AUTO_INCREMENT PRIMARY KEY,
email VARCHAR(250) NOT NULL,
tipo_email VARCHAR(30) NOT NULL CHECK (tipo_email IN ('CORPORATIVO', 'PESSOAL')),
id_funcionario INT NOT NULL,
CONSTRAINT fk_funcionario_email FOREIGN KEY (id_funcionario) 
REFERENCES funcionario(id_funcionario) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE venda (
id_venda INT AUTO_INCREMENT PRIMARY KEY, 
Data_Venda DATE,
Status_Venda VARCHAR(30) NOT NULL CHECK (Status_Venda IN ('CONCLUIDO','PENDENTE','EM ANDAMENTO')),
id_Cliente INT NOT NULL,
id_Funcionario INT NOT NULL,
CONSTRAINT fk_venda_cliente FOREIGN KEY (id_Cliente) 
REFERENCES cliente(id_Cliente) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk_venda_func FOREIGN KEY (id_Funcionario) 
REFERENCES funcionario(id_funcionario) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE compra (
id_compra INT AUTO_INCREMENT PRIMARY KEY,
data_compra DATETIME DEFAULT CURRENT_TIMESTAMP,
id_funcionario INT NOT NULL,
id_fornecedor INT NOT NULL,
id_nota_fiscal INT NOT NULL,
CONSTRAINT fk_compra_func FOREIGN KEY (id_funcionario) 
REFERENCES funcionario(id_funcionario) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk_compra_forn FOREIGN KEY (id_fornecedor) 
REFERENCES fornecedor(id_fornecedor) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk_compra_notafiscal FOREIGN KEY (id_nota_fiscal) 
REFERENCES Nota_Fiscal(id_nota_fiscal) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE movimentacao_estoque (
id_movimentacao INT AUTO_INCREMENT PRIMARY KEY,
tipo_movimentacao VARCHAR(20) NOT NULL CHECK (tipo_movimentacao IN ('ENTRADA', 'SAIDA', 'AJUSTE')),
quantidade INT NOT NULL CHECK (quantidade > 0),
data_movimentacao DATETIME,
id_produto INT NOT NULL,
id_funcionario INT NOT NULL, 
CONSTRAINT fk_mov_produto FOREIGN KEY (id_produto) 
REFERENCES produto(id_Produto) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk_mov_func FOREIGN KEY (id_funcionario) 
REFERENCES funcionario(id_funcionario) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE item_venda (
Quantidade INT NOT NULL CHECK (Quantidade > 0),
preco_unitario DECIMAL(10,2) NOT NULL,
desconto_unitario DECIMAL(10,2) NOT NULL,
id_venda INT NOT NULL,
id_produto INT NOT NULL,
CONSTRAINT pk_item_venda PRIMARY KEY (id_venda, id_produto),
CONSTRAINT fk_itemvenda_venda FOREIGN KEY (id_venda) REFERENCES venda(id_venda) 
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_itemvenda_produto FOREIGN KEY (id_produto) REFERENCES produto(id_Produto) 
ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE venda_pagamento (
id_venda_pagamento INT AUTO_INCREMENT PRIMARY KEY,
valor_pago DECIMAL(10,2) NOT NULL,
id_Venda INT NOT NULL,
id_forma_pagamento INT NOT NULL,
CONSTRAINT fk_vendapg_venda FOREIGN KEY (id_Venda) 
REFERENCES venda(id_Venda) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_vendapg_forma FOREIGN KEY (id_forma_pagamento) 
REFERENCES forma_Pagamento(id_forma_Pagamento) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE item_compra (
quantidade INT NOT NULL CHECK (quantidade > 0),
valor_pago DECIMAL(10,2) NOT NULL CHECK (valor_pago >= 0),
id_compra INT NOT NULL,
id_produto INT NOT NULL,
CONSTRAINT pk_item_compra PRIMARY KEY (id_compra, id_produto),
CONSTRAINT fk_itemcompra_compra FOREIGN KEY (id_compra) 
REFERENCES compra(id_compra) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_itemcompra_produto FOREIGN KEY (id_produto) 
REFERENCES produto(id_Produto) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE pos_venda (
id_pos_venda INT AUTO_INCREMENT PRIMARY KEY,
data_atendimento DATETIME,
motivo_contato VARCHAR(100) NOT NULL,
descricao_ocorrencia TEXT NOT NULL,
status_atendimento VARCHAR(30) NOT NULL CHECK (status_atendimento IN ('PENDENTE', 'EM ANDAMENTO', 'RESOLVIDO', 'CANCELADO')),
id_venda INT NOT NULL,
id_funcionario INT NOT NULL,
CONSTRAINT fk_posvenda_venda FOREIGN KEY (id_venda) 
REFERENCES venda(id_venda) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk_posvenda_func FOREIGN KEY (id_funcionario) 
REFERENCES funcionario(id_funcionario) ON DELETE RESTRICT ON UPDATE CASCADE
);