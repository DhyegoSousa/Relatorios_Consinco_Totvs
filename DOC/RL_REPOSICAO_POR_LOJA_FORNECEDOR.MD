
# Doc - RL_REPOSICAO_POR_LOJA_FORNECEDOR

## Descrição

Esta consulta SQL é projetada para extrair informações detalhadas sobre produtos recebidos em uma empresa, relacionando dados de notas fiscais e fornecedores. A consulta agrega dados de várias tabelas para apresentar a quantidade conferida, a descrição do produto e o preço atual, com a finalidade de facilitar o controle e a análise de estoque.

## Estrutura da Consulta

### Seleção de Colunas

A consulta começa selecionando as seguintes colunas:

- **SEQPRODUTO**: Número de sequência do produto.
- **DESCRICAOREDUZIDA**: Descrição completa do produto.
- **QTDCONFERIDA**: Quantidade conferida do produto.
- **PRECO_ATUAL**: Preço atual do produto, formatado com o símbolo "R$".

### Subconsulta para Preço Atual

A subconsulta aninhada busca o preço mais recente do produto usando as seguintes tabelas:

- **MLF_NFITEM (I2)**: Contém informações sobre itens de nota fiscal.
- **MRL_PRODEMPSEG (C2)**: Contém informações sobre o preço do produto.

A subconsulta filtra os preços válidos, utilizando condições para garantir que os dados correspondam ao produto e à empresa em questão.

### Tabelas e Joins

A consulta utiliza as seguintes tabelas:

- **MAD_CARGARECEBNF (A)**: Dados sobre a carga de recebimento de notas fiscais.
- **MLF_NOTAFISCAL (B)**: Dados sobre notas fiscais.
- **MLF_NFITEM (I)**: Dados sobre itens de nota fiscal.
- **MAD_CARGARECEB (C)**: Informações sobre a carga de recebimento.
- **GE_PESSOA (D)**: Informações sobre fornecedores.
- **MAD_CARGARECPROD (E)**: Dados sobre produtos conferidos.
- **MAD_CARGARECITEM (F)**: Dados sobre itens de carga de recebimento.
- **MAP_PRODUTO (G)**: Dados sobre produtos.
- **MAD_CARGARECITEMLOGRUB (H)**: Informações adicionais sobre itens.

### Condições de Filtragem (WHERE)

As condições de filtragem garantem que apenas os registros relevantes sejam retornados. As principais condições incluem:

- Correspondência entre números de notas fiscais e fornecedores.
- Filtragem por data de recebimento e empresa.
- Uso de funções como `NVL` para tratar valores nulos.

### Ordenação dos Resultados

Os resultados são ordenados por:

1. **NOMERAZAO**: Nome da razão social do fornecedor.
2. **NUMERONF**: Número da nota fiscal.
3. **DESCREDUZIDA**: Descrição reduzida do produto.

## Execução da Consulta

Para executar a consulta, você deve fornecer os seguintes parâmetros:

- **&empresa**: O número da empresa a ser consultada.
- **&dfnSeqFornecedor**: O número de sequência do fornecedor.
- **&DT1**: Data de início para o filtro de recebimento.
- **&DT2**: Data de fim para o filtro de recebimento.

## Conclusão

Esta consulta SQL é uma ferramenta poderosa para gerenciar informações sobre produtos recebidos e seus preços, proporcionando uma visão clara e estruturada do inventário de produtos.
