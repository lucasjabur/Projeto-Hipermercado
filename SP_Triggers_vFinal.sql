-- Caso de uso de Trigger:
-- Ao inserir um registro na tabela Contem, atualizar o valor total
-- do Pedido_Compra (Lembrar dos descontos do fornecedor)
CREATE OR REPLACE FUNCTION att_preco_pedido_compra()
RETURNS trigger AS $$
DECLARE 
	V_NRO_FORNECEDOR Contem.Nro_Fornecedor%TYPE;
	V_NRO_PRODUTO Contem.Nro_Produto%TYPE;
	V_NRO_PEDIDO Contem.Nro_Pedido%TYPE;
	V_DIFF_QUANT Contem.Quantidade%TYPE;
	V_PRECO_COMPRA Contem.Quantidade%TYPE;
	V_DESCONTO_FORN Fornecedor.Descontos%TYPE;
BEGIN
V_NRO_FORNECEDOR := COALESCE(new.Nro_Fornecedor, old.Nro_Fornecedor);
V_NRO_PRODUTO := COALESCE(new.Nro_Produto, old.Nro_Produto);
V_NRO_PEDIDO := COALESCE(new.Nro_Pedido, old.Nro_Pedido);

-- Buscar desconto de fornecedor
SELECT f.Descontos
 INTO V_DESCONTO_FORN
FROM Fornecedor f
 JOIN Produto_Fornecido pf ON pf.Nro_Fornecedor = f.Nro_Fornecedor
 WHERE pf.Nro_Produto = V_NRO_PRODUTO AND
	   pf.Nro_Fornecedor = V_NRO_FORNECEDOR;
-- Buscar preço de compra do produto
SELECT Preco_Compra
 INTO V_PRECO_COMPRA
FROM Produto_Fornecido
 WHERE Nro_Produto = V_NRO_PRODUTO AND
	   Nro_Fornecedor = V_NRO_FORNECEDOR;

V_DESCONTO_FORN := COALESCE(V_DESCONTO_FORN, 0);

IF TG_OP = 'UPDATE' THEN
	V_DIFF_QUANT := new.Quantidade - old.Quantidade;
	UPDATE Pedido_Compra
	 SET Valor_Total = Valor_Total + (V_DIFF_QUANT * V_PRECO_COMPRA),
		 Valor_Com_Desconto = Valor_Com_Desconto + ((V_DIFF_QUANT  * V_PRECO_COMPRA) * (1 - (V_DESCONTO_FORN/100)))
	WHERE Nro_Pedido = V_NRO_PEDIDO;
ELSIF TG_OP = 'INSERT' THEN
	UPDATE Pedido_Compra
	 SET Valor_Total = Valor_Total + (new.Quantidade * V_PRECO_COMPRA),
	     Valor_Com_Desconto = Valor_Com_Desconto + ((new.Quantidade  * V_PRECO_COMPRA) * (1 - (V_DESCONTO_FORN/100)))
	WHERE Nro_Pedido = V_NRO_PEDIDO;
ELSIF TG_OP = 'DELETE' THEN
	UPDATE Pedido_Compra
	 SET Valor_Total = Valor_Total - (old.Quantidade * V_PRECO_COMPRA),
	 	 Valor_Com_Desconto = Valor_Com_Desconto - ((old.Quantidade * V_PRECO_COMPRA) * (1 - (V_DESCONTO_FORN/100)))
	WHERE Nro_Pedido = V_NRO_PEDIDO;
END IF;

RETURN NULL;
END $$ language 'plpgsql';

CREATE TRIGGER att_preco_pedido_compra
AFTER INSERT OR UPDATE OR DELETE ON Contem
FOR EACH ROW 
EXECUTE PROCEDURE att_preco_pedido_compra();




-- Caso de uso de Stored Procedure:
-- Inserir pedidos de compra se a quantidade em estoque dos produtos decair em menos
-- de 200 itens. Ao executar, verifica esses produtos e busca na tabela Produto_Fornecido
-- e, caso não existir pedido de compra em aberto (Previsao_Entrega > current_date), inserir
-- um pedido de compra com o menor preço de compra (Produto_Fornecido.Preco_Compra) de +200 itens;
CREATE OR REPLACE FUNCTION repor_estoque_produtos
    (IN V_CPF_FUNCIONARIO Funcionario.CPF%TYPE)
RETURNS VOID AS $$
DECLARE 
    tupla record;
    V_NRO_FORNECEDOR Fornecedor.Nro_Fornecedor%TYPE;
    V_NRO_PEDIDO Pedido_Compra.Nro_Pedido%TYPE;
    V_PRECO_COMPRA Produto_Fornecido.Preco_Compra%TYPE;
    V_DESCONTO_FORN Fornecedor.Descontos%TYPE;
    V_VALOR_TOTAL NUMERIC := 0;
    V_VALOR_COM_DESCONTO NUMERIC := 0;
BEGIN
    FOR tupla IN SELECT * FROM PRODUTO WHERE QUANTIDADE <= 200
    LOOP
        -- Resgata o fornecedor com menor preço de compra
        SELECT Nro_Fornecedor, Preco_Compra
          INTO V_NRO_FORNECEDOR, V_PRECO_COMPRA
        FROM Produto_Fornecido
        WHERE Nro_Produto = tupla.Nro_Produto
        ORDER BY Preco_Compra
        LIMIT 1;

        -- Busca o desconto do fornecedor
        SELECT Descontos
          INTO V_DESCONTO_FORN
        FROM Fornecedor
        WHERE Nro_Fornecedor = V_NRO_FORNECEDOR;

        -- Calcula valores totais para o pedido atual
        V_VALOR_TOTAL := V_VALOR_TOTAL + (200 * V_PRECO_COMPRA);
        V_VALOR_COM_DESCONTO := V_VALOR_COM_DESCONTO + ((200 * V_PRECO_COMPRA) * (1 - V_DESCONTO_FORN / 100));

        -- Gera o próximo número de pedido
        SELECT COALESCE(MAX(Nro_Pedido), 0) + 1 INTO V_NRO_PEDIDO FROM Pedido_Compra;

        -- Cria o pedido de compra com valores já calculados
        INSERT INTO Pedido_Compra (Nro_Pedido, Data_Emissao, Condicao_Pagamento, Devolucao, Valor_Total, Valor_Com_Desconto)
          VALUES (V_NRO_PEDIDO, CURRENT_DATE, 'Condição padrão de pagamento de pedidos automáticos', FALSE, V_VALOR_TOTAL, V_VALOR_COM_DESCONTO);

        -- Registra o usuário que fez a solicitação
        INSERT INTO Solicita (Nro_Pedido, CPF_FUNCIONARIO)
          VALUES (V_NRO_PEDIDO, V_CPF_FUNCIONARIO);

        -- Registra o produto no pedido de compra
        INSERT INTO Contem (Nro_Pedido, Nro_Fornecedor, Nro_Produto, Quantidade)
          VALUES (V_NRO_PEDIDO, V_NRO_FORNECEDOR, tupla.Nro_Produto, 200);

        -- Reset dos valores totais para o próximo pedido
        V_VALOR_TOTAL := 0;
        V_VALOR_COM_DESCONTO := 0;
    END LOOP;
END $$ LANGUAGE 'plpgsql';

