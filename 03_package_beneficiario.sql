-- Criando Especificação do package da tabela Beneficiario, que realizara e tratará os comandos DML
CREATE OR REPLACE PACKAGE pkg_beneficiario AS
    -- Insere dados na tabela Beneficiario
    PROCEDURE prc_inserir
    (
        p_id_plano IN beneficiario.id_plano%type,
        p_nome_beneficiario IN beneficiario.nome_beneficiario%type,
        p_cpf IN beneficiario.cpf%type,
        p_data_nascimento IN beneficiario.data_nascimento%type,
        p_sexo IN beneficiario.sexo%type,
        p_email IN beneficiario.email%type,
        p_telefone IN beneficiario.telefone%type,
        p_numero_carteirinha IN beneficiario.numero_carteirinha%type,
        p_data_validade_carteirinha IN beneficiario.data_validade_carteirinha%type,
        p_status_beneficiario IN beneficiario.status_beneficiario%type
    );

    -- Altera dados na tabela Beneficiario
    PROCEDURE prc_alterar
    (
        p_id_beneficiario IN beneficiario.id_beneficiario%type,
        p_id_plano IN beneficiario.id_plano%type,
        p_nome_beneficiario IN beneficiario.nome_beneficiario%type,
        p_cpf IN beneficiario.cpf%type,
        p_data_nascimento IN beneficiario.data_nascimento%type,
        p_sexo IN beneficiario.sexo%type,
        p_email IN beneficiario.email%type,
        p_telefone IN beneficiario.telefone%type,
        p_numero_carteirinha IN beneficiario.numero_carteirinha%type,
        p_data_validade_carteirinha IN beneficiario.data_validade_carteirinha%type,
        p_status_beneficiario IN beneficiario.status_beneficiario%type    
    );

    -- Deleta dados na tabela Beneficiario
    PROCEDURE prc_deletar
    (
        p_id_beneficiario IN beneficiario.id_beneficiario%type
    );

END pkg_beneficiario;
/

