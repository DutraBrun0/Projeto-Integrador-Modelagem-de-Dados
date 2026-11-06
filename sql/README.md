# Scripts SQL — MySQL

Requisito: **MySQL 8.0.16 ou superior** (versão que aplica as restrições `CHECK`).

| Ordem | Script | Conteúdo |
|:---:|---|---|
| 1 | [`ddl/01_estrutura.sql`](ddl/01_estrutura.sql) | `CREATE DATABASE sistema_comercial` e as 22 tabelas com PK, FK, NOT NULL, UNIQUE, CHECK e DEFAULT |
| 2 | [`dados/02_carga.sql`](dados/02_carga.sql) | Massa de dados: 205 registros de agosto a novembro de 2026 |
| 3 | [`testes/03_testes_integridade.sql`](testes/03_testes_integridade.sql) | 12 tentativas inválidas — **todas devem ser rejeitadas** |
| 4 | [`consultas/04_consultas.sql`](consultas/04_consultas.sql) | SELECT, JOIN, UPDATE, DELETE e consultas gerenciais G1 a G11 |
| 5 | [`auditoria/05_auditoria.sql`](auditoria/05_auditoria.sql) | Consultas de auditoria A1 a A14 |

## Como executar (banco vazio)

**MySQL Workbench:** abra cada arquivo na ordem acima e execute (raio). Para o script 03, que é feito de comandos que devem falhar, marque *Edit > Preferences > SQL Editor > Continue SQL script execution on errors* ou execute um comando por vez.

**Terminal:**

```bash
mysql -u root -p < sql/ddl/01_estrutura.sql
mysql -u root -p < sql/dados/02_carga.sql
mysql -u root -p --force < sql/testes/03_testes_integridade.sql
mysql -u root -p -t < sql/consultas/04_consultas.sql
mysql -u root -p -t < sql/auditoria/05_auditoria.sql
```

O script `01_estrutura.sql` usa `CREATE DATABASE` sem `IF NOT EXISTS`: para executar de novo, apague o banco antes (`DROP DATABASE sistema_comercial;`).

O script 04 altera dados (conclui a venda 13, reajusta preços, exclui a venda 14). Para repetir os testes do zero, execute de novo os scripts 01 e 02.

## Evidências

Salve em [`../evidencias/`](../evidencias/) os prints de:

- execução do 01 e do 02 sem erros;
- cada erro do 03 (código e mensagem), com a regra que ele protegeu;
- resultados das consultas gerenciais e de auditoria.
