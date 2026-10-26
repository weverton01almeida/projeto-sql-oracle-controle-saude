-- Criando Especificação do package da tabela Beneficiario, que realizara e tratará os comandos DML
CREATE OR REPLACE PACKAGE pkg_guia_atendimento AS
    -- Insere dados na tabela guia_atendimento
    PROCEDURE prc_inserir
    (
        p_id_beneficiario guia_atendimento.id_beneficiario%type,
        p_id_prestador guia_atendimento.id_prestador%type,
        p_id_plano guia_atendimento.id_plano%type,
        p_data_hora_entrada guia_atendimento.data_hora_entrada%type,
        p_data_hora_alta guia_atendimento.data_hora_alta%type,
        p_tipo_guia guia_atendimento.tipo_guia%type,
        p_status_guia guia_atendimento.status_guia%type
    );
    -- Altera dados na tabela guia_atendimento
    PROCEDURE prc_alterar
    (
        p_id_guia guia.atendimento.id_guia%type,
        p_id_beneficiario guia_atendimento.id_beneficiario%type,
        p_id_prestador guia_atendimento.id_prestador%type,
        p_id_plano guia_atendimento.id_plano%type,
        p_data_hora_entrada guia_atendimento.data_hora_entrada%type,
        p_data_hora_alta guia_atendimento.data_hora_alta%type,
        p_tipo_guia guia_atendimento.tipo_guia%type,
        p_status_guia guia_atendimento.status_guia%type
    );
    -- Deleta dados na tabela guia_atendimento
    PROCEDURE prc_deletar
    (
        p_id_guia guia.atendimento.id_guia%type
    );
    
END pkg_guia_beneficiario;
/


-- Criando o body do package da tabela Beneficiario, que realizara e tratará os comandos DML
CREATE OR REPLACE PACKAGE BODY pkg_guia_atendimento AS


END pkg_guia_beneficiario;
/