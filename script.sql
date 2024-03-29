-- Exercicio 5
CREATE OR REPLACE PROCEDURE sp_cadastra_cliente_variadic ( VARIADIC clientes VARCHAR [])
LANGUAGE plpgsql
AS $$
DECLARE
	cliente VARCHAR;
BEGIN
	FOREACH cliente IN ARRAY clientes LOOP
		CALL sp_cadastrar_cliente(cliente);
	END LOOP;
RAISE NOTICE 'Os clientes % foram cadastrados', clientes ;
END;
$$
DO $$
DECLARE
	clientes VARCHAR;
BEGIN
	CALL sp_cadastra_cliente_variadic('Julia', 'Joabe');
END $$;

SELECT * FROM tb_cliente

-- --Exercicio 1.4
-- --Não entendi como esse seria diferente do exercicio anterior
-- DROP PROCEDURE sp_conta_pedido3
-- CREATE OR REPLACE PROCEDURE sp_conta_pedido3 (IN codigo INT, OUT resultado INT)
-- LANGUAGE plpgsql
-- AS $$
-- DECLARE 
-- 	contagem INTEGER;
-- 	codigo INT := 1;
-- BEGIN
-- 	SELECT COUNT(cod_cliente) INTO contagem FROM tb_pedido WHERE codigo = cod_cliente;
-- 	resultado := contagem;
-- END;
-- $$
-- DO $$
-- DECLARE
-- 	resultado INT;
-- 	codigo INT;
-- BEGIN
-- 	CALL sp_conta_pedido3(codigo, resultado);
-- 	RAISE NOTICE 'O cliente tem % pedidos', resultado;
-- END $$;

-- --Exercicio 1.3
-- DROP PROCEDURE sp_conta_pedido2
-- CREATE OR REPLACE PROCEDURE sp_conta_pedido2 (IN codigo INT, OUT resultado INT)
-- LANGUAGE plpgsql
-- AS $$
-- DECLARE 
-- 	contagem INTEGER;
-- BEGIN
-- 	SELECT COUNT(cod_cliente) INTO contagem FROM tb_pedido WHERE codigo = cod_cliente;
-- 	resultado := contagem;
-- END;
-- $$
-- DO $$
-- DECLARE
-- 	resultado INT;
-- BEGIN
-- 	CALL sp_conta_pedido2(1, resultado);
-- 	RAISE NOTICE 'O cliente tem % pedidos', resultado;
-- END $$;

-- Exercicio 1.2
-- CREATE OR REPLACE PROCEDURE sp_conta_pedido (IN codigo INT DEFAULT NULL)
-- LANGUAGE plpgsql
-- AS $$
-- DECLARE contagem INTEGER;
-- BEGIN
-- 	IF codigo IS NOT NULL THEN
-- 		SELECT COUNT(cod_cliente) INTO contagem FROM tb_pedido WHERE codigo = cod_cliente;
-- 		RAISE NOTICE 'O cliente % tem % pedidos', codigo, contagem;
-- 	ELSE
-- 		RAISE NOTICE 'Código Invalido';
-- 	END IF;
-- END;
-- $$
-- DO $$
-- DECLARE
-- 	codigo INT :=1;
-- BEGIN
-- 	CALL sp_conta_pedido (codigo);
-- END
-- $$;

-- CREATE TABLE log(
-- 	cod_log SERIAL PRIMARY KEY,
-- 	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
-- 	procedimento VARCHAR(100) NOT NULL
-- );
-- SELECT * FROM log

