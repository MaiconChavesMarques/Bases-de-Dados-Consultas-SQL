/*
3.3
*/

/*a*/
SELECT * FROM propriedade;

/*b*/
SELECT TipoDeAluguel, Count(*)
FROM Propriedade
GROUP BY TipoDeAluguel;

/*c*/
SELECT Cidade, Count(*)
FROM Propriedade
GROUP BY Cidade
ORDER BY Count(*) DESC;

/*
3.4
*/
SELECT 	reserva.numeroreserva 		AS chave_da_reserva,
		reserva.propriedadeestado		AS chave_da_propriedade_1,
		reserva.propriedadecidade		AS chave_da_propriedade_2,
		reserva.propriedaderua		AS chave_da_propriedade_3,
		reserva.propriedadenumero		AS chave_da_propriedade_4,
		reserva.locatariocpf			AS chave_do_locatario,
		
		reserva.datacheckout - reserva.datacheckin												AS total_de_dias,
		
		locador.nome				AS nome_do_proprietario,
		locatario.nome			AS nome_do_hospede,
		
		ROUND(reserva.precototal / (reserva.datacheckout - reserva.datacheckin),2)	   						AS preco_da_diaria
		FROM
			public.reserva
		JOIN
			public.locatario ON
			locatario.cpf = reserva.locatariocpf
		JOIN
			public.propriedade ON 
			reserva.propriedadeestado = propriedade.estado 	AND
			reserva.propriedadecidade = propriedade.cidade	AND
			reserva.propriedaderua = propriedade.rua		AND
			reserva.propriedadenumero = propriedade.numero
		JOIN
			public.locador ON
			propriedade.locadorcpf = locador.cpf
		WHERE
			reserva.confirmada=TRUE AND
			reserva.datacheckin > '2025-04-24'::date
		ORDER BY chave_da_reserva ASC;

/*
3.5
*/

/*a*/
SELECT l.nome
FROM public.locador l
JOIN public.locatario t ON l.cpf = t.cpf AND l.nome = t.nome;

/*b*/
SELECT
	ldr.nome,
	ldr.cidade,
	ldr.estado,
	COUNT(DISTINCT p.nome) AS qtd_imoveis,
	COUNT(r.numeroreserva) AS total_locacoes
FROM
	locador ldr
JOIN
	propriedade p ON ldr.cpf = p.locadorcpf
JOIN
	reserva r ON
    	r.propriedaderua = p.rua AND
    	r.propriedadenumero = p.numero AND
    	r.propriedadebairro = p.bairro AND
    	r.propriedadecidade = p.cidade AND
    	r.propriedadeestado = p.estado
GROUP BY
	ldr.cpf, ldr.nome, ldr.cidade, ldr.estado
HAVING
	COUNT(r.numeroreserva) >= 5
ORDER BY
	total_locacoes DESC;

/*c*/
SELECT
DATE_TRUNC('month', r.datacheckin) AS mes,
ROUND(AVG(r.precototal::numeric / (r.datacheckout - r.datacheckin)), 2) AS media_diaria_todas,
ROUND(AVG(CASE
          	WHEN r.confirmada = true
          	THEN r.precototal::numeric / (r.datacheckout - r.datacheckin)
      	END), 2) AS media_diaria_confirmadas
FROM
	reserva r
WHERE
	r.precototal IS NOT NULL
	AND r.datacheckout > r.datacheckin
GROUP BY
	DATE_TRUNC('month', r.datacheckin)
ORDER BY
	mes;

/*d*/
SELECT DISTINCT lct.nome
FROM
	public.locatario lct
WHERE
	EXISTS (
    	SELECT 1
    	FROM public.locador ldr
    	WHERE lct.datanascimento > ldr.datanascimento
	);

/*e*/
SELECT lct.nome
FROM
	locatario lct
WHERE
	lct.datanascimento > ALL (
    	SELECT ldr.datanascimento FROM locador ldr
	);

