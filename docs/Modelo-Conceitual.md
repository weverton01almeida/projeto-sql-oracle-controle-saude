```
-- Modelo Conceitual das tabelas do banco de dados - Tabelas do Sistema

PRESTADOR(
	id_prestador NUMBER(10) PK NOT NULL AUTO_INCREMENT,
	nome_prestador VARCHAR2(100) NOT NULL,
	tipo_prestador CHAR(1) NOT NULL,
	cpf_cnpj VARCHAR2(14) UNIQUE NOT NULL,
	conselho_classe VARCHAR2(10) NOT NULL,
	numero_conselho VARCHAR2(10) NOT NULL,
	uf_conselho CHAR(2) NOT NULL,
	especialidade VARCHAR2(100) NOT NULL,
	telefone VARCHAR2(20),
	email VARCHAR2(100),
	status_prestador VARCHAR2(20) NOT NULL,	--(ativo|inativo)
	data_criacao DATE NOT NULL

	UNIQUE(uf_conselho, numero_conselho, conselho_classe)
)

plano(
	id_plano NUMBER(10) PK NOT NULL AUTO_INCREMENT,
	nome_plano VARCHAR2(100) NOT NULL,
	codigo_ans VARCHAR2(50) UNIQUE NOT NULL,
	tipo_contratacao VARCHAR2(100), --(Individual/Familiar, Coletivo Empresarial, Coletivo por Adesão)
	segmentacao_assistencial VARCHAR2(100) NOT NULL, --(Ambulatorial, Hospitalar com Obstetrícia, Odontológico)
	status_plano VARCHAR2(20) NOT NULL,
	data_criacao DATE NOT NULL
)

beneficiario(
	id_beneficiario NUMBER(10) PK NOT NULL AUTO_INCREMENT,
	id_plano NUMBER(10) FK NOT NULL,
	nome_beneficiario VARCHAR2(100) NOT NULL,
	cpf	VARCHAR2(11) UNIQUE NOT NULL,
	data_nascimento DATE NOT NULL,
	sexo CHAR(1) NOT NULL,
	email VARCHAR2(100),
	telefone VARCHAR2(20),
	numero_carteirinha VARCHAR2(50) NOT NULL seq_carteirinha_beneficiario,
	data_validade_carteirinha DATE NOT NULL,
	status_beneficiario VARCHAR2(20)NOT NULL, 	--(ativo|suspenso|cancelado)
	data_criacao DATE NOT NULL
)

item(
	id_item NUMBER(10) PK NOT NULL AUTO_INCREMENT,
	codigo_tuss VARCHAR2(20) UNIQUE NOT NULL,
	descricao VARCHAR2(200) NOT NULL,
	tipo_item VARCHAR2(50) NOT NULL, --(CONSULTA|EXAME|PROCEDIMENTO CIRÚRGICO|TAXA|MATERIAL|MEDICAMENTO|DIÁRIA)
	valor_referencia NUMBER(10,2)NOT NULL,
	status_item VARCHAR2(20) NOT NULL -- (ATIVO|INATIVO),
	data_criacao DATE NOT NULL
)

guia_atendimento(
	id_guia NUMBER(10) PK NOT NULL AUTO_INCREMENT,
	numero_guia NUMBER(10) UNIQUE NOT NULL seq_numero_guia,
	id_beneficiario NUMBER(10) FK NOT NULL,
	id_prestador NUMBER(10) FK NOT NULL,
	id_plano NUMBER(10) FK NOT NULL,
	data_hora_entrada DATE NOT NULL,
	data_hora_alta DATE,
	tipo_guia VARCHAR2(50) NOT NULL,--(CONSULTA ELETIVA, CONSULTA URGENCIA, AMBULATORIAL, EXAME, INTERNACAO)
	status_guia VARCHAR2(20) NOT NULL,--(INTERNADO|ABERTA|ALTA)
)

item_guia(
	id_guia NUMBER(10) CPK FK NOT NULL AUTO_INCREMENT,
	sequencia_item NUMBER(10) CPK NOT NULL,
	id_item NUMBER(10) FK NOT NULL,
	quantidade NUMBER(10) NOT NULL,
	valor_informado NUMBER(10, 2) NOT NULL,
	data_hora_atendimento DATE
)
```