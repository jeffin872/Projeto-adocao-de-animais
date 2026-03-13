/*PROJETO: Sistema de Adoção de Animais */
/*
 * Para não da erro na reexecução eu apago todas as tabelas para que sejam criadas novas, (se não fizer isso da erro) para fim de testes das tabelas 
*/
DROP TABLE IF EXISTS devolucao CASCADE;
DROP TABLE IF EXISTS adocao CASCADE;
DROP TABLE IF EXISTS reserva CASCADE;
DROP TABLE IF EXISTS fila_espera CASCADE;
DROP TABLE IF EXISTS historico_animal CASCADE;
DROP TABLE IF EXISTS animal CASCADE;
DROP TABLE IF EXISTS adotante CASCADE;

/*Criando tabelas que não dependem de chaave estrangeiras primeiro
 * para que na hora se executar não dê erro de criar uma tabela onde a referência não existe
 */

create table adotante (
	id_adotante SERIAL primary key,
	email VARCHAR(150) unique not null, 
	nome VARCHAR(100) not null,
	idade INTEGER not null,
	tipo_moradia VARCHAR(20) not null,
	area_util_m2 DECIMAL(10,2) not null,
	possui_criancas BOOLEAN default false,
	possui_animais BOOLEAN default false,
	data_cadastro timestamp default CURRENT_TIMESTAMP
);

create table animal (
	id_animal SERIAL primary key,
	nome VARCHAR(100) not null,
	especie VARCHAR(30) not null,
	raca VARCHAR(60),
	sexo CHAR(1) not null check (sexo in ('M', 'F')),
	idade_meses INTEGER,
	porte CHAR(1) not null check (porte in ('P', 'M', 'G')), /*verificação pra garantir que o dado seja correto*/
	temperamento TEXT, /* Usei o TEXT em vez do VARCHAR, porque o text não vai ter um limite como o varchar, e o texto pode vir grande por causa de algum evento no historico do animal*/
	status VARCHAR(20) not null default 'DISPONIVEL'
	check (status in('DISPONIVEL', 'RESERVADO', 'ADOTADO', 'DEVOLVIDO', 'QUARENTENA', 'INADOTAVEL')),
	data_entrada DATE default CURRENT_DATE
	);


/* A partir daqui são tabelas que possuem FKs*/
create table historico_animal (
	id_historico SERIAL primary key, 
	id_animal integer not null,
	tipo_evento VARCHAR(100) not null,
	descricao TEXT,
	data_evento timestamp default CURRENT_TIMESTAMP,
	constraint fk_historico_animal foreign key (id_animal)
		references animal(id_animal) on delete restrict
);

create table fila_espera (
	id_fila SERIAL primary key,
	id_animal integer not null,
	id_adotante integer not null,
	pontuacao decimal(5,2) check (pontuacao >= 0 and pontuacao <= 100),
	/* Não sei se o senhor quer um inteiro aqui, então coloquei uma validação para que seja decimal de 0 - 100 com duas casas*/	
	prioridade integer default 0,
	data_entrada_fila timestamp default CURRENT_TIMESTAMP,
	constraint fk_fila_animal foreign key (id_animal) references animal(id_animal) on delete cascade,
	constraint fk_fila_adotante foreign key (id_adotante) 
		references adotante(id_adotante) on delete cascade
);

create table reserva (
	id_reserva SERIAL primary key,
	id_animal integer not null,
	id_adotante integer not null,
	data_inicio timestamp default CURRENT_TIMESTAMP,
	data_fim timestamp not null check (data_fim > data_inicio),
	status_reserva varchar(20) default 'ATIVA',
	constraint fk_reserva_animal foreign key (id_animal) references animal(id_animal) on delete cascade,
	constraint fk_reserva_adotante foreign key (id_adotante) 
		references adotante(id_adotante) on delete cascade
);

create table adocao (
	id_adocao SERIAL primary key,
	id_animal integer not null,
	id_adotante integer not null,
	data_adocao DATE default CURRENT_DATE,
	taxa_adocao DECIMAL(10,2),
	estrategia_taxa VARCHAR(50),
	contrato_texto TEXT,
	/*Uso o delete restrict aqui porque um animal não pode ser apagado se existir registro dele em alguma tabela*/
	constraint fk_adocao_animal foreign key (id_animal) references animal(id_animal) on delete restrict,
	constraint fk_adocao_adotante foreign key (id_adotante) references adotante(id_adotante) on delete restrict
);

