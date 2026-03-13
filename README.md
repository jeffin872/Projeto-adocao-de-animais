🐾 Sistema de Adoção de Animais (Implementação ORM)
Este projeto é uma aplicação em Python que utiliza o SQLAlchemy (ORM) para gerenciar um banco de dados PostgreSQL de um sistema de adoção. O objetivo é demonstrar o mapeamento de classes, operações de CRUD e consultas complexas com relacionamentos.

🛠️ Tecnologias Utilizadas
Linguagem: Python 3.10+

Banco de Dados: PostgreSQL

ORM: SQLAlchemy

Driver de Conexão: Psycopg2

🚀 Como Executar o Projeto
1. Configuração do Banco de Dados (DBeaver)
Antes de rodar o código, o esquema do banco precisa existir:

Abra o DBeaver e conecte-se ao seu PostgreSQL.

Crie um banco de dados chamado projeto_db (ou o nome de sua preferência).

Execute o script SQL contido na pasta /sql (arquivo DDL/DML) para criar as tabelas e inserir os dados iniciais.

2. Configuração do Ambiente Python
No terminal, dentro da pasta do projeto, siga os comandos:

Bash
# Criar ambiente virtual
python -m venv venv

# Ativar ambiente virtual
.\venv\Scripts\activate

# Instalar dependências
pip install sqlalchemy psycopg2-binary
3. Ajuste de Conexão
No arquivo models.py, certifique-se de que a DATABASE_URL está correta:
postgresql://usuario:senha@localhost:5432/nome_do_banco

4. Execução
Execute o arquivo principal para ver o ORM em ação:

python main.py

📊 Evidências de Funcionamento
Ao executar o main.py, o sistema realiza automaticamente as etapas exigidas na atividade:

1️⃣ Operações CRUD (Parte 3)
O sistema realiza a inserção de novos pets, lista os registros no terminal, altera o status do animal "Garfield" para quarentena e remove o registro temporário "Sombra".

2️⃣ Consultas com Relacionamento (Parte 4)
O ORM realiza automaticamente os JOINs para gerar os relatórios abaixo:

Exemplo de Saída no Terminal:

Plaintext
==================================================
 CONSULTAS AVANÇADAS COM RELACIONAMENTOS
==================================================

[CONSULTA 1] Relatório de Adoções (JOIN Adocao + Adotante + Animal):
-> Dono: Ana Silva | Pet: Rex (Cachorro) | Data: 2026-03-13
-> Dono: Jefferson Rocha | Pet: Bolinha (Cachorro) | Data: 2026-03-13

[CONSULTA 2] Pets Prometidos (JOIN Reserva + Animal + Adotante):
-> Reservado: Thor | Para: Carlos Souza | Válido até: 2026-03-18

[CONSULTA 3] Filtro + Ordenação (Cachorros Disponíveis):
-> Cachorro Disponível: Pingo | Raça: Poodle | ID: 5
📂 Estrutura do Repositório
models.py: Mapeamento das classes (Entidades) e configuração do Engine.

main.py: Execução das operações CRUD e Consultas ORM.

script_banco.sql: Script DDL/DML para estruturação do PostgreSQL.

requirements.txt: Lista de bibliotecas necessárias.