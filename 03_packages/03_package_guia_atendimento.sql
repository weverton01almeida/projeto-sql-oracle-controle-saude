-- Criando Especificação do package da tabela guia_atendimento, que realizara e tratará os comandos DML
CREATE OR REPLACE PACKAGE pkg_guia_atendimento AS
    -- Insere dados na tabela guia_atendimento
    PROCEDURE prc_inserir(
        p_id_beneficiario guia_atendimento.id_beneficiario%type,
        p_id_prestador guia_atendimento.id_prestador%type,
        p_id_plano guia_atendimento.id_plano%type,
        p_data_hora_entrada guia_atendimento.data_hora_entrada%type,
        p_data_hora_alta guia_atendimento.data_hora_alta%type,
        p_tipo_guia guia_atendimento.tipo_guia%type,
        p_status_guia guia_atendimento.status_guia%type
    );
    -- Altera dados na tabela guia_atendimento
    PROCEDURE prc_alterar(
        p_id_guia guia_atendimento.id_guia%type,
        p_id_beneficiario guia_atendimento.id_beneficiario%type,
        p_id_prestador guia_atendimento.id_prestador%type,
        p_id_plano guia_atendimento.id_plano%type,
        p_data_hora_entrada guia_atendimento.data_hora_entrada%type,
        p_data_hora_alta guia_atendimento.data_hora_alta%type,
        p_tipo_guia guia_atendimento.tipo_guia%type,
        p_status_guia guia_atendimento.status_guia%type
    );
    -- Deleta dados na tabela guia_atendimento
    PROCEDURE prc_deletar(
        p_id_guia guia_atendimento.id_guia%type
        
    );
    
END pkg_guia_atendimento;
/