create table devolucao(
	id_devolucao SERIAL primary key,
	id_adocao integer unique not null,
	data_devolucao DATE default CURRENT_DATE,
	motivo TEXT,
	novo_status VARCHAR(20) not null default 'DISPONIVEL'
	check (novo_status in('DISPONIVEL', 'RESERVADO', 'ADOTADO', 'DEVOLVIDO', 'QUARENTENA', 'INADOTAVEL')),
	constraint id_devolucao_adocao foreign key (id_adocao) references adocao(id_adocao) on delete restrict 
);

/*--- ------------------------------------------
 * DADOS (INSERTs)
 *--- -----------------------------------------
*/

INSERT INTO adotante (email, nome, idade, tipo_moradia, area_util_m2, possui_criancas, possui_animais) VALUES
('anasilva19@gmail.com','Ana Silva', 28, 'Apartamento', 60.00, false, true),       -- ID 1
('carlossouza20@gmail.com','Carlos Souza', 45, 'Casa', 200.00, true, true),           -- ID 2
('beatrizlima21@gmail.com','Beatriz Lima', 32, 'Apartamento', 45.00, false, false),   -- ID 3
('joaoninguem22@gmail.com','João Ninguém', 22, 'Quarto', 20.00, false, false);        -- ID 4 (Não vai adotar nem reservar nada)

-- 2. Inserindo 5 Animais com status variados
INSERT INTO animal (nome, especie, raca, sexo, idade_meses, porte, temperamento, status) VALUES
('Rex', 'Cachorro', 'Vira-lata', 'M', 36, 'M', 'Dócil e brincalhão', 'ADOTADO'),      -- ID 1
('Luna', 'Gato', 'Siamês', 'F', 12, 'P', 'Arisca', 'DISPONIVEL'),                     -- ID 2
('Thor', 'Cachorro', 'Pitbull', 'M', 48, 'G', 'Protetor', 'RESERVADO'),               -- ID 3
('Mel', 'Gato', 'Persa', 'F', 24, 'P', 'Calma', 'ADOTADO'),                           -- ID 4 (Vou usar essa pra fazer uma devolução)
('Pingo', 'Cachorro', 'Poodle', 'M', 60, 'P', 'Idoso e calmo', 'DISPONIVEL');         -- ID 5

-- 3. Inserindo Histórico Médico 
INSERT INTO historico_animal (id_animal, tipo_evento, descricao) VALUES
(1, 'Vacina', 'Vacina V10 aplicada'),
(1, 'Banho', 'Banho e tosa higiênica'),
(3, 'Comportamento', 'Apresentou agressividade com outros machos'),
(5, 'Veterinário', 'Check-up geriátrico realizado');

-- 4. Inserindo Fila de Espera
INSERT INTO fila_espera (id_animal, id_adotante, pontuacao, prioridade) VALUES
(2, 3, 90.5, 1), -- Beatriz quer a Luna
(5, 1, 80.0, 0), -- Ana quer o Pingo
(3, 1, 50.0, 0); -- Ana também tem interesse no Thor

-- 5. Inserindo Reservas
INSERT INTO reserva (id_animal, id_adotante, data_inicio, data_fim, status_reserva) VALUES
(3, 2, NOW(), NOW() + INTERVAL '5 days', 'ATIVA'),  -- Carlos reservou Thor
(2, 3, NOW() - INTERVAL '10 days', NOW() - INTERVAL '5 days', 'EXPIRADA'); -- Reserva antiga da Beatriz

-- 6. Inserindo Adoções (Aqui validamos o sucesso do sistema)
INSERT INTO adocao (id_animal, id_adotante, taxa_adocao, estrategia_taxa, contrato_texto) VALUES
(1, 1, 50.00, 'Contribuição voluntária', 'Contrato padrão assinado...'), -- Ana adotou Rex
(4, 2, 100.00, 'Taxa completa', 'Contrato especial para raça...'),       -- Carlos adotou Mel
(2, 3, 100.00, 'Taxa completa', 'Contratoo foi assinado para especial'); -- Beatriz adotou a luna
-- 7. Inserindo Devolução (Carlos devolveu a Mel)
INSERT INTO devolucao (id_adocao, motivo, novo_status) VALUES
(2, 'Mudança de país repentina', 'DISPONIVEL'); 

-- Atualizar status da Mel para refletir na devolução 
UPDATE animal SET status = 'DISPONIVEL' WHERE id_animal = 4;


/*--- -------------------------------
 * CONSULTAS (SELECTs)
 *--- ------------------------------- 
*/