-- CREATE OR REPLACE PROCEDURE sp_obter_notas_para_compor_o_troco (OUT resultado
-- VARCHAR(500), IN troco INT)
-- LANGUAGE plpgsql
-- AS $$
-- DECLARE
-- notas200 INT := 0;
-- notas100 INT := 0;
-- notas50 INT := 0;
-- notas20 INT := 0;
-- notas10 INT := 0;
-- notas5 INT := 0;
-- notas2 INT := 0;
-- moedas1 INT := 0;
-- BEGIN
-- INSERT INTO log (procedimento) VALUES ('notas de troco obtidas');
-- notas200 := troco / 200;
-- notas100 := troco % 200 / 100;
-- notas50 := troco % 200 % 100 / 50;
-- notas20 := troco % 200 % 100 % 50 / 20;
-- notas10 := troco % 200 % 100 % 50 % 20 / 10;
-- notas5 := troco % 200 % 100 % 50 % 20 % 10 / 5;
-- notas2 := troco % 200 % 100 % 50 % 20 % 10 % 5 / 2;
-- moedas1 := troco % 200 % 100 % 50 % 20 % 10 % 5 % 2;
-- resultado := concat (
-- -- E é de escape. Para que \n tenha sentido
-- -- || é um operador de concatenação
-- 'Notas de 200: ',
-- notas200 || E'\n',
-- 'Notas de 100: ',
-- notas100 || E'\n',
-- 'Notas de 50: ',
-- notas50 || E'\n',
-- 'Notas de 20: ',
-- notas20 || E'\n',
-- 'Notas de 10: ',
-- notas10 || E'\n',
-- 'Notas de 5: ',
-- notas5 || E'\n',
-- 'Notas de 2: ',
-- notas2 || E'\n',
-- 'Moedas de 1: ',
-- moedas1 || E'\n'
-- );
-- END;
-- $$
-- DO
-- $$
-- DECLARE
-- resultado VARCHAR(500);
-- troco INT := 43;
-- BEGIN
-- CALL sp_obter_notas_para_compor_o_troco (resultado, troco);
-- RAISE NOTICE '%', resultado;
-- END;
-- $$


-- CREATE OR REPLACE PROCEDURE sp_calcular_troco (OUT troco INT, IN valor_a_pagar
-- INT, IN valor_total INT)
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
-- INSERT INTO log (procedimento) VALUES ('troco calculado');
-- troco := valor_a_pagar - valor_total;
-- END;
-- $$
-- DO
-- $$
-- DECLARE
-- troco INT;
-- valor_total INT;
-- valor_a_pagar INT := 100;
-- BEGIN
-- CALL sp_calcular_valor_de_um_pedido(1, valor_total);
-- CALL sp_calcular_troco (troco, valor_a_pagar, valor_total);
-- RAISE NOTICE 'A conta foi de R$% e você pagou %, portanto, seu troco é de R$%.',
-- valor_total, valor_a_pagar, troco;
-- END;
-- $$

-- CREATE OR REPLACE PROCEDURE sp_fechar_pedido (IN valor_a_pagar INT, IN
-- cod_pedido INT)
-- LANGUAGE plpgsql
-- AS $$
-- DECLARE
-- valor_total INT;
-- BEGIN
-- --vamos verificar se o valor_a_pagar é suficiente
-- CALL sp_calcular_valor_de_um_pedido (cod_pedido, valor_total);
-- IF valor_a_pagar < valor_total THEN
-- RAISE 'R$% insuficiente para pagar a conta de R$%', valor_a_pagar,
-- valor_total;
-- ELSE
-- INSERT INTO log (procedimento) VALUES ('pedido fechado');
-- UPDATE tb_pedido p SET
-- data_modificacao = CURRENT_TIMESTAMP,
-- status = 'fechado'
-- WHERE p.cod_pedido = $2;
-- END IF;
-- END;
-- $$
-- DO $$
-- BEGIN
-- CALL sp_fechar_pedido(200, 1);
-- END;
-- $$
-- SELECT * FROM tb_pedido;

-- DROP PROCEDURE sp_calcular_valor_de_um_pedido;
-- CREATE OR REPLACE PROCEDURE sp_calcular_valor_de_um_pedido (IN p_cod_pedido
-- INT, OUT valor_total INT)
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
-- INSERT INTO log (procedimento) VALUES ('valor do pedido calculado');
-- SELECT SUM(valor) FROM
-- tb_pedido p
-- INNER JOIN tb_item_pedido ip ON
-- p.cod_pedido = ip.cod_pedido
-- INNER JOIN tb_item i ON
-- i.cod_item = ip.cod_item
-- WHERE p.cod_pedido = $1
-- INTO $2;
-- END;
-- $$
-- DO $$
-- DECLARE
-- valor_total INT;
-- BEGIN
-- CALL sp_calcular_valor_de_um_pedido(1, valor_total);
-- RAISE NOTICE 'Total do pedido %: R$%', 1, valor_total;
-- END;
-- $$

-- CREATE OR REPLACE PROCEDURE sp_adicionar_item_a_pedido (IN cod_item INT, IN
-- cod_pedido INT)
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
-- --insere novo item
-- INSERT INTO tb_item_pedido (cod_item, cod_pedido) VALUES ($1, $2);
--INSERT INTO log (procedimento) VALUES ('itens adicionados a pedido');
-- --atualiza data de modificação do pedido
-- UPDATE tb_pedido p SET data_modificacao = CURRENT_TIMESTAMP WHERE
-- p.cod_pedido = $2;
-- END;
-- $$
-- CALL sp_adicionar_item_a_pedido (1, 1);
-- SELECT * FROM tb_item_pedido;
-- SELECT * FROM tb_pedido;