-- Criando Especificação do package da tabela Beneficiario, que realizara e tratará os comandos DML
CREATE OR REPLACE PACKAGE BODY pkg_beneficiario AS
    -- Insere dados na tabela Beneficiario
    PROCEDURE prc_inserir
    (
        p_id_plano IN beneficiario.id_plano%type,
        p_nome_beneficiario IN beneficiario.nome_beneficiario%type,
        p_cpf IN beneficiario.cpf%type,
        p_data_nascimento IN beneficiario.data_nascimento%type,
        p_sexo IN beneficiario.sexo%type,
        p_email IN beneficiario.email%type,
        p_telefone IN beneficiario.telefone%type,
        p_numero_carteirinha IN beneficiario.numero_carteirinha%type,
        p_data_validade_carteirinha IN beneficiario.data_validade_carteirinha%type,
        p_status_beneficiario IN beneficiario.status_beneficiario%type
    )
    IS
        -- Declaração de variaveis internas da procedure
        v_id_plano beneficiario.id_plano%type;
        v_nome_beneficiario beneficiario.nome_beneficiario%type;
        v_cpf beneficiario.cpf%type;
        v_data_nascimento beneficiario.data_nascimento%type;
        v_sexo beneficiario.sexo%type;
        v_email beneficiario.email%type;
        v_telefone beneficiario.telefone%type;
        v_numero_carteirinha beneficiario.numero_carteirinha%type;
        v_data_validade_carteirinha beneficiario.data_validade_carteirinha%type;
        v_status_beneficiario beneficiario.status_beneficiario%type;
        
    BEGIN
    -- PL/SQL
    
    -- Tratar Valores para inserções de registros na tabela Beneficiario
    v_id_plano := p_id_plano;
    v_nome_beneficiario := fn_nrm_texto(p_nome_beneficiario);
    v_cpf := p_cpf;
    v_data_nascimento := p_data_nascimento;
    v_sexo := fn_nrm_texto(p_sexo);
    v_email := p_email;
    v_telefone := p_telefone;
    v_numero_carteirinha := p_numero_carteirinha;
    v_data_validade_carteirinha := p_data_validade_carteirinha;
    v_status_beneficiario := fn_nrm_texto(p_status_beneficiario);
    
    -- Verifica se os valores para alteração nos campos estão conforme esperado pela tabela.
    CASE
        WHEN NOT
        (
            REGEXP_LIKE(v_id_plano, '^[0-9]+$') AND
            REGEXP_LIKE(v_nome_beneficiario, '^[A-Z ]+$') AND
            REGEXP_LIKE(v_cpf, '^[0-9]+$') AND
            (v_data_nascimento <= sysdate) AND -- Conferir se data de nascimento é menor ou igual a data atual
            REGEXP_LIKE(v_sexo, '^[A-Z]+$') AND
            REGEXP_LIKE(v_telefone, '^[0-9]+$') AND
            REGEXP_LIKE(v_numero_carteirinha, '^[0-9]+$') AND
            (v_data_validade_carteirinha >= sysdate) AND -- Conferir se data de validade de carteirinha é maior ou igual a data atual
            REGEXP_LIKE(v_status_beneficiario, '^[A-Z]+$')
        ) THEN
            RAISE_APPLICATION_ERROR(-20003, 'Há campos que possuem caracteres incompatíveis.');
        END CASE;
        
        -- Apos conferencias, inserir registro na tabela
    INSERT INTO beneficiario 
    (
        id_plano,
        nome_beneficiario,
        cpf,
        data_nascimento,
        sexo,
        email,
        telefone,
        numero_carteirinha,
        data_validade_carteirinha,
        status_beneficiario
    )
    VALUES
    (
        v_id_plano,
        v_nome_beneficiario,
        v_cpf,
        v_data_nascimento,
        v_sexo,
        v_email,
        v_telefone,
        v_numero_carteirinha,
        v_data_validade_carteirinha,
        v_status_beneficiario
    );
    END prc_inserir;
    
    -- Altera dados na tabela Beneficiario
    PROCEDURE prc_alterar
    (
        p_id_beneficiario IN beneficiario.id_beneficiario%type,
        p_id_plano IN beneficiario.id_plano%type,
        p_nome_beneficiario IN beneficiario.nome_beneficiario%type,
        p_cpf IN beneficiario.cpf%type,
        p_data_nascimento IN beneficiario.data_nascimento%type,
        p_sexo IN beneficiario.sexo%type,
        p_email IN beneficiario.email%type,
        p_telefone IN beneficiario.telefone%type,
        p_numero_carteirinha IN beneficiario.numero_carteirinha%type,
        p_data_validade_carteirinha IN beneficiario.data_validade_carteirinha%type,
        p_status_beneficiario IN beneficiario.status_beneficiario%type    
    )
    IS
        -- Declaração de variaveis internas da procedure
        v_id_beneficiario beneficiario.id_beneficiario%type;
        v_id_plano beneficiario.id_plano%type;
        v_nome_beneficiario beneficiario.nome_beneficiario%type;
        v_cpf beneficiario.cpf%type;
        v_data_nascimento beneficiario.data_nascimento%type;
        v_sexo beneficiario.sexo%type;
        v_email beneficiario.email%type;
        v_telefone beneficiario.telefone%type;
        v_numero_carteirinha beneficiario.numero_carteirinha%type;
        v_data_validade_carteirinha beneficiario.data_validade_carteirinha%type;
        v_status_beneficiario beneficiario.status_beneficiario%type;

    BEGIN
        -- PL/SQL
        
        -- Tratar Valores para inserções de registros na tabela Beneficiario
        v_id_beneficiario := p_id_beneficiario;
        v_id_plano := p_id_plano;
        v_nome_beneficiario := fn_nrm_texto(p_nome_beneficiario);
        v_cpf := p_cpf;
        v_data_nascimento := p_data_nascimento;
        v_sexo := fn_nrm_texto(p_sexo);
        v_email := p_email;
        v_telefone := p_telefone;
        v_numero_carteirinha := p_numero_carteirinha;
        v_data_validade_carteirinha := p_data_validade_carteirinha;
        v_status_beneficiario := fn_nrm_texto(p_status_beneficiario);
        
        -- Verifica se os valores para alteração nos campos estão conforme esperado pela tabela.
        CASE
            WHEN NOT
            (
                REGEXP_LIKE(v_id_beneficiario, '^[0-9]+$') AND
                REGEXP_LIKE(v_id_plano, '^[0-9]+$') AND
                REGEXP_LIKE(v_nome_beneficiario, '^[A-Z ]+$') AND
                REGEXP_LIKE(v_cpf, '^[0-9]+$') AND
                (v_data_nascimento <= sysdate) AND -- Conferir se data de nascimento é menor ou igual a data atual
                REGEXP_LIKE(v_sexo, '^[A-Z]+$') AND
                REGEXP_LIKE(v_telefone, '^[0-9]+$') AND
                REGEXP_LIKE(v_numero_carteirinha, '^[0-9]+$') AND
                (v_data_validade_carteirinha >= sysdate) AND -- Conferir se data de validade de carteirinha é maior ou igual a data atual
                REGEXP_LIKE(v_status_beneficiario, '^[A-Z]+$')
            ) THEN
                RAISE_APPLICATION_ERROR(-20003, 'Há campos que possuem caracteres incompatíveis.');
            END CASE;
        -- Apos conferencias, inserir registro na tabela
        UPDATE beneficiario
        SET
            id_plano = v_id_plano,
            nome_beneficiario = v_nome_beneficiario,
            cpf = v_cpf,
            data_nascimento = v_data_nascimento,
            sexo = v_sexo,
            email = v_email,
            telefone = v_telefone,
            numero_carteirinha = v_numero_carteirinha,
            data_validade_carteirinha = v_data_validade_carteirinha,
            status_beneficiario = v_status_beneficiario,
            data_ultima_alteracao = sysdate
        WHERE id_beneficiario = v_id_beneficiario;
    END prc_alterar;

    -- Deleta dados na tabela Beneficiario
    PROCEDURE prc_deletar
    (
        p_id_beneficiario IN beneficiario.id_beneficiario%type
    )
    IS
        v_id_beneficiario beneficiario.id_beneficiario%type;
    -- Declaração de variaveis internas da procedure
    BEGIN
        v_id_beneficiario := fn_nrm_texto(p_id_beneficiario);
        CASE
            WHEN NOT (REGEXP_LIKE(v_id_beneficiario, '^[0-9]+$'))
            THEN
                RAISE_APPLICATION_ERROR(-20003, 'Há campos que possuem caracteres incompatíveis.');
        END CASE;
        -- Apos conferencia, deletar registro na tabela
        DELETE FROM beneficiario WHERE id_beneficiario = v_id_beneficiario;
    -- PL/SQL
    END prc_deletar;
    
END pkg_beneficiario;
/