/*Primeira consulta:
 * Nessa primeira consulta pego alguns dados da tabela animal e junto com seu historico através do inner, ligados pelo ON no id_animal.
 * E um where para filtrar apenas pela Vacina e Veterinário, que coloquei em um insert anterior,
 * ou seja, "me retorne alguns dados desse animal e com o ID dele me mostre alguns dados de seu histórico filtrados por eventos especificos"
 */

 /*  Análise do explain anaalyze (antes de otimizar)
Ao executar o EXPLAIN ANALYZE nesta consulta, o PostgreSQL utilizou
um Hash Join para relacionar as tabelas animal e historico_animal.

Também foi possível observar que o banco realizou um Seq Scan
(varredura completa) na tabela historico_animal e na tabela animal.
Isso significa que o banco percorreu todas as linhas da tabela para
encontrar os registros que atendem ao filtro do WHERE.

O filtro aplicado foi pelo campo tipo_evento, buscando apenas
os eventos 'Vacina' e 'Veterinário'. */
EXPLAIN ANALYZE
select  
    a.nome AS nome_animal,
    a.especie,
    h.tipo_evento,
    h.descricao,
    h.data_evento
from animal a
inner join historico_animal h on a.id_animal = h.id_animal
where h.tipo_evento in ('Vacina', 'Veterinário');

CREATE INDEX IF NOT EXISTS idx_historico_tipo_evento ON historico_animal(tipo_evento);

-- Atualiza estatísticas
ANALYZE historico_animal;
ANALYZE animal;

-- EXPLAIN ANALYZE DEPOIS - copie o output para o PDF
EXPLAIN ANALYZE
select  
    a.nome AS nome_animal,
    a.especie,
    h.tipo_evento,
    h.descricao,
    h.data_evento
from animal a
inner join historico_animal h on a.id_animal = h.id_animal
where h.tipo_evento in ('Vacina', 'Veterinário');

/*Segunda consulta:
 * Realiza um INNER JOIN triplo (a tabela do from + dois joins) para cruzar os dados da tabela de adoção com os nomes dos adotantes e dos animais.
 * O objetivo aqui é transformar os IDs numéricos em nomes legíveis, filtrando apenas por animais que 
 * possuem o status 'ADOTADO'. Isso garante que o relatório mostre apenas as adoções concluídas.
 */

EXPLAIN ANALYZE
select 
    adot.nome as nome_dono,
    ani.nome as nome_pet,
    ani.especie,
    adoc.data_adocao
from adocao adoc
inner join adotante adot on adoc.id_adotante = adot.id_adotante
inner join animal ani on adoc.id_animal = ani.id_animal
WHERE ani.status = 'ADOTADO';

CREATE index IF NOT EXISTS idx_animal_status ON animal(status);
ANALYZE animal;
ANALYZE adocao;

EXPLAIN ANALYZE
select 
    adot.nome as nome_dono,
    ani.nome as nome_pet,
    ani.especie,
    adoc.data_adocao
from adocao adoc
inner join adotante adot on adoc.id_adotante = adot.id_adotante
inner join animal ani on adoc.id_animal = ani.id_animal
WHERE ani.status = 'ADOTADO';

/*Terceira consulta:
 * Esta consulta une a tabela de reserva com animal e adotante 
 * para verificar quais pets estão "prometidos" e para quem. 
 * O filtro WHERE garante que visualizemos apenas as reservas com status 'ATIVA', ignorando 
 * registros antigos ou expirados.
 */

EXPLAIN ANALYZE
select 
    ani.nome as animal_reservado,
    ani.raca,
    cli.nome as reservado_por,
    res.data_fim as validade_reserva
from reserva res
inner join animal ani on res.id_animal = ani.id_animal
inner join adotante cli on res.id_adotante = cli.id_adotante
WHERE res.status_reserva = 'ATIVA';

CREATE INDEX IF NOT EXISTS idx_reserva_status ON reserva(status_reserva);

ANALYZE reserva;
ANALYZE adotante;

-- EXPLAIN ANALYZE DEPOIS - copie o output para o PDF
EXPLAIN ANALYZE
select
ani.nome as animal_reservado,
ani.raca,
cli.nome as reservado_por,
res.data_fim as validade_reserva
from reserva res
inner join animal ani on res.id_animal = ani.id_animal
inner join adotante cli on res.id_adotante = cli.id_adotante
WHERE res.status_reserva = 'ATIVA';

/*Quarta consulta:
 * Aqui utilizo o LEFT JOIN para gerar um relatório de controle de engajamento dos adotantes.
 * Diferente do INNER, o LEFT JOIN traz TODOS os adotantes cadastrados, mesmo aqueles que ainda 
 * não realizaram nenhuma adoção (que aparecerão com campos nulos nos dados do animal).
 * Se fosse o inner não pegava aquele 'joao ninguem' que coloquei no insert. 
 */