-- CREATE OR REPLACE PROCEDURE sp_criar_pedido (OUT cod_pedido INT, cod_cliente INT)
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
-- INSERT INTO tb_pedido (cod_cliente) VALUES (cod_cliente);
-- INSERT INTO log (procedimento) VALUES ('pedido criado');
-- -- obtém o último valor gerado por SERIAL
-- SELECT LASTVAL() INTO cod_pedido;
-- END;
-- $$
-- DO
-- $$
-- DECLARE
-- --para guardar o código de pedido gerado
-- cod_pedido INT;
-- -- o código do cliente que vai fazer o pedido
-- cod_cliente INT;
-- BEGIN
-- -- pega o código da pessoa cujo nome é "João da Silva"
-- SELECT c.cod_cliente FROM tb_cliente c WHERE nome LIKE 'João da Silva' INTO cod_cliente;
-- --cria o pedido
-- CALL sp_criar_pedido (cod_pedido, cod_cliente);
-- RAISE NOTICE 'Código do pedido recém criado: %', cod_pedido;
-- END;
-- $$
-- SELECT * FROM tb_pedido

-- CREATE OR REPLACE PROCEDURE sp_cadastrar_cliente (IN nome VARCHAR(200), IN
-- codigo INT DEFAULT NULL)
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
-- IF codigo IS NULL THEN
-- INSERT INTO tb_cliente (nome) VALUES (nome);
-- INSERT INTO log (procedimento) VALUES ('cadastro de cliente');
-- ELSE
-- INSERT INTO tb_cliente (codigo, nome) VALUES (codigo, nome);
-- INSERT INTO log (procedimento) VALUES ('cadastro de cliente');
-- END IF;
-- END;
-- $$
-- CALL sp_cadastrar_cliente ('João da Silva');
-- CALL sp_cadastrar_cliente ('Maria Santos');
-- SELECT * FROM tb_cliente;

-- DROP TABLE tb_tipo_item;
-- CREATE TABLE tb_tipo_item(
-- cod_tipo SERIAL PRIMARY KEY,
-- descricao VARCHAR(200) NOT NULL
-- );
-- INSERT INTO tb_tipo_item (descricao) VALUES ('Bebida'), ('Comida');
-- SELECT * FROM tb_tipo_item;
-- DROP TABLE tb_item;
-- CREATE TABLE IF NOT EXISTS tb_item(
-- cod_item SERIAL PRIMARY KEY,
-- descricao VARCHAR(200) NOT NULL,
-- valor NUMERIC (10, 2) NOT NULL,
-- cod_tipo INT NOT NULL,
-- CONSTRAINT fk_tipo_item FOREIGN KEY (cod_tipo) REFERENCES
-- tb_tipo_item(cod_tipo)
-- );
-- INSERT INTO tb_item (descricao, valor, cod_tipo) VALUES
-- ('Refrigerante', 7, 1), ('Suco', 8, 1), ('Hamburguer', 12, 2), ('Batata frita', 9, 2);
-- SELECT * FROM tb_item;
-- DROP TABLE tb_item_pedido;
-- CREATE TABLE IF NOT EXISTS tb_item_pedido(
-- --surrogate key, assim cod_item pode repetir
-- cod_item_pedido SERIAL PRIMARY KEY,
-- cod_item INT,
-- cod_pedido INT,
-- CONSTRAINT fk_item FOREIGN KEY (cod_item) REFERENCES tb_item (cod_item),
-- CONSTRAINT fk_pedido FOREIGN KEY (cod_pedido) REFERENCES tb_pedido
-- (cod_pedido)
-- );

-- DROP TABLE tb_cliente;
-- CREATE TABLE tb_cliente (
-- cod_cliente SERIAL PRIMARY KEY,
-- nome VARCHAR(200) NOT NULL
-- );
-- SELECT * FROM tb_pedido;
-- DROP TABLE tb_pedido;
-- CREATE TABLE IF NOT EXISTS tb_pedido(
-- cod_pedido SERIAL PRIMARY KEY,
-- data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
-- data_modificacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
-- status VARCHAR DEFAULT 'aberto',
-- cod_cliente INT NOT NULL,
-- CONSTRAINT fk_cliente FOREIGN KEY (cod_cliente) REFERENCES
-- tb_cliente(cod_cliente)
-- )