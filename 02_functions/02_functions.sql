-- Function criada com o objetivo de normalizar os textos inseridos no banco de dados
CREATE OR REPLACE FUNCTION fn_nrm_texto (p_texto VARCHAR2)
RETURN VARCHAR2

    IS
        v_texto_normalizado VARCHAR2(200);
        
        -- Lista de letras com acentos
        v_com_acento CONSTANT VARCHAR2(100) := 'ÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑáàâãäéèêëíìîïóòôõöúùûüçñ';
        
        -- Lista de letras sem acentos
        v_sem_acento CONSTANT VARCHAR2(100) := 'AAAAAEEEEIIIIOOOOOUUUUCNaaaaaeeeeiiiiooooouuuucn';
        
    BEGIN
        v_texto_normalizado := TRANSLATE(TRIM(UPPER(p_texto)),v_com_acento,v_sem_acento);
    return v_texto_normalizado;
END;
