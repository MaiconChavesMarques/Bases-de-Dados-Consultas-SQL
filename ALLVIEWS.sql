CREATE OR REPLACE VIEW vw_resumo_unidade AS
SELECT 
    u.nome AS nome_unidade,

    -- Subconsulta para contar professores únicos por nome, sobrenome e telefone
    (SELECT COUNT(*) 
     FROM (
         SELECT DISTINCT p.nome, p.sobrenome, p.telefone
         FROM professor p
         WHERE p.unidade = u.nome
     ) sub_prof) AS total_professores,

    -- Subconsulta para contar alunos únicos por nome, sobrenome e telefone
    (SELECT COUNT(*) 
     FROM (
         SELECT DISTINCT a.nome, a.sobrenome, a.telefone
         FROM aluno a
         WHERE a.unidade = u.nome
     ) sub_aluno) AS total_alunos,

    -- Os demais não têm esse problema
    COUNT(DISTINCT d.sigla) AS total_disciplinas,
    COUNT(DISTINCT c.codigocurso) AS total_cursos

FROM unidade u
LEFT JOIN disciplina d ON d.nomeunidade = u.nome
LEFT JOIN cursos c ON c.nomeunidade = u.nome

GROUP BY u.nome;

CREATE VIEW vw_num_prerequisitos_por_curso_2 AS
	SELECT 
		c.nome AS nome_curso,
		COUNT(prc.cursoprerequisito) + COUNT(prd.disciplinaprerequisito) AS total_prerequisitos
	FROM
		cursos c
		LEFT JOIN prerequisitos_cursos prc ON prc.cursoingresso = c.codigocurso
		LEFT JOIN prerequisitos_disciplinas prd ON prd.cursoingresso = c.codigocurso
	GROUP BY c.nome;

CREATE VIEW vw_num_mensagens_por_usuario AS
SELECT 
    u.nome,
    u.sobrenome,
    u.telefone,
    COALESCE(mp.total, 0) +
    COALESCE(ma.total, 0) +
    COALESCE(ag.total, 0) AS total_mensagens
FROM usuarios u

LEFT JOIN (
    SELECT 
        remetente_nome AS nome,
        remetente_sobrenome AS sobrenome,
        remetente_telefone AS telefone,
        COUNT(*) AS total
    FROM mensagem_professor_aluno
    GROUP BY remetente_nome, remetente_sobrenome, remetente_telefone
) mp ON mp.nome = u.nome AND mp.sobrenome = u.sobrenome AND mp.telefone = u.telefone

LEFT JOIN (
    SELECT 
        remetente_nome AS nome,
        remetente_sobrenome AS sobrenome,
        remetente_telefone AS telefone,
        COUNT(*) AS total
    FROM mensagem_aluno_professor
    GROUP BY remetente_nome, remetente_sobrenome, remetente_telefone
) ma ON ma.nome = u.nome AND ma.sobrenome = u.sobrenome AND ma.telefone = u.telefone

LEFT JOIN (
    SELECT 
        admin_nome AS nome,
        admin_sobrenome AS sobrenome,
        admin_telefone AS telefone,
        COUNT(*) AS total
    FROM avisos_gerais
    GROUP BY admin_nome, admin_sobrenome, admin_telefone
) ag ON ag.nome = u.nome AND ag.sobrenome = u.sobrenome AND ag.telefone = u.telefone;
