
-- Criando a especificação do package que irá realizar os comandos DML dentro da tabela de plano
CREATE OR REPLACE PACKAGE pkg_plano AS

-- insere um registro na tabela de plano
    PROCEDURE prc_inserir
    (
        p_nome_plano IN VARCHAR2,
        p_codigo_ans IN VARCHAR2,
        p_tipo_contratacao IN VARCHAR2,
        p_segmentacao_assistencial IN VARCHAR2,
        p_status_plano IN VARCHAR2
    );
    
-- altera um registro na tabela de plano
    PROCEDURE prc_alterar
    (
        p_id_plano IN NUMBER, --necessário o id_plano para realizar a alteração
        p_nome_plano IN VARCHAR2,
        p_codigo_ans IN VARCHAR2,
        p_tipo_contratacao IN VARCHAR2,
        p_segmentacao_assistencial IN VARCHAR2,
        p_status_plano IN VARCHAR2
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
        p_nome_plano IN VARCHAR2,
        p_codigo_ans IN VARCHAR2,
        p_tipo_contratacao IN VARCHAR2,
        p_segmentacao_assistencial IN VARCHAR2,
        p_status_plano IN VARCHAR2
    ) IS
        chk_nome_plano NUMBER(10);
    BEGIN
        -- Verifica se existe algum plano ja cadastrado com o nome informado
        SELECT COUNT(*) INTO chk_nome_plano FROM plano WHERE nome_plano = p_nome_plano;
        
        IF chk_nome_plano > 0 THEN -- confere variavel verificadora
            -- ativa o erro para o usuário 'nome_plano' ja cadastrado
            RAISE_APPLICATION_ERROR(-20001, 'O nome_plano informado ja está cadastrado para outro plano');
        END IF;
        INSERT INTO PLANO(nome_plano, codigo_ans, tipo_contratacao, segmentacao_assistencial, status_plano)
            VALUES(p_nome_plano, p_codigo_ans, p_tipo_contratacao, p_segmentacao_assistencial, p_status_plano);      
    END prc_inserir;
    
-- altera um registro na tabela de plano
    PROCEDURE prc_alterar
    (
        p_id_plano IN NUMBER, --necessário o id_plano para realizar a alteração
        p_nome_plano IN VARCHAR2,
        p_codigo_ans IN VARCHAR2,
        p_tipo_contratacao IN VARCHAR2,
        p_segmentacao_assistencial IN VARCHAR2,
        p_status_plano IN VARCHAR2
    ) IS
        chk_nome_plano NUMBER(10);
    BEGIN
        -- Verifica se existe algum plano ja cadastrado com o nome informado
        SELECT COUNT(*) INTO chk_nome_plano FROM plano WHERE nome_plano = p_nome_plano AND id_plano <> p_id_plano;
        
        IF chk_nome_plano > 0 THEN -- confere variavel verificadora
            -- ativa o erro para o usuário 'nome_plano' ja cadastrado
            RAISE_APPLICATION_ERROR(-20001, 'O nome_plano informado ja está cadastrado para outro plano');
        END IF;
        -- fazer alteração solicitada na tabela plano
        UPDATE plano
        SET nome_plano = p_nome_plano,
            codigo_ans = p_codigo_ans,
            tipo_contratacao = p_tipo_contratacao,
            segmentacao_assistencial = p_segmentacao_assistencial,
            status_plano = p_status_plano,
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