-- Especificação do PACKAGE da tabela prestador
CREATE OR REPLACE PACKAGE pkg_prestador AS
-- Insere dados na tabela prestador
	PROCEDURE prc_inserir
	(
		p_nome_prestador IN prestador.nome_prestador%type,
		p_tipo_prestador IN prestador.tipo_prestador%type,
		p_cpf_cnpj IN prestador.cpf_cnpj%type,
		p_conselho_classe IN prestador.conselho_classe%type,
		p_numero_conselho IN prestador.numero_conselho%type,
		p_uf_conselho IN prestador.uf_conselho%type,
		p_especialidade IN prestador.especialidade%type,
		p_telefone IN prestador.telefone%type,
		p_email IN prestador.email%type,
		p_status_prestador IN prestador.status_prestador%type
	);
-- Altera dados na tabela prestador
	PROCEDURE prc_alterar
	(
		p_id_prestador IN prestador.id_prestador%type, -- Necessário o id do prestador para realizar a alteração do registro
		p_nome_prestador IN prestador.nome_prestador%type,
		p_tipo_prestador IN prestador.tipo_prestador%type,
		p_cpf_cnpj IN prestador.cpf_cnpj%type,
		p_conselho_classe IN prestador.conselho_classe%type,
		p_numero_conselho IN prestador.numero_conselho%type,
		p_uf_conselho IN prestador.uf_conselho%type,
		p_especialidade IN prestador.especialidade%type,
		p_telefone IN prestador.telefone%type,
		p_email IN prestador.email%type,
		p_status_prestador IN prestador.status_prestador%type
	);
	
-- Deleta dados na tabela prestador
	PROCEDURE prc_deletar
	(
		p_id_prestador IN prestador.id_prestador%type -- Necessário o id do prestador para realizar a exclusão do registro
	);
	
END pkg_prestador;
/

CREATE OR REPLACE PACKAGE BODY pkg_prestador AS

	PROCEDURE prc_inserir
	(
		p_nome_prestador IN prestador.nome_prestador%type,
		p_tipo_prestador IN prestador.tipo_prestador%type,
		p_cpf_cnpj IN prestador.cpf_cnpj%type,
		p_conselho_classe IN prestador.conselho_classe%type,
		p_numero_conselho IN prestador.numero_conselho%type,
		p_uf_conselho IN prestador.uf_conselho%type,
		p_especialidade IN prestador.especialidade%type,
		p_telefone IN prestador.telefone%type,
		p_email IN prestador.email%type,
		p_status_prestador IN prestador.status_prestador%type
	
	)IS
