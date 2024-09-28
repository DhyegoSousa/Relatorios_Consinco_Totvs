SELECT  
        E.SEQPRODUTO AS SEQPRODUTO,
        G.DESCCOMPLETA AS DESCRICAOREDUZIDA,
        E.QTDCONFERIDA AS QTDCONFERIDA,
        (SELECT 'R$ ' || TO_CHAR(MAX(C2.PRECOVALIDNORMAL), 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''')
         FROM MLF_NFITEM I2
         INNER JOIN MRL_PRODEMPSEG C2
           ON I2.SEQPRODUTO = C2.SEQPRODUTO
           AND I2.NROEMPRESA = C2.NROEMPRESA
           AND C2.STATUSVENDA = 'A'
         WHERE I2.SEQPESSOA = B.SEQPESSOA
           AND I2.DTAMOVTOITEM BETWEEN &DT1 AND &DT2
           AND I2.NROEMPRESA = B.NROEMPRESA
           AND I2.SEQPRODUTO = E.SEQPRODUTO
         ) AS PRECO_ATUAL
FROM    MAD_CARGARECEBNF A,
        MLF_NOTAFISCAL B,
        MLF_NFITEM I,
        MAD_CARGARECEB C,
        GE_PESSOA D,
        MAD_CARGARECPROD E,
        MAD_CARGARECITEM F,
        MAP_PRODUTO G,
        MAD_CARGARECITEMLOGRUB H
WHERE   A.NUMERONF = B.NUMERONF
AND     A.SERIENF = B.SERIENF
AND     A.SEQFORNECEDOR = B.SEQPESSOA
AND     A.NROEMPRESA = B.NROEMPRESA
AND     A.NROCARGARECEB = B.NROINTERNORECEB
AND     C.NROCARGARECEB = A.NROCARGARECEB
AND     C.NROEMPRESA = A.NROEMPRESA
AND     D.SEQPESSOA = A.SEQFORNECEDOR
AND     E.NROCARGARECEB = A.NROCARGARECEB
AND     E.NROEMPRESA = A.NROEMPRESA
AND     F.NROCARGARECEB = E.NROCARGARECEB
AND     F.NROEMPRESA = E.NROEMPRESA
AND     F.SEQPRODUTO = E.SEQPRODUTO
AND     G.SEQPRODUTO = E.SEQPRODUTO
AND     H.NROCARGARECEB(+) = E.NROCARGARECEB
AND     H.NROEMPRESA(+) = E.NROEMPRESA
AND     H.SEQPRODUTO(+) = E.SEQPRODUTO
AND     I.NUMERONF = B.NUMERONF
AND     I.SEQPESSOA = B.SEQPESSOA
AND     I.SERIENF = B.SERIENF
AND     I.TIPNOTAFISCAL = B.TIPNOTAFISCAL
AND     I.NROEMPRESA = B.NROEMPRESA
AND     NVL(I.SEQNF, 0) = NVL(B.SEQNF, 0)
AND     I.SEQPRODUTO = F.SEQPRODUTO
AND     A.NROEMPRESA = &empresa
AND     A.SEQFORNECEDOR = &dfnSeqFornecedor
AND     B.DTARECEBIMENTO BETWEEN &DT1 AND &DT2
ORDER BY D.NOMERAZAO, 
         A.NUMERONF, 
         G.DESCREDUZIDA;