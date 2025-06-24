
# Configuração do Banco de Dados no Linux

## 1. Instalação do PostgreSQL e Ferramentas Necessárias

Abra o terminal e execute:

```bash
sudo apt update
sudo apt install -y postgresql postgresql-contrib python3 python3-pip
pip3 install Faker
```

## 2. Criação do Banco de Dados site

Troque para o usuário postgres e acesse o psql:

```bash
sudo -i -u postgres
psql
```

No prompt `postgres=#`, crie o banco de dados:

```sql
CREATE DATABASE site WITH OWNER = postgres ENCODING = 'UTF8';
\q
```

## 3. Preparação do Esquema e Inserção de Dados Iniciais

Crie as tabelas:

```bash
psql -d site -U postgres -f create2.sql
```

Insira os dados iniciais:

```bash
psql -d site -U postgres -f insert2.sql
```

## 4. Análise de Consultas (Com Dados Iniciais, Sem Índices)

Para medir o tempo, usaremos `\timing` no psql para exibir informações de tempo.

```bash
sudo -i -u postgres
psql -d site
```

No prompt `site=#`, execute os comandos abaixo:

```sql
\timing on

\i busca/ProfessoresDepartamento.sql
\i busca/MensagensDoProfessor.sql
\i busca/MediaNotasAluno.sql
\i busca/MensagensAlunoParaProfessor.sql
\i busca/MateriaisDidaticosDisciplina.sql
\i busca/RegrasDaDisciplina.sql
\i busca/TodasUnidades.sql

\timing off
```

## 5. Geração e Inserção de Dados em Massa

Gerar dados em massa:

```bash
python3 fill_data.py
```

Insira os dados gerados:

```bash
psql -d site -U postgres -f large_inserts.sql
```

## 6. Análise de Consultas (Com Grande Volume de Dados, Sem Índices)

```sql
\timing on

EXPLAIN ANALYZE \i busca/ProfessoresDepartamento.sql
EXPLAIN ANALYZE \i busca/MensagensDoProfessor.sql
EXPLAIN ANALYZE \i busca/MediaNotasAluno.sql
EXPLAIN ANALYZE \i busca/MensagensAlunoParaProfessor.sql
EXPLAIN ANALYZE \i busca/MateriaisDidaticosDisciplina.sql
EXPLAIN ANALYZE \i busca/RegrasDaDisciplina.sql
EXPLAIN ANALYZE \i busca/TodasUnidades.sql

\timing off
```

## 7. Criação de Índices

Execute o script `indexes.sql`:

```sql
\i indexes.sql
```

## 8. Análise de Consultas (Com Grande Volume de Dados e Índices)

```sql
\timing on

EXPLAIN ANALYZE \i busca/ProfessoresDepartamento.sql
EXPLAIN ANALYZE \i busca/MensagensDoProfessor.sql
EXPLAIN ANALYZE \i busca/MediaNotasAluno.sql
EXPLAIN ANALYZE \i busca/MensagensAlunoParaProfessor.sql
EXPLAIN ANALYZE \i busca/MateriaisDidaticosDisciplina.sql
EXPLAIN ANALYZE \i busca/RegrasDaDisciplina.sql
EXPLAIN ANALYZE \i busca/TodasUnidades.sql

\timing off
```

## 9. Remoção de Índices

```sql
\i drop_indexes.sql
```

## 10. Criação e Visualização das Views

Crie as views:

```bash
psql -d site -U postgres -f ALLVIEWS.sql
```

Visualize as views criadas:

```sql
\dv
```

Consulte uma view específica:

```sql
SELECT * FROM nome_da_sua_view LIMIT 5;
```

## 11. Finalizando

Saia do psql e retorne ao seu usuário normal:

```bash
\q
exit
```

## 12. Executando no pgAdmin (Opcional)

### Instale o pgAdmin

Siga as instruções oficiais para a sua versão do Linux. Geralmente, envolve:

1. Adicionar o repositório do pgAdmin.
2. Instalar via `apt`.

> Veja em: [https://www.pgadmin.org/download/pgadmin-4-apt/](https://www.pgadmin.org/download/pgadmin-4-apt/)

---

### Conecte ao Servidor

1. Abra o **pgAdmin**.
2. Clique em **"Add New Server"** no painel esquerdo.
3. Na aba **General**, dê um nome ao seu servidor (ex: `PostgreSQL Local`).
4. Na aba **Connection**, preencha:
   - **Host name/address:** `localhost`
   - **Port:** `5432` (padrão)
   - **Maintenance database:** `postgres`
   - **Username:** `postgres`
   - **Password:** a senha configurada para o usuário `postgres` (se não configurou, tente deixar em branco ou use a padrão, se houver).
5. Clique em **Save**.

---

### Execute os Scripts

1. No **pgAdmin**, expanda seu servidor e vá até **Databases**.
2. Clique com o botão direito no banco de dados `site` (ou crie-o se ainda não existir via **Databases > Create > Database...**).
3. Clique em **Query Tool** (Ferramenta de Consulta).
4. Cole e execute, um por um, os conteúdos dos seguintes arquivos SQL:
   - `create2.sql`
   - `insert2.sql`
   - `large_inserts.sql`
   - `indexes.sql`
   - `drop_indexes.sql`
   - `ALLVIEWS.sql`

5. Para as **consultas de análise** (arquivos `.sql` na pasta `busca/`):
   - Cole o conteúdo da consulta.
   - Para ver o plano de execução e tempo, utilize `EXPLAIN ANALYZE` antes da consulta.

---

### Visualizar Views

1. Expanda o banco de dados `site`, depois vá para:
   - **Schemas** → **public** → **Views**
2. As views estarão listadas.
3. Para visualizar os dados:
   - Clique com o botão direito na view desejada e selecione:
     - **View/Edit Data → All Rows**
