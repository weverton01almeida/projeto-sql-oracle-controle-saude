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
        -- Criação de variaveis da procedure para trata-las logo com a function de normalizar os textos
        v_nome_prestador  prestador.nome_prestador%type;
        v_tipo_prestador prestador.tipo_prestador%type;
        v_conselho_classe prestador.conselho_classe%type;
        v_uf_conselho prestador.uf_conselho%type;
        v_especialidade prestador.especialidade%type;
        v_status_prestador prestador.status_prestador%type;
        
        -- Normalizando as variaveis recebidas nos parametros
        v_nome_prestador := fn_nrm_texto(p_nome_prestador);
        v_tipo_prestador := fn_nrm_texto(p_tipo_prestador);
        v_conselho_classe := fn_nrm_texto(p_conselho_classe);
        v_uf_conselho := fn_nrm_texto(p_uf_conselho);
        v_especialidade := fn_nrm_texto(p_especialidade);
        v_status_prestador := fn_nrm_texto(p_status_prestador);
        
		
	BEGIN
		-- Verifica se a variavel que armazena cpf e cnpj contem apenas números e a quantidade de digitos esta como o esperado: [Pessoa Fisica(CPF): 11 DIGITOS] [Pessoa Jurídica(CNPJ): 14 DIGITOS]
		CASE
			WHEN NOT(
						(LENGTH(p_cpf_cnpj) = 11 AND UPPER(p_tipo_prestador) = 'F') OR -- Verifica caso for pessoa fisica se número de caracteres inseridos é 11 
						(LENGTH(p_cpf_cnpj) = 14 AND UPPER(p_tipo_prestador) = 'J') -- Verifica caso for pessoa jurídica se número de caracteres inseridos é 14
					)
				THEN 
					RAISE_APPLICATION_ERROR(-20002, 'CPF ou CNPJ com número de caracteres diferentes do permitido (11 para CPF ou 14 para CNPJ)');
			
			WHEN NOT(
						-- Regras para garantir que os campos de número recebam apenas números e os campos texto, recebam apenas texto
						REGEXP_LIKE(p_cpf_cnpj,'^[0-9]+$') AND
						REGEXP_LIKE(p_numero_conselho,'^[0-9]+$') AND
						REGEXP_LIKE(p_telefone, '^[0-9]+$') AND
						REGEXP_LIKE(v_tipo_prestador,'^[A-Z ]+$') AND -- de A a Z com espaços
						REGEXP_LIKE(v_conselho_classe, '^[A-Z]+$') AND
						REGEXP_LIKE(v_uf_conselho, '^[A-Z]+$') AND
						REGEXP_LIKE(v_especialidade, '^[A-Z ]+$') AND
						REGEXP_LIKE(v_status_prestador,'^[A-Z ]+$')
						
					) THEN
						RAISE_APPLICATION_ERROR(-20003, 'Há campos que possuem caracteres incompatíveis.');
			-- Confere as variaveis da tabela para garantir que as variaveis de número e as de texto, recebam os dados apropriados
		END CASE;
		
		-- Apos conferencias realizadas, inserir os valores no banco
		INSERT INTO prestador(nome_prestador, tipo_prestador, cpf_cnpj, conselho_classe, numero_conselho, uf_conselho, especialidade, telefone, email, status_prestador)
			VALUES(v_nome_prestador, v_tipo_prestador, p_cpf_cnpj, v_conselho_classe, p_numero_conselho, v_uf_conselho, v_especialidade, p_telefone, p_email, v_status_prestador);
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
        -- Criação de variaveis da procedure para trata-las logo com a function de normalizar os textos
        v_nome_prestador prestador.nome_prestador%type;
        v_tipo_prestador prestador.tipo_prestador%type;
        v_conselho_classe prestador.conselho_classe%type;
        v_uf_conselho prestador.uf_conselho%type;
        v_especialidade prestador.especialidade%type;
        v_status_prestador prestador.status_prestador%type;
        
        -- Normalizando as variaveis recebidas nos parametros
        v_nome_prestador := fn_nrm_texto(p_nome_prestador);
        v_tipo_prestador := fn_nrm_texto(p_tipo_prestador);
        v_conselho_classe := fn_nrm_texto(p_conselho_classe);
        v_uf_conselho := fn_nrm_texto(p_uf_conselho);
        v_especialidade := fn_nrm_texto(p_especialidade);
        v_status_prestador := fn_nrm_texto(p_status_prestador);
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
						REGEXP_LIKE(p_id_prestador, '^[0-9]+$') AND --Garantir a segurança da query.
                        REGEXP_LIKE(p_cpf_cnpj,'^[0-9]+$') AND
						REGEXP_LIKE(p_numero_conselho,'^[0-9]+$') AND
						REGEXP_LIKE(p_telefone, '^[0-9]+$') AND
						REGEXP_LIKE(v_tipo_prestador,'^[A-Z ]+$') AND
						REGEXP_LIKE(v_conselho_classe, '^[A-Z]+$') AND
						REGEXP_LIKE(v_uf_conselho, '^[A-Z]+$') AND
						REGEXP_LIKE(v_especialidade, '^[A-Z ]+$') AND
						REGEXP_LIKE(v_status_prestador,'^[A-Z ]+$')
						
					) THEN
						RAISE_APPLICATION_ERROR(-20003, 'Há campos que possuem caracteres incompatíveis.');
			-- Confere as variaveis da tabela para garantir que as variaveis de número e as de texto, recebam os dados apropriados
		END CASE;
		
		-- Atualizar o registro conforme solicitado.
		UPDATE prestador 
		SET
			nome_prestador = v_nome_prestador, 
			tipo_prestador = v_tipo_prestador, 
			cpf_cnpj = p_cpf_cnpj, 
			conselho_classe = v_conselho_classe, 
			numero_conselho = p_numero_conselho, 
			uf_conselho = v_uf_conselho, 
			especialidade = v_especialidade, 
			telefone = p_telefone, 
			email = p_email, 
			status_prestador = v_status_prestador,
			data_ultima_alteracao = sysdate
		WHERE id_prestador = p_id_prestador;
		
	END prc_alterar;
	
	PROCEDURE prc_deletar
	(
		p_id_prestador IN prestador.id_prestador%type -- Necessário o id do prestador para realizar a exclusão do registro
	
	)IS
	
	BEGIN
        IF NOT REGEXP_LIKE(p_id_prestador, '^[0-9]+$') THEN --Garantir a segurança da query.
            RAISE_APPLICATION_ERROR(-20003, 'Há campos que possuem caracteres incompatíveis.');
        END IF;
		DELETE FROM prestador WHERE id_prestador = p_id_prestador;
	END prc_deletar;

END pkg_prestador;
/
