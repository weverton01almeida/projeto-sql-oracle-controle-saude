-- Executar comando com privilégios de administrador para utilizar arquivos csv nos pl/sql
-- CREATE OR REPLACE DIRECTORY DIR_CARGA_CSV AS 'C:\CARGA';

-- Definir permissões do diretorio para o usuario
-- GRANT READ, WRITE ON DIRECTORY DIR_CARGA_CSV TO FATURAMENTO_SYS;

SET SERVEROUTPUT ON

DECLARE
    v_arquivo UTL_FILE.FILE_TYPE;
    v_linha VARCHAR2(2000);
    
    -- Variáveis para extração dos valores das colunas
    v_id_plano                          VARCHAR2(100);
    v_nome_beneficiario                 VARCHAR2(100);
    v_cpf                               VARCHAR2(100);
    v_data_nascimento                   VARCHAR2(100);
    v_sexo                              VARCHAR2(100);
    v_email                             VARCHAR2(100);
    v_telefone                          VARCHAR2(100);
    v_data_validade_carteirinha         VARCHAR2(100);
    v_status_beneficiario               VARCHAR2(100);
    
    
    -- Posições do delimitador (;)
    v_delim_1 NUMBER;
    v_delim_2 NUMBER;
    v_delim_3 NUMBER;
    v_delim_4 NUMBER;
    v_delim_5 NUMBER;
    v_delim_6 NUMBER;
    v_delim_7 NUMBER;
    v_delim_8 NUMBER;
    
    v_contador NUMBER;
    

    
    BEGIN
        -- inicialização v_contador
        v_contador := 0;
        -- abrir arquivo csv em formato leitura
        v_arquivo := UTL_FILE.FOPEN('DIR_CARGA_CSV', '04_03_carga_dados_beneficiario.csv', 'r', 32767); -- 32767 é o limite de caracteres para a variavel VARCHAR2
        
        UTL_FILE.GET_LINE(v_arquivo, v_linha); -- Ja ler a primeira linha, para pular cabeçalho no inicio do loop
        
        LOOP
            BEGIN
                UTL_FILE.GET_LINE(v_arquivo, v_linha); -- ler proxima linha do arquivo
                
                -- Inserir as poisições dos ';'
                    v_delim_1 := INSTR(v_linha, ';', 1,1);
                    v_delim_2 := INSTR(v_linha, ';', 1,2);
                    v_delim_3 := INSTR(v_linha, ';', 1,3);
                    v_delim_4 := INSTR(v_linha, ';', 1,4);
                    v_delim_5 := INSTR(v_linha, ';', 1,5);
                    v_delim_6 := INSTR(v_linha, ';', 1,6);
                    v_delim_7 := INSTR(v_linha, ';', 1,7);
                    v_delim_8 := INSTR(v_linha, ';', 1,8);

                -- Obter os valores das colunas
                v_id_plano                  := SUBSTR(v_linha, 1, v_delim_1 -1); -- Obtem o valor do 1° caractere até o ultimo caractere antes do 1° ';'
                v_nome_beneficiario         := SUBSTR(v_linha, v_delim_1 +1, v_delim_2 - v_delim_1 -1); -- Obtem o valor do 1° caractere após o 1° ';' até o ultimo caractere antes do 2° ';'
                v_cpf                       := SUBSTR(v_linha, v_delim_2 +1, v_delim_3 - v_delim_2 -1); -- Obtem o valor do 1° caractere após o 2° ';' até o ultimo caractere antes do 3° ';'
                v_data_nascimento           := SUBSTR(v_linha, v_delim_3 +1, v_delim_4 - v_delim_3 -1); -- Obtem o valor do 1° caractere após o 3° ';' até o ultimo caractere antes do 4° ';'  
                v_sexo                      := SUBSTR(v_linha, v_delim_4 +1, v_delim_5 - v_delim_4 -1); -- Obtem o valor do 1° caractere após o 4° ';' até o ultimo caractere antes do 5° ';'
                v_email                     := SUBSTR(v_linha, v_delim_5 +1, v_delim_6 - v_delim_5 -1); -- Obtem o valor do 1° caractere após o 5° ';' até o ultimo caractere antes do 6° ';'
                v_telefone                  := SUBSTR(v_linha, v_delim_6 +1, v_delim_7 - v_delim_6 -1); -- Obtem o valor do 1° caractere após o 6° ';' até o ultimo caractere antes do 7° ';'
                v_data_validade_carteirinha := SUBSTR(v_linha, v_delim_7 +1, v_delim_8 - v_delim_7 -1); -- Obtem o valor do 1° caractere após o 7° ';' até o ultimo caractere antes do 8° ';'  
                v_status_beneficiario       := SUBSTR(v_linha, v_delim_8 +1); --- obtem o valor apos o ultimo ';'(8°) ate o final da linha;
                
                --Executar a procedure de pkg_prestador_inserir, para inserir os parametros da linha obtida
                pkg_beneficiario.prc_inserir(
                    p_id_plano                  => TO_NUMBER(v_id_plano),
                    p_nome_beneficiario         => v_nome_beneficiario,
                    p_cpf                       => v_cpf,
                    p_data_nascimento           => TO_DATE(v_data_nascimento, 'DD-MM-YYYY'),
                    p_sexo                      => v_sexo,
                    p_email                     => v_email,
                    p_telefone                  => v_telefone,
                    p_data_validade_carteirinha => v_data_validade_carteirinha,
                    p_status_beneficiario       => v_status_beneficiario
                );
                
                -- Contar quantas linhas o processo ja rodou
                v_contador := v_contador +1;
            
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    EXIT; -- apos não conseguir ler a proxima linha, finalizar o loop. Foi concluido o processo
                END;
            END LOOP;
            
            -- Fechar instancia aberta do arquivo
            UTL_FILE.FCLOSE(v_arquivo);
            
            COMMIT; -- commitar para garantir que os dados estão gravados no banco
            
            DBMS_OUTPUT.PUT_LINE('Carga concluída com sucesso: ' || v_contador || ' Linhas inseridas na tabela Beneficiario');
            
            EXCEPTION
                WHEN OTHERS THEN -- Caso der falha em alguma inserção na tabela
                    -- Caso instancia do arquivo estiver aberta, fecha-lo. 
                    IF UTL_FILE.IS_OPEN(v_arquivo) THEN
                        UTL_FILE.FCLOSE(v_arquivo);
                    END IF;
                    
                    ROLLBACK; -- Cancelar inserção de todas as linhas previamente inseridas
                    
                    DBMS_OUTPUT.PUT_LINE('Erro na linha: ' || (v_contador+1) || ': ' || SQLERRM) ;
            END;
/