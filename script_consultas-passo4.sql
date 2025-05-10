/*
3.3
*/

/*
3.4
*/
SELECT 	reserva.numeroreserva 															AS chave_da_reserva,
		reserva.propriedadeestado		 												AS chave_da_propriedade_1,
		reserva.propriedadecidade			 											AS chave_da_propriedade_2,
		reserva.propriedaderua		 													AS chave_da_propriedade_3,
		reserva.propriedadenumero			 											AS chave_da_propriedade_4,
		reserva.locatariocpf			 												AS chave_do_locatario,
		
		reserva.datacheckout - reserva.datacheckin										AS total_de_dias,
		
		locador.nome																	AS nome_do_proprietario,
		locatario.nome																	AS nome_do_hospede,
		
		ROUND(reserva.precototal / (reserva.datacheckout - reserva.datacheckin),2) 	    AS preco_da_diaria
		
		FROM
			public.reserva
		JOIN
			public.locatario ON
			locatario.cpf = reserva.locatariocpf
		JOIN
			public.propriedade ON 
			reserva.propriedadeestado = propriedade.estado  AND
			reserva.propriedadecidade = propriedade.cidade  AND
			reserva.propriedaderua = propriedade.rua        AND
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