-- Declaração de variaveis da procedure
		
	BEGIN
		-- Verifica se a variavel que armazena cpf e cnpj contem apenas números e a quantidade de digitos esta como o esperado: [Pessoa Fisica(CPF): 11 DIGITOS] [Pessoa Jurídica(CNPJ): 14 DIGITOS]
		CASE
			WHEN NOT(
						(LENGTH(p_cpf_cnpj) = 11 AND UPPER(p_tipo_prestador) = 'F') OR -- Verifica caso for pessoa fisica se número de caracteres inseridos é 11 
						(LENGTH(p_cpf_cnpj) = 14 AND UPPER(p_tipo_prestador) = 'J') -- Verifica caso for pessoa jurídica se número de caracteres inseridos é 14
					)
				THEN 
					RAISE_APPLICATION_ERROR('-20002', 'CPF ou CNPJ com número de caracteres diferentes do permitido (11 para CPF ou 14 para CNPJ)');
			
			WHEN NOT(
						-- Regras para garantir que os campos de número recebam apenas números e os campos texto, recebam apenas texto
						REGEXP_LIKE(p_cpf_cnpj,'^[0-9]+$') AND
						REGEXP_LIKE(p_numero_conselho,'^[0-9]+$') AND
						REGEXP_LIKE(p_telefone, '^[0-9]+$') AND
						REGEXP_LIKE(UPPER(p_tipo_prestador),'^[A-Z ]+$') AND -- de A a Z com espaços
						REGEXP_LIKE(UPPER(p_conselho_classe), '^[A-Z]+$') AND
						REGEXP_LIKE(UPPER(p_uf_conselho), '^[A-Z]+$') AND
						REGEXP_LIKE(UPPER(p_especialidade), '^[A-Z ]+$') AND
						REGEXP_LIKE(UPPER(p_status_prestador),'^[A-Z ]+$')
						
					) THEN
						RAISE_APPLICATION_ERROR('-20003', 'Há campos que possuem caracteres incompatíveis.');
			-- Confere as variaveis da tabela para garantir que as variaveis de número e as de texto, recebam os dados apropriados
		END CASE;
		
		-- Apos conferencias realizadas, inserir os valores no banco
		INSERT INTO prestador(nome_prestador, tipo_prestador, cpf_cnpj, conselho_classe, numero_conselho, uf_conselho, especialidade, telefone, email, status_prestador)
			VALUES(p_nome_prestador, p_tipo_prestador, p_cpf_cnpj, p_conselho_classe, p_numero_conselho, p_uf_conselho, p_especialidade, p_telefone, p_email, p_status_prestador);
	END prc_inserir;
	
	
	PROCEDURE prc_alterar
	(
		p_id_prestador IN prestador.id_prestador%type,
		p_nome_prestador IN prestador.nome_prestador%type,
		p_tipo_prestador IN prestador.tipo_prestador%type,
		p_cpf_cnpj IN prestador.cpf_cnpj%type,
		p_conselho_classe IN prestador.conselho_classe%type,
		p_numero_conselho IN prestador.numero_conselho%type,
		p_uf_conselho IN prestador.uf_conselho%type,
		p_especialidade IN prestador.especialidade%type,
		p_telefone IN prestador.telefone%type,
		p_email IN prestador.email%type,
		p_status_prestador IN prestador.status_prestador%type		
	)IS
	
	BEGIN
		CASE
			WHEN NOT(
						(LENGTH(p_cpf_cnpj) = 11 AND UPPER(p_tipo_prestador) = 'F') OR -- Verifica caso for pessoa fisica se número de caracteres inseridos é 11 
						(LENGTH(p_cpf_cnpj) = 14 AND UPPER(p_tipo_prestador) = 'J') -- Verifica caso for pessoa jurídica se número de caracteres inseridos é 14
					)
				THEN 
					RAISE_APPLICATION_ERROR('-20002', 'CPF ou CNPJ com número de caracteres diferentes do permitido (11 para CPF ou 14 para CNPJ)');
			
			WHEN NOT(
						-- Regras para garantir que os campos de número recebam apenas números e os campos texto, recebam apenas texto
						REGEXP_LIKE(p_cpf_cnpj,'^[0-9]+$') AND
						REGEXP_LIKE(p_numero_conselho,'^[0-9]+$') AND
						REGEXP_LIKE(p_telefone, '^[0-9]+$') AND
						REGEXP_LIKE(UPPER(p_tipo_prestador),'^[A-Z ]+$') AND
						REGEXP_LIKE(UPPER(p_conselho_classe), '^[A-Z]+$') AND
						REGEXP_LIKE(UPPER(p_uf_conselho), '^[A-Z]+$') AND
						REGEXP_LIKE(UPPER(p_especialidade), '^[A-Z ]+$') AND
						REGEXP_LIKE(UPPER(p_status_prestador),'^[A-Z ]+$')
						
					) THEN
						RAISE_APPLICATION_ERROR('-20003', 'Há campos que possuem caracteres incompatíveis.');
			-- Confere as variaveis da tabela para garantir que as variaveis de número e as de texto, recebam os dados apropriados
		END CASE;
		
		-- Atualizar o registro conforme solicitado.
		UPDATE prestador 
		SET
			nome_prestador = p_nome_prestador, 
			tipo_prestador = p_tipo_prestador, 
			cpf_cnpj = p_cpf_cnpj, 
			conselho_classe = p_conselho_classe, 
			numero_conselho = p_numero_conselho, 
			uf_conselho = p_uf_conselho, 
			especialidade = p_especialidade, 
			telefone = p_telefone, 
			email = p_email, 
			status_prestador = p_status_prestador,
			data_ultima_alteracao = sysdate
		WHERE id_prestador = p_id_prestador;
		
	END prc_alterar;
	
	PROCEDURE prc_deletar
	(
		p_id_prestador IN prestador.id_prestador%type -- Necessário o id do prestador para realizar a exclusão do registro
	
	)IS
	
	BEGIN
		DELETE FROM prestador WHERE id_prestador = p_id_prestador;
	END prc_deletar;

END pkg_prestador;
/
