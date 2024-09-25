SELECT
    A.SEQPRODUTO AS COD_PRODUTO,
    D.SEQFAMILIA AS COD_FAMILIA,
    B.DESCCOMPLETA AS PRODUTO,
    I.NOMEREDUZIDO AS LOJA,
    J.DESCSEGMENTO AS SEGMENTO,
    H.EMBALAGEM ||' '|| H.QTDEMBALAGEM AS EMBALAGEM,
    CASE
        WHEN H.QTDEMBALAGEM = 1 THEN 'R$ '||TO_CHAR(ROUND(A.CMULTVLRNF, 2), 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''')
        ELSE 'R$ '||TO_CHAR(ROUND(A.CMULTVLRNF * H.QTDEMBALAGEM, 2), 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''')
        END AS CUSTO,
    'R$ '||TO_CHAR(C.PRECOVALIDNORMAL, 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''') AS PRECO_ATUAL,
    NVL(D.PERMARKUP, G.PERMARKUP) || ' %' AS MARKUP_CADASTRADO,
    CASE
        WHEN H.QTDEMBALAGEM = 1 THEN ROUND(((C.PRECOVALIDNORMAL / A.CMULTVLRNF) - 1) * 100, 2) || ' %'
        ELSE  ROUND((((C.PRECOVALIDNORMAL / H.QTDEMBALAGEM) / A.CMULTVLRNF) - 1) * 100, 2) || ' %'
        END AS MARKUP_PRATICADO,
    'R$ '||TO_CHAR((ROUND(A.CMULTVLRNF, 2) + (ROUND((A.CMULTVLRNF * DECODE(NVL(D.PERMARKUP, 0), 0, NVL(G.PERMARKUP, 0), NVL(D.PERMARKUP, 0)) / 100), 2))) * H.QTDEMBALAGEM, 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''') AS PRECO_SUGERIDO,
    'R$ '||TO_CHAR(C.PRECOVALIDPROMOC, 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''') AS PRECO_PROMOCIONAL
FROM MRL_PRODUTOEMPRESA A
    INNER JOIN MAP_PRODUTO B ON A.SEQPRODUTO = B.SEQPRODUTO
    INNER JOIN MRL_PRODEMPSEG C ON A.SEQPRODUTO = C.SEQPRODUTO AND A.NROEMPRESA = C.NROEMPRESA AND C.STATUSVENDA = 'A'
    INNER JOIN MAD_FAMSEGMENTO D ON B.SEQFAMILIA = D.SEQFAMILIA AND C.NROSEGMENTO = D.NROSEGMENTO
    INNER JOIN MAP_FAMDIVISAO E ON E.SEQFAMILIA = D.SEQFAMILIA
    INNER JOIN MAP_FAMDIVCATEG F ON F.SEQFAMILIA = E.SEQFAMILIA AND F.NRODIVISAO = E.NRODIVISAO AND F.STATUS = 'A'
    INNER JOIN MAP_CATEGORIA G ON G.SEQCATEGORIA = F.SEQCATEGORIA AND G.ACTFAMILIA = 'S' AND G.TIPCATEGORIA = 'M'
    INNER JOIN MAP_FAMEMBALAGEM H ON B.SEQFAMILIA = H.SEQFAMILIA AND C.QTDEMBALAGEM = H.QTDEMBALAGEM
    INNER JOIN GE_EMPRESA I ON I.NROEMPRESA = A.NROEMPRESA AND I.STATUS = 'A'
    INNER JOIN MAD_SEGMENTO J ON J.NROSEGMENTO = D.NROSEGMENTO
WHERE C.PRECOVALIDNORMAL > 0
    AND EXISTS (SELECT 1
                FROM MLF_NFITEM NF, MLF_NOTAFISCAL X
                WHERE NF.SEQNF = X.SEQNF
                    AND NF.SEQPRODUTO = A.SEQPRODUTO
                    AND A.NROEMPRESA = NF.NROEMPRESA
                    AND J.DESCSEGMENTO != 'PADARIA'
                    AND X.SEQPESSOA = :NR1
                    AND A.SEQPRODUTO BETWEEN :DT1 AND :DT2);