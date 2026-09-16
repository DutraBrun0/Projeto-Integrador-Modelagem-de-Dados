# Dicionário de Dados Conceitual - Start Campos

Este dicionário pertence à primeira entrega do Projeto Integrador. Ele descreve os dados no nível conceitual, sem definir tipos de banco, tamanhos, nulidade, chaves primárias ou chaves estrangeiras.

## Cliente

| Atributo | Classificação | Descrição | Regra/observação |
|---|---|---|---|
| `id_cliente` | Identificador | Identifica unicamente o cliente. | Não pode se repetir. |
| `nome` | Simples | Nome completo do cliente. | Obrigatório. |
| `cpf` | Simples | Documento de identificação do cliente. | Não pode se repetir quando informado. |
| `telefone` | Multivalorado | Número usado para contato. | Pode haver mais de um; obrigatório no atendimento online. |
| `email` | Simples | Endereço eletrônico do cliente. | Não pode se repetir quando informado. |
| `data_cadastro` | Simples | Momento em que o cadastro foi realizado. | Gerada no cadastro. |
| `status` | Simples | Situação do cadastro. | Pode indicar ativo ou inativo. |

## PerfilAcesso

| Atributo | Classificação | Descrição | Regra/observação |
|---|---|---|---|
| `id_perfil` | Identificador | Identifica unicamente o perfil. | Não pode se repetir. |
| `nome` | Simples | Nome do conjunto de acessos. | Não pode se repetir. |
| `descricao` | Simples | Explica a finalidade e o alcance do perfil. | Deve permitir compreender as permissões concedidas. |

## Funcionario

| Atributo | Classificação | Descrição | Regra/observação |
|---|---|---|---|
| `id_funcionario` | Identificador | Identifica unicamente o funcionário. | Não pode se repetir. |
| `nome` | Simples | Nome completo do funcionário. | Obrigatório. |
| `cpf` | Simples | Documento do funcionário. | Obrigatório e não pode se repetir. |
| `cargo` | Simples | Função exercida na empresa. | Obrigatório. |
| `email` | Simples | Contato profissional. | Não pode se repetir. |
| `login` | Simples | Identificação usada no acesso ao sistema. | Não pode se repetir. |
| `senha_hash` | Simples | Representação protegida da senha. | A senha em texto puro não deve ser armazenada. |
| `status` | Simples | Situação do funcionário no sistema. | Pode indicar ativo, bloqueado ou inativo. |

## Categoria

| Atributo | Classificação | Descrição | Regra/observação |
|---|---|---|---|
| `id_categoria` | Identificador | Identifica unicamente a categoria. | Não pode se repetir. |
| `nome` | Simples | Nome pelo qual a categoria é conhecida. | Não pode se repetir. |
| `descricao` | Simples | Detalha os tipos de produto classificados. | Opcional. |
| `status` | Simples | Situação da categoria. | Categorias utilizadas devem ser inativadas, não excluídas. |

## Produto

| Atributo | Classificação | Descrição | Regra/observação |
|---|---|---|---|
| `id_produto` | Identificador | Identifica unicamente o produto. | Não pode se repetir. |
| `sku` | Simples | Código interno usado no catálogo. | Não pode se repetir. |
| `nome` | Simples | Nome comercial do produto. | Obrigatório. |
| `descricao` | Simples | Informações que diferenciam modelo e versão. | Opcional. |
| `marca` | Simples | Marca ou fabricante. | Opcional quando não aplicável. |
| `condicao` | Simples | Informa se o SKU é novo ou seminovo. | Cada combinação de modelo e condição utiliza SKU próprio, conforme RN26. |
| `preco_venda` | Simples | Preço atual de venda. | Não pode ser negativo. |
| `estoque_minimo` | Simples | Limite usado para alerta de reposição. | Não pode ser negativo. |
| `controla_serie` | Simples | Informa se as unidades exigem número de série. | Quando verdadeiro, aplica-se a RN25. |
| `status` | Simples | Situação do produto no catálogo. | Produtos com histórico devem ser inativados, não excluídos. |

## Fornecedor

