from sqlalchemy import create_engine, Column, Integer, String, Date, DateTime, ForeignKey, Numeric, Boolean, Text, CHAR
from sqlalchemy.orm import declarative_base, relationship, sessionmaker
from datetime import datetime
import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

engine = create_engine(DATABASE_URL, echo=False)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# --- MAPEAMENTO ORM ---

class Adotante(Base):
    __tablename__ = 'adotante'
    id_adotante = Column(Integer, primary_key=True)
    email = Column(String(150), unique=True, nullable=False)
    nome = Column(String(100), nullable=False)
    idade = Column(Integer, nullable=False)
    tipo_moradia = Column(String(20), nullable=False)
    area_util_m2 = Column(Numeric(10, 2), nullable=False)
    possui_criancas = Column(Boolean, default=False)
    possui_animais = Column(Boolean, default=False)
    data_cadastro = Column(DateTime, default=datetime.now)
    
    # Relacionamentos
    adocoes = relationship("Adocao", back_populates="adotante")
    reservas = relationship("Reserva", back_populates="adotante")
    filas = relationship("FilaEspera", back_populates="adotante")

class Animal(Base):
    __tablename__ = 'animal'
    id_animal = Column(Integer, primary_key=True)
    nome = Column(String(100), nullable=False)
    especie = Column(String(30), nullable=False)
    raca = Column(String(60))
    sexo = Column(CHAR(1), nullable=False) # 'M' ou 'F'
    idade_meses = Column(Integer)
    porte = Column(CHAR(1), nullable=False) # 'P', 'M', 'G'
    temperamento = Column(Text)
    status = Column(String(20), default='DISPONIVEL', nullable=False)
    data_entrada = Column(Date, default=datetime.now)
    
    # Relacionamentos
    historicos = relationship("HistoricoAnimal", back_populates="animal")
    adocoes = relationship("Adocao", back_populates="animal")
    reservas = relationship("Reserva", back_populates="animal")
    filas = relationship("FilaEspera", back_populates="animal")

class HistoricoAnimal(Base):
    __tablename__ = 'historico_animal'
    id_historico = Column(Integer, primary_key=True)
    id_animal = Column(Integer, ForeignKey('animal.id_animal', ondelete='RESTRICT'), nullable=False)
    tipo_evento = Column(String(100), nullable=False)
    descricao = Column(Text)
    data_evento = Column(DateTime, default=datetime.now)
    
    animal = relationship("Animal", back_populates="historicos")

class FilaEspera(Base):
    __tablename__ = 'fila_espera'
    id_fila = Column(Integer, primary_key=True)
    id_animal = Column(Integer, ForeignKey('animal.id_animal', ondelete='CASCADE'), nullable=False)
    id_adotante = Column(Integer, ForeignKey('adotante.id_adotante', ondelete='CASCADE'), nullable=False)
    pontuacao = Column(Numeric(5, 2))
    prioridade = Column(Integer, default=0)
    data_entrada_fila = Column(DateTime, default=datetime.now)
    
    animal = relationship("Animal", back_populates="filas")
    adotante = relationship("Adotante", back_populates="filas")

class Reserva(Base):
    __tablename__ = 'reserva'
    id_reserva = Column(Integer, primary_key=True)
    id_animal = Column(Integer, ForeignKey('animal.id_animal', ondelete='CASCADE'), nullable=False)
    id_adotante = Column(Integer, ForeignKey('adotante.id_adotante', ondelete='CASCADE'), nullable=False)
    data_inicio = Column(DateTime, default=datetime.now)
    data_fim = Column(DateTime, nullable=False)
    status_reserva = Column(String(20), default='ATIVA')
    
    animal = relationship("Animal", back_populates="reservas")
    adotante = relationship("Adotante", back_populates="reservas")

class Adocao(Base):
    __tablename__ = 'adocao'
    id_adocao = Column(Integer, primary_key=True)
    id_animal = Column(Integer, ForeignKey('animal.id_animal', ondelete='RESTRICT'), nullable=False)
    id_adotante = Column(Integer, ForeignKey('adotante.id_adotante', ondelete='RESTRICT'), nullable=False)
    data_adocao = Column(Date, default=datetime.now)
    taxa_adocao = Column(Numeric(10, 2))
    estrategia_taxa = Column(String(50))
    contrato_texto = Column(Text)
    
    animal = relationship("Animal", back_populates="adocoes")
    adotante = relationship("Adotante", back_populates="adocoes")
    devolucao = relationship("Devolucao", back_populates="adocao", uselist=False)

class Devolucao(Base):
    __tablename__ = 'devolucao'
    id_devolucao = Column(Integer, primary_key=True)
    id_adocao = Column(Integer, ForeignKey('adocao.id_adocao', ondelete='RESTRICT'), unique=True, nullable=False)
    data_devolucao = Column(Date, default=datetime.now)
    motivo = Column(Text)
    novo_status = Column(String(20), default='DISPONIVEL', nullable=False)
    
    adocao = relationship("Adocao", back_populates="devolucao")