select 
    cli.nome as nome_cliente,
    cli.tipo_moradia,
    ani.nome as animal_adotado,
    adoc.data_adocao
from adotante cli
left join adocao adoc on cli.id_adotante = adoc.id_adotante
left join animal ani on adoc.id_animal = ani.id_animal;


-- ===============================
-- VIEW
-- ===============================
/*
 * View que mostra as adoções concluidas de forma rápida, trazendo nome, email 
 * e data do cadastro do adotante + nome do animal e espécie + data de adoção.
 * Ajuda a não ter que ficar escrevendo esses joins toda hora.
 */
create or replace view adocao_concluida as 
select 
	adot.nome as nome_adotante,
	adot.email,
	adot.data_cadastro as data_cadast_adot,
	ani.nome as nome_pet,
	ani.especie,
	adoc.data_adocao
from adocao adoc
inner join adotante adot on adoc.id_adotante = adot.id_adotante
inner join animal ani on adoc.id_animal = ani.id_animal;

select * from adocao_concluida;
-- ===============================
-- VIEW MATERIALIZADA
-- ===============================
/*
 * Vou usar uma materialized view aqui pra fazer um relatório de estatística.
 * Ela vai agrupar (GROUP BY) as adoções por espécie e contar quantos bichos foram 
 * adotados e a média de taxa. Como salva um "print" físico da tabela, carrega bem mais rápido.
 */
create materialized view mv_estatistica_por_especie as
select 
	ani.especie,
	count(adoc.id_adocao) as total_adocoes,
	avg(adoc.taxa_adocao) as media_taxa
from animal ani
inner join adocao adoc on ani.id_animal = adoc.id_animal
group by ani.especie;

/* o senhor pode dar o refresh para atualizar os dados, vi que quando você cria um animal novo ela não te mostra os dados na hora tem que atualizar*/
/* refresh materialized view mv_estatistica_por_especie; */ 
SELECT * FROM mv_estatistica_por_especie;

-- ===============================
-- TRIGGERS
-- ===============================

/* * 1) TRIGGER BEFORE:
 * Esse gatilho roda ANTES de salvar no banco. Vou usar ele pra pegar o nome do 
 * animal que o usuário digitou e forçar a primeira letra ficar maiúscula (Capitalize),
 * assim o banco fica sempre padronizado e bonitinho, mesmo se digitarem tudo minúsculo.
 */
create or replace function padronizar_nome_animal()
returns trigger as $$
begin
	-- A função INITCAP() deixa a primeira letra maiúscula e o resto minúsculo (ex: REX -> Rex)
	new.nome = initcap(new.nome);
	return new;
end;
$$ language plpgsql;

create trigger antes_insert_animal
before insert or update on animal
for each row
execute function padronizar_nome_animal();


/* * 2) TRIGGER AFTER:
 * Esse é o trigger pra ficar escutando o insert de adoção. 
 * Assim que acontecer a adoção, ele chama a função para atualizar o status do animal para ADOTADO.
 */
create or replace function atualizar_status_adocao()
returns trigger as $$	
begin
	update animal
	set status = 'ADOTADO'
	where id_animal = new.id_animal;
	
	return new;
end;				
$$ language plpgsql;

create trigger apos_adocao
after insert on adocao 
for each row  /*uso o for each para percorrer e fazer a ação em todas as rows*/
execute function atualizar_status_adocao();


-- ===============================
-- PROCEDURE
-- ===============================
/*
 * Uma procedure pra ajudar na manutenção do banco. 
 * Se eu rodar o comando CALL limpar_reservas_expiradas(), ela vai buscar todas 
 * as reservas que já passaram da validade e mudar o status do animal de volta 
 * pra 'DISPONIVEL', além de colocar a reserva como 'EXPIRADA'.
 */
create or replace procedure limpar_reservas_expiradas()
language plpgsql
as $$
begin
	-- Volta o animal pra adoção se a reserva dele venceu
	update animal 
	set status = 'DISPONIVEL'
	where id_animal in (
		select id_animal from reserva 
		where data_fim < current_timestamp and status_reserva = 'ATIVA'
	);

	-- Atualiza a tabela de reserva pra mostrar que já venceu
	update reserva 
	set status_reserva = 'EXPIRADA'
	where data_fim < current_timestamp and status_reserva = 'ATIVA';
end;
$$;