-- Criando o body do package da tabela guia_atendimento, que realizara e tratará os comandos DML
CREATE OR REPLACE PACKAGE BODY pkg_guia_atendimento AS
    -- Insere dados na tabela guia_atendimento
    PROCEDURE prc_inserir(
        p_id_beneficiario guia_atendimento.id_beneficiario%type,
        p_id_prestador guia_atendimento.id_prestador%type,
        p_id_plano guia_atendimento.id_plano%type,
        p_data_hora_entrada guia_atendimento.data_hora_entrada%type,
        p_data_hora_alta guia_atendimento.data_hora_alta%type,
        p_tipo_guia guia_atendimento.tipo_guia%type,
        p_status_guia guia_atendimento.status_guia%type
        )
        IS
            -- Criação dos campos para tratamento dos valores recebidos no parametro
            v_numero_guia guia_atendimento.numero_guia%type;
            v_id_beneficiario guia_atendimento.id_beneficiario%type;
            v_id_prestador guia_atendimento.id_prestador%type;
            v_id_plano guia_atendimento.id_plano%type;
            v_data_hora_entrada guia_atendimento.data_hora_entrada%type;
            v_data_hora_alta guia_atendimento.data_hora_alta%type;
            v_tipo_guia guia_atendimento.tipo_guia%type;
            v_status_guia guia_atendimento.status_guia%type;
            
        BEGIN
            -- Tratamento dos parametros recebidos, transferindo os valores para as variaveis internas
            v_numero_guia := SEQ_NUMERO_GUIA.NEXTVAL;
            v_id_beneficiario := p_id_beneficiario;
            v_id_prestador := p_id_prestador;
            v_id_plano := p_id_plano;
            v_data_hora_entrada := p_data_hora_entrada;
            v_data_hora_alta := p_data_hora_alta;
            v_tipo_guia := fn_nrm_texto(p_tipo_guia);
            v_status_guia := fn_nrm_texto(p_status_guia);
            
            -- Validando os valores para inclusão do registro na tabela
            CASE
                WHEN NOT(
                    REGEXP_LIKE(v_id_beneficiario, '^[0-9]+$') AND
                    REGEXP_LIKE(v_id_prestador, '^[0-9]+$') AND
                    REGEXP_LIKE(v_id_plano, '^[0-9]+$') AND
                    (v_data_hora_entrada <= sysdate) AND
                    (v_data_hora_alta <= sysdate OR v_data_hora_alta IS NULL) AND
                    REGEXP_LIKE(v_tipo_guia, '^[A-Z ]+$') AND
                    REGEXP_LIKE(v_status_guia, '^[A-Z ]+$')
                    ) 
                    THEN
                        RAISE_APPLICATION_ERROR(-20003, 'Há campos que possuem caracteres incompatíveis.');
            END CASE;
            
            -- Apos conferencias, inserir registro na tabela
            INSERT INTO guia_atendimento(numero_guia, id_beneficiario, id_prestador, id_plano, data_hora_entrada, data_hora_alta, tipo_guia, status_guia)
                VALUES(v_numero_guia, v_id_beneficiario, v_id_prestador, v_id_plano, v_data_hora_entrada, v_data_hora_alta, v_tipo_guia, v_status_guia);
        END prc_inserir;
        
    PROCEDURE prc_alterar(
        p_id_guia guia_atendimento.id_guia%type,
        p_id_beneficiario guia_atendimento.id_beneficiario%type,
        p_id_prestador guia_atendimento.id_prestador%type,
        p_id_plano guia_atendimento.id_plano%type,
        p_data_hora_entrada guia_atendimento.data_hora_entrada%type,
        p_data_hora_alta guia_atendimento.data_hora_alta%type,
        p_tipo_guia guia_atendimento.tipo_guia%type,
        p_status_guia guia_atendimento.status_guia%type
        )
        IS
            -- Criação de variaveis internas para tratamento dos parametros recebidos
            v_id_guia guia_atendimento.id_guia%type;
            v_id_beneficiario guia_atendimento.id_beneficiario%type;
            v_id_prestador guia_atendimento.id_prestador%type;
            v_id_plano guia_atendimento.id_plano%type;
            v_data_hora_entrada guia_atendimento.data_hora_entrada%type;
            v_data_hora_alta guia_atendimento.data_hora_alta%type;
            v_tipo_guia guia_atendimento.tipo_guia%type;
            v_status_guia guia_atendimento.status_guia%type;
        
        BEGIN
            -- Tratamento dos parametros recebidos, transferindo os valores para as variaveis internas
            v_id_guia := p_id_guia;
            v_id_beneficiario := p_id_beneficiario;
            v_id_prestador := p_id_prestador;
            v_id_plano := p_id_plano;
            v_data_hora_entrada := p_data_hora_entrada;
            v_data_hora_alta := p_data_hora_alta;
            v_tipo_guia := FN_NRM_TEXTO(p_tipo_guia);
            v_status_guia := FN_NRM_TEXTO(p_status_guia);
            
            -- Validando os valores para alteração do registro na tabela
            CASE
                WHEN NOT(
                    REGEXP_LIKE(v_id_guia, '^[0-9]+$') AND
                    REGEXP_LIKE(v_id_beneficiario, '^[0-9]+$') AND
                    REGEXP_LIKE(v_id_prestador, '^[0-9]+$') AND
                    REGEXP_LIKE(v_id_plano, '^[0-9]+$') AND
                    (v_data_hora_entrada <= sysdate) AND
                    (v_data_hora_alta <= sysdate OR v_data_hora_alta IS NULL) AND
                    REGEXP_LIKE(v_tipo_guia, '^[A-Z ]+$') AND
                    REGEXP_LIKE(v_status_guia, '^[A-Z ]+$')
                    ) 
                    THEN
                        RAISE_APPLICATION_ERROR(-20003, 'Há campos que possuem caracteres incompatíveis.');
            END CASE;
            
            -- Apos conferencias, alterar registro na tabela
            
            UPDATE GUIA_ATENDIMENTO
            SET
                id_beneficiario = v_id_beneficiario,
                id_prestador = v_id_prestador,
                id_plano = v_id_plano,
                data_hora_entrada = v_data_hora_entrada,
                data_hora_alta = v_data_hora_alta,
                tipo_guia = v_tipo_guia,
                status_guia = v_status_guia,
                data_ultima_alteracao = sysdate
            WHERE
                id_guia = v_id_guia;
        
    END prc_alterar;
    
    PROCEDURE prc_deletar(
        p_id_guia guia_atendimento.id_guia%type
        )   
        IS
            
        BEGIN
            IF NOT REGEXP_LIKE (p_id_guia,'^[0-9]+$') THEN -- Garantir a segurança da query
                RAISE_APPLICATION_ERROR(-20003, 'Há campos que possuem caracteres incompatíveis.');                
            END IF;
            -- Deletar registro conforme solicitado
            DELETE FROM guia_atendimento WHERE id_guia = p_id_guia;
        END prc_deletar;
        
END pkg_guia_atendimento;
/