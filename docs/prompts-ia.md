# Uso de IA no Projeto

> Manual da Entrega Final, Etapa 17: "A IA pode auxiliar. A responsabilidade técnica continua sendo do grupo."
> Fluxo adotado: **gerar → testar → validar → corrigir**.

## 1. Onde a IA foi usada

| Item | Como a IA ajudou | O que a equipe definiu | Validação |
|---|---|---|---|
| Massa de dados (`02_carga.sql`) | Geração dos INSERT a partir da estrutura `01_estrutura.sql` | Período, quantidade de registros e situações de negócio a cobrir | Execução em banco vazio; conferência de PK, FK e CHECK; saldo do estoque conferido com as movimentações |
| Testes, consultas e auditoria (`03`, `04`, `05`) | Redação dos comandos a partir das perguntas de negócio | Perguntas do gestor e regras a verificar | Execução e conferência dos resultados com os dados da carga |
| Documentação (DER v2, modelo lógico, normalização, dicionário, README) | Organização do material a partir do manual, das aulas e da devolutiva | Estrutura do banco (`01_estrutura.sql`) e decisões de escopo | Conferência de que DER, modelo lógico, dicionário e SQL representam o mesmo banco |

## 2. Prompts usados na geração da massa de dados

**Prompt 1 — carga principal**

> Com base no script `01_estrutura.sql` (MySQL), gere uma massa de dados coerente para uma loja de videogames, consoles e acessórios, de agosto a novembro de 2026: 8 clientes com telefones e e-mails, 4 funcionários com histórico de salário, 12 produtos (consoles novos e seminovos, jogos e acessórios), 3 fornecedores com endereços, 6 compras com nota fiscal e itens, 15 vendas com itens e pagamentos e 3 atendimentos de pós-venda. Respeite todas as PK, FK e CHECK. O valor da nota deve ser a soma dos itens, os pagamentos de cada venda concluída devem somar o valor da venda, e o saldo de estoque deve ser igual às entradas das compras menos as saídas das vendas concluídas.

**Prompt 2 — situações de teste**

> Inclua na carga: duas vendas pagas com duas formas de pagamento; uma venda pendente com pagamento parcial; uma venda em andamento sem itens; desconto por unidade em alguns itens; uma devolução no pós-venda que volta ao estoque; um reajuste de salário com o registro antigo encerrado; dois produtos abaixo do estoque mínimo. Inclua também três situações para a auditoria encontrar, explicadas em comentário: uma nota com valor maior que os itens, um produto com saldo diferente das movimentações e dois clientes com o mesmo telefone.

## 3. Checklist de validação da massa de dados

- [x] Respeita as PKs (sem duplicidade)
- [x] Respeita as FKs (nenhum registro órfão)
- [x] Respeita as constraints (CHECK, NOT NULL, UNIQUE)
- [x] Faz sentido para o negócio (preços, datas e status coerentes entre si)
- [x] As inconsistências existentes foram colocadas de propósito e estão documentadas no script
- [ ] Executada pela equipe no MySQL, com prints em `evidencias/` — responsável: __________