| Atributo | Classificação | Descrição | Regra/observação |
|---|---|---|---|
| `id_fornecedor` | Identificador | Identifica unicamente o fornecedor. | Não pode se repetir. |
| `razao_social` | Simples | Nome jurídico do fornecedor. | Obrigatório. |
| `nome_fantasia` | Simples | Nome comercial utilizado. | Opcional. |
| `cnpj` | Simples | Documento de identificação empresarial. | Não pode se repetir quando informado. |
| `telefone` | Multivalorado | Número usado para contato. | Pode haver mais de um. |
| `email` | Simples | Endereço eletrônico do fornecedor. | Deve possuir formato válido quando informado. |
| `status` | Simples | Situação do fornecedor. | Pode indicar ativo ou inativo. |

## Fornecimento

| Atributo | Classificação | Descrição | Regra/observação |
|---|---|---|---|
| `id_fornecimento` | Identificador | Identifica unicamente a condição de fornecimento. | A combinação entre fornecedor e produto não pode se repetir. |
| `preco_compra` | Simples | Preço oferecido para o produto. | Pertence à relação porque varia conforme o par fornecedor-produto. |
| `prazo_entrega_dias` | Simples | Prazo previsto para entrega. | Pertence à relação porque varia conforme o par fornecedor-produto. |
| `codigo_produto_fornecedor` | Simples | Código utilizado pelo fornecedor. | Pode diferir do SKU interno. |
| `quantidade_minima` | Simples | Menor quantidade aceita na negociação. | Deve ser positiva quando informada. |

## Compra

| Atributo | Classificação | Descrição | Regra/observação |
|---|---|---|---|
| `id_compra` | Identificador | Identifica unicamente a compra. | Não pode se repetir. |
| `data_compra` | Simples | Momento em que a compra foi registrada. | Obrigatório. |
| `numero_documento` | Simples | Número da nota ou comprovante. | Não deve se repetir para o mesmo fornecedor quando informado. |
| `status` | Simples | Etapa atual da compra. | Pode indicar rascunho, confirmada, recebida, divergente ou cancelada. |
| `valor_total` | Derivado | Valor total da compra. | Calculado a partir dos itens. |

## ItemCompra

| Atributo | Classificação | Descrição | Regra/observação |
|---|---|---|---|
| `id_item_compra` | Identificador | Identifica unicamente o item da compra. | Não pode se repetir. |
| `quantidade` | Simples | Quantidade adquirida do produto. | Deve ser maior que zero; deve ser 1 quando houver controle por série. |
| `custo_unitario` | Simples | Valor efetivamente pago por unidade. | Deve ser maior ou igual a zero. |
| `lote` | Simples | Identificação do lote recebido. | Informado quando existente. |
| `numero_serie` | Simples | Identifica a unidade recebida. | Obrigatório quando o produto exigir controle por série. |

## Venda

| Atributo | Classificação | Descrição | Regra/observação |
|---|---|---|---|
| `id_venda` | Identificador | Identifica unicamente a operação comercial. | Não pode se repetir. |
| `data_venda` | Simples | Momento em que a venda foi registrada. | Obrigatório. |
| `canal` | Simples | Indica a origem da venda. | Deve distinguir loja física e atendimento online. |
| `status` | Simples | Etapa atual da operação. | Pode indicar pendente, reservada, paga, concluída ou cancelada. |
| `subtotal` | Derivado | Soma bruta dos itens. | Calculado a partir dos itens da venda. |
| `desconto_total` | Derivado | Soma dos descontos concedidos. | Deve respeitar a política de autorização. |
| `frete` | Simples | Valor cobrado pelo envio. | Deve ser zero quando não houver cobrança. |
| `valor_total` | Derivado | Valor final da venda. | Subtotal menos descontos mais frete. |

## ItemVenda

| Atributo | Classificação | Descrição | Regra/observação |
|---|---|---|---|
| `id_item_venda` | Identificador | Identifica unicamente o item da venda. | Não pode se repetir. |
| `quantidade` | Simples | Quantidade comercializada. | Deve ser positiva, limitada pelo estoque e igual a 1 quando houver controle por série. |
| `preco_unitario` | Simples | Preço praticado na operação. | Preserva o preço histórico da venda. |
| `desconto` | Simples | Valor do desconto no item. | Deve respeitar o limite de autorização. |
| `numero_serie` | Simples | Identifica a unidade entregue. | Obrigatório quando o produto exigir controle individual. |

