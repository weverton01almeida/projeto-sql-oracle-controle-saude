-- Criando Especificação do package da tabela Item, que realizara e tratará os comandos DML
CREATE OR REPLACE PACKAGE pkg_item AS
-- Insere dados na tabela Item
    PROCEDURE prc_inserir
    (
        p_codigo_tuss IN item.codigo_tuss%type,
        p_descricao IN item.descricao%type,
        p_tipo_item IN item.tipo_item%type,
        p_valor_referencia IN item.valor_referencia%type,
        p_status_item IN item.status_item%type
    );
    
-- Altera dados na tabela Item
    PROCEDURE prc_alterar
    (
        p_id_item IN item.id_item%type,
        p_codigo_tuss IN item.codigo_tuss%type,
        p_descricao IN item.descricao%type,
        p_tipo_item IN item.tipo_item%type,
        p_valor_referencia IN item.valor_referencia%type,
        p_status_item IN item.status_item%type
    );
    
-- Deleta dados na tabela Item
    PROCEDURE prc_deletar
    (
        p_id_item IN item.id_item%type
    );
    
END pkg_item;
/

CREATE OR REPLACE PACKAGE BODY pkg_item AS
        PROCEDURE prc_inserir
    (
        p_codigo_tuss IN item.codigo_tuss%type,
        p_descricao IN item.descricao%type,
        p_tipo_item IN item.tipo_item%type,
        p_valor_referencia IN item.valor_referencia%type,
        p_status_item IN item.status_item%type
    )IS
    -- Declaração de variáveis da procedure
    
    BEGIN
        CASE
        -- Verifica se os valores inseridos nos campos estão conforme esperado pela tabela.
            WHEN NOT(
                REGEXP_LIKE(p_codigo_tuss, '^[0-9]+$') AND
                REGEXP_LIKE(UPPER(p_descricao), '^[A-Z ]+$') AND 
                REGEXP_LIKE(UPPER(p_tipo_item), '^[A-Z ]+$') AND
                REGEXP_LIKE(p_valor_referencia, '^[0-9]+(\.[0-9]+)?$') AND -- Número inteiro ou número decimal é aceito
                REGEXP_LIKE(UPPER(p_status_item), '^[A-Z ]+$')
                )
                THEN
                    RAISE_APPLICATION_ERROR(-20003, 'Há campos que possuem caracteres incompatíveis.');
            END CASE;
            
            -- Conferencia realizada, dados válidos, inserir valores no banco
            INSERT INTO item(codigo_tuss, descricao, tipo_item, valor_referencia, status_item)
                VALUES(p_codigo_tuss, p_descricao, p_tipo_item, p_valor_referencia, p_status_item);
    END prc_inserir;
    
    -- Altera dados na tabela Item
    PROCEDURE prc_alterar
    (
        p_id_item IN item.id_item%type,
        p_codigo_tuss IN item.codigo_tuss%type,
        p_descricao IN item.descricao%type,
        p_tipo_item IN item.tipo_item%type,
        p_valor_referencia IN item.valor_referencia%type,
        p_status_item IN item.status_item%type
    )
    IS
    --Declaração de variaveis da procedure
    
    BEGIN
        -- Verifica se os valores para alteração nos campos estão conforme esperado pela tabela.
        CASE 
            WHEN NOT(
                REGEXP_LIKE(p_id_item, '^[0-9]+$') AND -- Garantir que o id seja um número e inteiro. *Segurança*
                REGEXP_LIKE(p_codigo_tuss, '^[0-9]+$') AND
                REGEXP_LIKE(UPPER(p_descricao), '^[A-Z ]+$') AND 
                REGEXP_LIKE(UPPER(p_tipo_item), '^[A-Z ]+$') AND
                REGEXP_LIKE(p_valor_referencia, '^[0-9]+(\.[0-9]+)?$') AND -- Número inteiro ou número decimal é aceito
                REGEXP_LIKE(UPPER(p_status_item), '^[A-Z ]+$')
            )
                THEN
                    RAISE_APPLICATION_ERROR(-20003, 'Há campos que possuem caracteres incompatíveis.');
            END CASE;      
        
        -- Alterar o registro solicitado
        UPDATE item
        SET
            codigo_tuss = p_codigo_tuss,
            descricao = p_descricao,
            tipo_item = p_tipo_item,
            valor_referencia = p_valor_referencia,
            status_item = p_status_item,
            data_ultima_alteracao = sysdate
        WHERE id_item = p_id_item;
    END prc_alterar;
    
        PROCEDURE prc_deletar
    (
        p_id_item IN item.id_item%type
    )
    IS
    -- Declaração de variáveis
    BEGIN
        IF NOT REGEXP_LIKE(p_id_item, '^[0-9]+$') THEN -- Garantir que o id seja inteiro para garantir segurança
            RAISE_APPLICATION_ERROR(-20003, 'Há campos que possuem caracteres incompatíveis.');
        END IF;
        -- Deletar registro solicitado
        DELETE FROM item WHERE id_item = p_id_item;
    END prc_deletar;
END pkg_item;
/