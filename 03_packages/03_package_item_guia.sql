-- Definindo o escopo do package que tratara os comandos DML da tabela item_guia
CREATE OR REPLACE PACKAGE pkg_item_guia AS

-- insere um registro na tabela de item_guia    
PROCEDURE prc_inserir(
    p_id_guia item_guia.id_guia%type,
    p_id_item item_guia.id_item%type,
    p_quantidade item_guia.quantidade%type,
    p_valor_informado item_guia.valor_informado%type,
    p_data_hora_atendimento item_guia.data_hora_atendimento%type
);

-- altera um registro na tabela de item_guia
PROCEDURE prc_alterar(
    p_id_guia item_guia.id_guia%type,
    p_sequencia_item item_guia.sequencia_item%type,
    p_id_item item_guia.id_item%type,
    p_quantidade item_guia.quantidade%type,
    p_valor_informado item_guia.valor_informado%type,
    p_data_hora_atendimento item_guia.data_hora_atendimento%type

);

--deleta um registro na tabela item_guia
PROCEDURE prc_deletar(
    p_id_guia item_guia.id_guia%type,
    p_sequencia_item item_guia.sequencia_item%type
);


END pkg_item_guia;
/

-- Definindo o corpo do package que tratara os comandos DML da tabela item_guia
CREATE OR REPLACE PACKAGE BODY pkg_item_guia AS

    -- insere um registro na tabela de item_guia    
    PROCEDURE prc_inserir(
        p_id_guia item_guia.id_guia%type,
        p_id_item item_guia.id_item%type,
        p_quantidade item_guia.quantidade%type,
        p_valor_informado item_guia.valor_informado%type,
        p_data_hora_atendimento item_guia.data_hora_atendimento%type
    )
    IS
        -- Criação do campo sequencia item para saber qual é o valor máximo ja existente na guia, e cadastrar a proxima sequencia.
       v_sequencia_item item_guia.sequencia_item%type;
    BEGIN
        -- Select para definir qual o valor da sequencia_item
        SELECT NVL(MAX(sequencia_item),0) +1 
        INTO v_sequencia_item 
        FROM item_guia 
        WHERE id_guia = p_id_guia;
        
        -- Regra para validar os dados a serem inseridos na tabela
        IF NOT(
            REGEXP_LIKE(p_id_guia,'^[0-9]+$') AND
            REGEXP_LIKE(p_id_item,'^[0-9]+$') AND
            REGEXP_LIKE(p_quantidade,'^[0-9]+$') AND
            REGEXP_LIKE(p_valor_informado,'^[0-9]+(\.[0-9]+)?$')AND
            (p_data_hora_atendimento <= sysdate)
            )
            THEN
                RAISE_APPLICATION_ERROR(-20003, 'Há campos que possuem caracteres incompatíveis.');
        END IF;
        
        -- Conferido os parametros recebidos, seguir com a inserção na tabela
        INSERT INTO item_guia(id_guia, sequencia_item, id_item, quantidade, valor_informado, data_hora_atendimento)
            VALUES( p_id_guia, v_sequencia_item, p_id_item, p_quantidade, p_valor_informado, p_data_hora_atendimento);
            
    END prc_inserir;
    
    -- altera um registro na tabela de item_guia
    PROCEDURE prc_alterar(
        p_id_guia item_guia.id_guia%type,
        p_sequencia_item item_guia.sequencia_item%type,
        p_id_item item_guia.id_item%type,
        p_quantidade item_guia.quantidade%type,
        p_valor_informado item_guia.valor_informado%type,
        p_data_hora_atendimento item_guia.data_hora_atendimento%type
    )
    IS
        
    BEGIN
        -- Regra para validar os dados a serem alterados na tabela
        IF NOT(
            REGEXP_LIKE(p_id_guia,'^[0-9]+$') AND
            REGEXP_LIKE(p_id_item,'^[0-9]+$') AND
            REGEXP_LIKE(p_quantidade,'^[0-9]+$') AND
            REGEXP_LIKE(p_valor_informado,'^[0-9]+(\.[0-9]+)?$')AND
            (p_data_hora_atendimento <= sysdate)
            )
            THEN
                RAISE_APPLICATION_ERROR(-20003, 'Há campos que possuem caracteres incompatíveis.');
        END IF;
        
        -- Conferido os parametros recebidos, seguir com alteração do registro na tabela
        UPDATE item_guia
        SET 
            id_item = p_id_item,
            quantidade = p_quantidade,
            valor_informado = p_valor_informado,
            data_hora_atendimento = p_data_hora_atendimento,
            data_ultima_alteracao = sysdate
        WHERE
            id_guia = p_id_guia AND
            sequencia_item = p_sequencia_item;
            
    END prc_alterar;
    
    --deleta um registro na tabela item_guia
    PROCEDURE prc_deletar(
        p_id_guia item_guia.id_guia%type,
        p_sequencia_item item_guia.sequencia_item%type
    )
    IS
    
    BEGIN
        -- Conferencia do parametro recebido, para garantir segurança da query
        IF NOT(
            REGEXP_LIKE(p_id_guia,'^[0-9]+$') AND
            REGEXP_LIKE(p_sequencia_item, '^[0-9]+$')
            )
            THEN
                RAISE_APPLICATION_ERROR(-20003, 'Há campos que possuem caracteres incompatíveis.');
        END IF;
        
        -- Verificado se os parametros recebidos estão corretos, seguir com a exclusão do registro no banco
        DELETE FROM item_guia WHERE id_guia = p_id_guia AND sequencia_item = p_sequencia_item;
        
    END prc_deletar;

END pkg_item_guia;