## Pagamento

| Atributo | Classificação | Descrição | Regra/observação |
|---|---|---|---|
| `id_pagamento` | Identificador | Identifica unicamente o pagamento. | Não pode se repetir. |
| `forma` | Simples | Meio usado para pagamento. | Deve corresponder a uma forma aceita pela empresa. |
| `valor` | Simples | Valor do pagamento. | Deve ser maior que zero. |
| `data_pagamento` | Simples | Momento da confirmação. | Preenchida quando o pagamento for confirmado. |
| `status` | Simples | Situação do pagamento. | Pode indicar pendente, confirmado, recusado ou estornado. |
| `codigo_transacao` | Simples | Referência fornecida pelo meio de pagamento. | Não pode se repetir quando informada. |

## Entrega

| Atributo | Classificação | Descrição | Regra/observação |
|---|---|---|---|
| `id_entrega` | Identificador | Identifica unicamente a entrega. | Não pode se repetir. |
| `modalidade` | Simples | Forma de recebimento escolhida. | Pode indicar entrega local, transportadora ou retirada. |
| `destinatario` | Simples | Pessoa que receberá o produto. | Obrigatório quando houver envio. |
| `endereco` | Composto | Local em que a entrega será realizada. | Pode ser dividido em logradouro, número, complemento, bairro, cidade, estado e CEP. |
| `valor_frete` | Simples | Valor atribuído ao envio. | Não pode ser negativo. |
| `codigo_rastreio` | Simples | Código usado para acompanhar a entrega. | Informado quando a modalidade permitir rastreamento. |
| `status` | Simples | Etapa atual da entrega. | Pode indicar aguardando, separando, enviado, entregue ou devolvido. |
| `data_envio` | Simples | Momento em que o produto foi enviado. | Preenchida quando houver envio. |
| `data_conclusao` | Simples | Momento em que a entrega foi encerrada. | Preenchida na conclusão. |

## MovimentacaoEstoque

| Atributo | Classificação | Descrição | Regra/observação |
|---|---|---|---|
| `id_movimentacao` | Identificador | Identifica unicamente a movimentação. | Não pode se repetir. |
| `tipo` | Simples | Natureza da movimentação. | Pode indicar entrada, saída, reserva, liberação ou ajuste. |
| `quantidade` | Simples | Quantidade movimentada. | Deve ser maior que zero. |
| `data_hora` | Simples | Momento em que ocorreu. | Gerada no registro da operação. |
| `motivo` | Simples | Razão da movimentação. | Obrigatório em ajustes manuais. |
| `saldo_posterior` | Simples | Saldo observado após a movimentação. | Preserva o histórico e não deve ser tratado como atributo derivado. |
| `referencia_origem` | Simples | Identificação do processo que causou a movimentação. | Pode indicar compra, venda, cancelamento ou ajuste. |

## PosVenda

| Atributo | Classificação | Descrição | Regra/observação |
|---|---|---|---|
| `id_pos_venda` | Identificador | Identifica unicamente a solicitação. | Não pode se repetir. |
| `tipo` | Simples | Natureza da solicitação. | Pode indicar troca, devolução ou garantia. |
| `data_solicitacao` | Simples | Momento em que o atendimento foi aberto. | Obrigatório. |
| `motivo` | Simples | Razão informada pelo cliente. | Obrigatório. |
| `status` | Simples | Etapa atual do atendimento. | Pode indicar aberta, em análise, aprovada, recusada ou concluída. |
| `prazo` | Simples | Data limite aplicável. | Definida conforme política vigente. |
| `resolucao` | Simples | Solução ou justificativa final. | Obrigatória quando o atendimento for encerrado. |
| `data_conclusao` | Simples | Momento em que o atendimento foi concluído. | Preenchida no encerramento. |

## Observação para as próximas etapas

Os relacionamentos do DER substituirão as referências por identificadores no modelo lógico. Somente nessa etapa serão definidos chaves primárias, chaves estrangeiras, tipos, tamanhos, nulidade e demais restrições de implementação.
