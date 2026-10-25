
-- Criando a especificação do package que irá realizar os comandos DML dentro da tabela de plano
CREATE OR REPLACE PACKAGE pkg_plano AS

-- insere um registro na tabela de plano
    PROCEDURE prc_inserir
    (
        p_nome_plano IN plano.nome_plano%type,
        p_codigo_ans IN plano.codigo_ans%type,
        p_tipo_contratacao IN plano.tipo_contratacao%type,
        p_segmentacao_assistencial IN plano.segmentacao_assistencial%type,
        p_status_plano IN plano.status_plano%type
    );
    
-- altera um registro na tabela de plano
    PROCEDURE prc_alterar
    (
        p_id_plano IN plano.id_plano%type, --necessário o id_plano para realizar a alteração
        p_nome_plano IN plano.nome_plano%type,
        p_codigo_ans IN plano.codigo_ans%type,
        p_tipo_contratacao IN plano.tipo_contratacao%type,
        p_segmentacao_assistencial IN plano.segmentacao_assistencial%type,
        p_status_plano IN plano.status_plano%type
    );

--deleta um registro na tabela de plano
    PROCEDURE prc_deletar
    (
        p_id_plano IN NUMBER --necessário o id_plano para realizar a exclusão
    );
    
END pkg_plano;
/


-- Criando o body do package que irá realizar os comandos DML dentro da tabela de plano
CREATE OR REPLACE PACKAGE BODY pkg_plano AS

-- insere um registro na tabela de plano
    PROCEDURE prc_inserir
    (
        p_nome_plano IN plano.nome_plano%type,
        p_codigo_ans IN plano.codigo_ans%type,
        p_tipo_contratacao IN plano.tipo_contratacao%type,
        p_segmentacao_assistencial IN plano.segmentacao_assistencial%type,
        p_status_plano IN plano.status_plano%type
    ) IS
        -- Declarações de variaveis para tratar parametros recebidos
        v_nome_plano plano.nome_plano%type;
        v_codigo_ans plano.codigo_ans%type;
        v_tipo_contratacao plano.tipo_contratacao%type;
        v_segmentacao_assistencial plano.segmentacao_assistencial%type;
        v_status_plano plano.status_plano%type;
        
        -- Variavel para pesquisar nome_plano
        chk_nome_plano NUMBER(10);
    BEGIN
            
        -- Iniciando tratamento de dados
        v_nome_plano := fn_nrm_texto(p_nome_plano);
        v_codigo_ans := p_codigo_ans;
        v_tipo_contratacao := fn_nrm_texto(p_tipo_contratacao);
        v_segmentacao_assistencial := fn_nrm_texto(p_segmentacao_assistencial);
        v_status_plano := fn_nrm_texto(p_status_plano);
        
        -- Verifica se existe algum plano ja cadastrado com o nome informado
        SELECT COUNT(*) INTO chk_nome_plano FROM plano WHERE nome_plano = v_nome_plano;
        
        IF chk_nome_plano > 0 THEN -- confere variavel verificadora
            -- ativa o erro para o usuário 'nome_plano' ja cadastrado
            RAISE_APPLICATION_ERROR(-20001, 'O nome_plano informado ja está cadastrado para outro plano');
        ELSE 
            IF NOT (
                --Regras para garantir que cada campo da tabela plano receba os dados tratados
                REGEXP_LIKE(v_codigo_ans,'^[0-9]+$') AND
                REGEXP_LIKE(v_nome_plano,'^[A-Z ]+$') AND
                REGEXP_LIKE(v_tipo_contratacao,'^[A-Z ]+$') AND
                REGEXP_LIKE(v_segmentacao_assistencial, '^[A-Z ]+$') AND
                REGEXP_LIKE(v_status_plano, '^[A-Z ]+$')
            ) THEN -- Ativa erro criado
                RAISE_APPLICATION_ERROR(-20003, 'Há campos que possuem caracteres incompatíveis.');
            END IF;
        END IF;
        
        INSERT INTO PLANO(nome_plano, codigo_ans, tipo_contratacao, segmentacao_assistencial, status_plano)
            VALUES(v_nome_plano, v_codigo_ans, v_tipo_contratacao, v_segmentacao_assistencial, v_status_plano);      
    END prc_inserir;
    
-- altera um registro na tabela de plano
    PROCEDURE prc_alterar
    (
        p_id_plano IN plano.id_plano%type, --necessário o id_plano para realizar a alteração
        p_nome_plano IN plano.nome_plano%type,
        p_codigo_ans IN plano.codigo_ans%type,
        p_tipo_contratacao IN plano.tipo_contratacao%type,
        p_segmentacao_assistencial IN plano.segmentacao_assistencial%type,
        p_status_plano IN plano.status_plano%type
    ) IS
        -- Declarações de variaveis para tratar parametros recebidos
        v_nome_plano plano.nome_plano%type;
        v_codigo_ans plano.codigo_ans%type;
        v_tipo_contratacao plano.tipo_contratacao%type;
        v_segmentacao_assistencial plano.segmentacao_assistencial%type;
        v_status_plano plano.status_plano%type;
        chk_nome_plano NUMBER(10);
    BEGIN
            
        -- Iniciando tratamento de dados
        v_nome_plano := fn_nrm_texto(p_nome_plano);
        v_codigo_ans := p_codigo_ans;
        v_tipo_contratacao := fn_nrm_texto(p_tipo_contratacao);
        v_segmentacao_assistencial := fn_nrm_texto(p_segmentacao_assistencial);
        v_status_plano := fn_nrm_texto(p_status_plano);

        -- Verifica se existe algum plano ja cadastrado com o nome informado
        SELECT COUNT(*) INTO chk_nome_plano FROM plano WHERE nome_plano = v_nome_plano AND id_plano <> p_id_plano;
        
        IF chk_nome_plano > 0 THEN -- confere variavel verificadora
            -- ativa o erro para o usuário 'nome_plano' ja cadastrado
            RAISE_APPLICATION_ERROR(-20001, 'O nome_plano informado ja está cadastrado para outro plano');
        ELSE 
            IF NOT (
                --Regras para garantir que cada campo da tabela plano receba os dados tratados
                REGEXP_LIKE(v_codigo_ans,'^[0-9]+$') AND
                REGEXP_LIKE(v_nome_plano,'^[A-Z ]+$') AND
                REGEXP_LIKE(v_tipo_contratacao,'^[A-Z ]+$') AND
                REGEXP_LIKE(v_segmentacao_assistencial, '^[A-Z ]+$') AND
                REGEXP_LIKE(v_status_plano, '^[A-Z ]+$')
            ) THEN -- Ativa erro criado
                RAISE_APPLICATION_ERROR(-20003, 'Há campos que possuem caracteres incompatíveis.');
            END IF;
        END IF;
        -- fazer alteração solicitada na tabela plano
        UPDATE plano
        SET nome_plano = v_nome_plano,
            codigo_ans = v_codigo_ans,
            tipo_contratacao = v_tipo_contratacao,
            segmentacao_assistencial = v_segmentacao_assistencial,
            status_plano = v_status_plano,
            data_ultima_alteracao = sysdate
        WHERE id_plano = p_id_plano;
        
    END prc_alterar;

--deleta um registro na tabela de plano
    PROCEDURE prc_deletar
    (
        p_id_plano IN NUMBER --necessário o id_plano para realizar a exclusão
    ) IS
    BEGIN
        -- deletar o registro da tabela plano, conforme o id_plano
        DELETE FROM plano WHERE id_plano = p_id_plano;
    END prc_deletar;

END pkg_plano;
/