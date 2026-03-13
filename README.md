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

3. Ajuste de Conexão:

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

🐾 Sistema de Adoção de Animais (Implementação ORM)
Este projeto foi desenvolvido para organizar e automatizar o dia a dia de uma ONG ou centro de adoção. Em vez de lidar com códigos complexos de banco de dados o tempo todo, utilizamos uma tecnologia chamada ORM (SQLAlchemy), que permite ao sistema "conversar" com o banco de dados de uma forma muito mais natural e eficiente.

O sistema controla desde o cadastro básico dos bichinhos até o histórico final de quem os adotou, garantindo que nenhum dado seja perdido e que a comunicação entre o aplicativo e o PostgreSQL seja perfeita.

🚀 O que o sistema faz na prática?
Ao rodar a aplicação, ela executa automaticamente uma série de tarefas que simulam o uso real do sistema:

Cadastro Inteligente (Create): Registra novos animais (como cães e gatos) e novos adotantes no banco de dados de uma só vez.

Busca e Listagem (Read): Organiza e exibe os animais cadastrados, permitindo saber rapidamente quem está disponível para ganhar um novo lar.

Atualização de Status (Update): Permite mudar informações em tempo real — como colocar um animal em quarentena para cuidados médicos ou marcar como adotado.

Gestão de Registros (Delete): Remove cadastros que não são mais necessários, mantendo o banco de dados limpo e atualizado.

Relatórios Automáticos (Relacionamentos): O sistema consegue "ligar os pontos" sozinho. Ele identifica quem adotou qual animal, quais pets estão prometidos em reservas e gera relatórios prontos para a administração da ONG.

📊 Demonstração do Funcionamento
Abaixo, você pode conferir o log de execução do sistema. Nele, é possível ver o momento exato em que os animais são inseridos, a alteração de status do pet "Garfield" e o processamento das consultas que cruzam os dados de adotantes e animais:

![alt text](<Prints das consultas 1.png>)

![alt text](<Print das consultas 2.png>)