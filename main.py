from models import SessionLocal, Adotante, Animal, Adocao, HistoricoAnimal, Reserva
from datetime import datetime, timedelta

def main():
    db = SessionLocal()

    print("\n" + "="*50)
    print(" INICIANDO OPERAÇÕES ORM - SISTEMA DE ADOÇÃO")
    print("="*50 + "\n")

    # ==========================================
    # PARTE 3: OPERAÇÕES CRUD VIA ORM
    # ==========================================

    # 1. CREATE (Inserindo 3 animais)
    print("[CRUD] 1. CREATE - Cadastrando novos pets...")
    novo_animal1 = Animal(nome="Bolinha", especie="Cachorro", raca="Poodle", sexo="F", porte="P", status="DISPONIVEL")
    novo_animal2 = Animal(nome="Garfield", especie="Gato", raca="Persa", sexo="M", porte="M", status="DISPONIVEL")
    novo_animal3 = Animal(nome="Sombra", especie="Gato", raca="SRD", sexo="M", porte="P", status="DISPONIVEL")
    
    db.add_all([novo_animal1, novo_animal2, novo_animal3])
    db.commit()
    print("-> Pets inseridos com sucesso!\n")

    # 2. READ (Listando com ordenação decrescente por ID)
    print("[CRUD] 2. READ - Listando os últimos pets cadastrados:")
    ultimos_pets = db.query(Animal).order_by(Animal.id_animal.desc()).limit(5).all()
    for pet in ultimos_pets:
        print(f"ID: {pet.id_animal} | Nome: {pet.nome} | Espécie: {pet.especie} | Porte: {pet.porte}")
    print("\n")

    # 3. UPDATE (Atualizando o status de um animal)
    print("[CRUD] 3. UPDATE - Colocando 'Garfield' em Quarentena...")
    animal_update = db.query(Animal).filter(Animal.nome == "Garfield").first()
    if animal_update:
        animal_update.status = "QUARENTENA"
        animal_update.temperamento = "Apresentou febre, em observação."
        db.commit()
        print(f"-> Status do {animal_update.nome} alterado para {animal_update.status}!\n")

    # 4. DELETE (Removendo um animal)
    print("[CRUD] 4. DELETE - Removendo o cadastro de 'Sombra'...")
    animal_delete = db.query(Animal).filter(Animal.nome == "Sombra").first()
    if animal_delete:
        db.delete(animal_delete)
        db.commit()
        print(f"-> Animal removido do banco com sucesso!\n")


    # ==========================================
    # PARTE 4: CONSULTAS COM RELACIONAMENTO (Equivalente aos JOINs do seu SQL)
    # ==========================================
    print("="*50)
    print(" CONSULTAS AVANÇADAS COM RELACIONAMENTOS")
    print("="*50 + "\n")

    # Consulta 1: Equivalente a sua 2ª consulta do SQL (Adoções concluídas)
    print("[CONSULTA 1] Relatório de Adoções (JOIN Adocao + Adotante + Animal):")
    adocoes = db.query(Adocao).join(Animal).filter(Animal.status == 'ADOTADO').all()
    for adocao in adocoes:
        print(f"-> Dono: {adocao.adotante.nome} | Pet: {adocao.animal.nome} ({adocao.animal.especie}) | Data: {adocao.data_adocao}")
    if not adocoes:
        print("Nenhuma adoção encontrada no momento.")
    print("\n")

    # Consulta 2: Equivalente a sua 3ª consulta do SQL (Reservas Ativas)
    print("[CONSULTA 2] Pets Prometidos (JOIN Reserva + Animal + Adotante com Filtro):")
    reservas_ativas = db.query(Reserva).filter(Reserva.status_reserva == 'ATIVA').all()
    for reserva in reservas_ativas:
        print(f"-> Reservado: {reserva.animal.nome} | Para: {reserva.adotante.nome} | Válido até: {reserva.data_fim}")
    if not reservas_ativas:
        print("Nenhuma reserva ativa no momento.")
    print("\n")

    # Consulta 3: Filtro + Ordenação Simples
    print("[CONSULTA 3] Top 3 Cachorros Disponíveis (Ordenados pelo nome):")
    cachorros_disp = db.query(Animal).filter(
        Animal.especie == 'Cachorro', 
        Animal.status == 'DISPONIVEL'
    ).order_by(Animal.nome.asc()).limit(3).all()
    
    for pet in cachorros_disp:
         print(f"-> Cachorro Disponível: {pet.nome} | Raça: {pet.raca} | ID: {pet.id_animal}")
    print("\n")

    db.close()

if __name__ == "__main__":
    main()  