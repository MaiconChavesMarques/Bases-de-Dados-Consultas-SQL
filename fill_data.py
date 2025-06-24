import sys
import random
from faker import Faker
from datetime import datetime, timedelta

# Initialize Faker with a specific locale for more realistic data
fake = Faker('pt_BR')

# --- Configuration for Data Volume ---
NUM_USERS = 100000
NUM_UNITS = 20
NUM_DEPARTMENTS = 50
NUM_COURSES = 100
NUM_DISCIPLINES = 500
NUM_MATRICULAS = 500000
NUM_NOTES_DISC = 100000
NUM_NOTES_PROF = 50000
NUM_MESSAGES_PA = 75000
NUM_MESSAGES_AP = 75000
NUM_AVISOS_GERAIS = 20000

# Open a file explicitly with UTF-8 encoding
# All print statements will now write to this file
try:
    output_file_name = "large_inserts.sql"
    output = open(output_file_name, "w", encoding="utf-8")
except IOError as e:
    sys.stderr.write(f"Error opening output file: {e}\n")
    sys.exit(1)


# Helper to generate SQL INSERT statements
def generate_insert(table_name, columns, values):
    cols_str = ", ".join(columns)
    escaped_values = []
    for v in values:
        if v is None: # Handle None values explicitly as SQL NULL
            escaped_values.append('NULL')
        elif isinstance(v, str) and not (v.startswith("TO_DATE") or v.startswith("TIMESTAMP")):
            # Correctly escape single quotes for SQL string literals by doubling them
            escaped_content = v.replace("'", "''")
            escaped_values.append(f"'{escaped_content}'")
        else:
            escaped_values.append(str(v))
    vals_str = ", ".join(escaped_values)
    return f"INSERT INTO {table_name} ({cols_str}) VALUES ({vals_str});"

# --- Data Generation Logic ---

sys.stderr.write("Generating SQL inserts... This may take a while.\n")

# Unidade
units_data = []
for i in range(NUM_UNITS):
    unit_name = f"Unidade {i+1} - {fake.city()}"
    units_data.append((unit_name, fake.city(), fake.state_abbr(), fake.country(), fake.word(), fake.word()))
    output.write(generate_insert("Unidade", ["Nome", "Cidade", "Estado", "Pais", "Predio", "Bloco"], units_data[-1]) + "\n")
output.write("\n")

# Departamento (needs ProfessorChefe, which will be generated later)
departments_data = []
for i in range(NUM_DEPARTMENTS):
    dept_code = f"DEPT-{i:04d}"
    departments_data.append((fake.word().capitalize() + " Departamento", dept_code, None, None, None)) # ProfessorChefe will be filled later
    output.write(generate_insert("Departamento", ["Nome", "CodigoDepartamento", "ProfessorChefe_Nome", "ProfessorChefe_Sobrenome", "ProfessorChefe_Telefone"], departments_data[-1]) + "\n")
output.write("\n")

# Usuarios
users_data = []
for i in range(NUM_USERS):
    name = fake.first_name()
    surname = fake.last_name()
    phone = fake.numerify('##########') # 10 digits for phone
    dob = fake.date_of_birth(minimum_age=18, maximum_age=70).strftime('%Y-%m-%d')
    country = 'Brasil'
    state = fake.state_abbr()
    city = fake.city()
    bairro = fake.bairro()
    street = fake.street_name()
    number = fake.building_number()
    gender = random.choice(['M', 'F', 'O'])
    email = fake.email()
    password = fake.password(length=10)
    user_type = random.choices(['Aluno', 'Professor', 'Funcionario'], weights=[0.6, 0.3, 0.1], k=1)[0]
    users_data.append((name, surname, phone, dob, country, state, city, bairro, street, number, gender, email, password, user_type))
    output.write(generate_insert("Usuarios", ["Nome", "Sobrenome", "Telefone", "DataNascimento", "Pais", "Estado", "Cidade", "Bairro", "Rua", "Numero", "Sexo", "Email", "Senha", "Tipo"], users_data[-1]) + "\n")
output.write("\n")

# Separate users by type
aluno_users = [u for u in users_data if u[13] == 'Aluno']
professor_users = [u for u in users_data if u[13] == 'Professor']
funcionario_users = [u for u in users_data if u[13] == 'Funcionario']

# Professor
professors_data = []
for user in professor_users:
    name, surname, phone = user[0], user[1], user[2]
    specialization = fake.catch_phrase()
    titulacao = random.choice(['Mestre', 'Doutor', 'Livre-Docente'])
    unit = random.choice(units_data)[0] # Random unit name
    department_code = random.choice(departments_data)[1] # Random department code
    professors_data.append((name, surname, phone, specialization, titulacao, unit, department_code))
    output.write(generate_insert("Professor", ["Nome", "Sobrenome", "Telefone", "Especializacao", "Titulacao", "Unidade", "CodigoDepartamento"], professors_data[-1]) + "\n")
output.write("\n")

# Update Departamento with ProfessorChefe
for i, dept in enumerate(departments_data):
    if professors_data: # Ensure there are professors to assign
        chief_prof = random.choice(professors_data)
        departments_data[i] = (dept[0], dept[1], chief_prof[0], chief_prof[1], chief_prof[2])
        output.write(f"UPDATE Departamento SET ProfessorChefe_Nome = '{chief_prof[0]}', ProfessorChefe_Sobrenome = '{chief_prof[1]}', ProfessorChefe_Telefone = '{chief_prof[2]}' WHERE CodigoDepartamento = '{dept[1]}';\n")
output.write("\n")

# Cursos
courses_data = []
for i in range(NUM_COURSES):
    course_code = f"CURSO-{i:03d}"
    course_name = fake.catch_phrase() + " Curso"
    dept_code = random.choice(departments_data)[1]
    level = random.choice(['Fundamental', 'Médio', 'Técnico', 'Graduação', 'Pós-graduação'])
    carga_horaria = random.randint(1000, 4000)
    vagas = random.randint(30, 100)
    sala = f"Sala-{random.randint(1, 200)}"
    unit_name = random.choice(units_data)[0]
    courses_data.append((course_name, course_code, dept_code, level, carga_horaria, vagas, sala, unit_name))
    output.write(generate_insert("Cursos", ["Nome", "CodigoCurso", "CodigoDepartamento", "Nivel", "CargaHorariaTotal", "Vagas", "SalaAula", "NomeUnidade"], courses_data[-1]) + "\n")
output.write("\n")

# PreRequisitos_Cursos
prereq_courses_set = set() # Use a set to store unique (CursoIngresso, CursoPreRequisito) pairs
for _ in range(NUM_COURSES * 2): # Roughly 2 prerequisites per course on average
    if len(courses_data) < 2: continue
    course_ingresso = random.choice(courses_data)[1]
    course_prereq = random.choice(courses_data)[1]
    if course_ingresso != course_prereq:
        prereq_courses_set.add((course_ingresso, course_prereq))

for prereq_pair in prereq_courses_set:
    output.write(generate_insert("PreRequisitos_Cursos", ["CursoIngresso", "CursoPreRequisito"], prereq_pair) + "\n")
output.write("\n")

# Disciplina
disciplines_data = []
for i in range(NUM_DISCIPLINES):
    sigla = f"DISC-{i:04d}"
    aulas_semanais = random.randint(2, 6)
    capacidade_turma = random.randint(20, 50)
    if professors_data:
        prof = random.choice(professors_data)
        prof_name, prof_surname, prof_phone = prof[0], prof[1], prof[2]
    else: # Fallback if no professors generated (shouldn't happen with current NUM_USERS)
        prof_name, prof_surname, prof_phone = 'Default', 'Professor', '0000000000'
    unit_name = random.choice(units_data)[0]
    disciplines_data.append((sigla, aulas_semanais, capacidade_turma, prof_name, prof_surname, prof_phone, unit_name))
    output.write(generate_insert("Disciplina", ["Sigla", "QuantidadeAulasSemanais", "CapacidadeTurma", "ProfessorNome", "ProfessorSobrenome", "ProfessorTelefone", "NomeUnidade"], disciplines_data[-1]) + "\n")
output.write("\n")

# PreRequisitos_Disciplinas
prereq_disciplines_set = set() # Use a set to store unique (CursoIngresso, DisciplinaPreRequisito) pairs
for _ in range(NUM_DISCIPLINES * 1): # Roughly 1 prerequisite per discipline
    if not courses_data or not disciplines_data: continue
    course_ingresso = random.choice(courses_data)[1]
    discipline_prereq = random.choice(disciplines_data)[0]
    prereq_disciplines_set.add((course_ingresso, discipline_prereq))

for prereq_pair in prereq_disciplines_set:
    output.write(generate_insert("PreRequisitos_Disciplinas", ["CursoIngresso", "DisciplinaPreRequisito"], prereq_pair) + "\n")
output.write("\n")

# Material_Didatico, Regras, Necessidade_Infraestrutura
for sigla, _, _, _, _, _, _ in disciplines_data:
    output.write(generate_insert("Material_Didatico", ["Sigla", "MaterialDidatico"], (sigla, fake.text(max_nb_chars=50))) + "\n")
    output.write(generate_insert("Regras", ["Sigla", "Regra"], (sigla, fake.sentence())) + "\n")
    output.write(generate_insert("Necessidade_Infraestrutura", ["Sigla", "Infraestrutura"], (sigla, fake.word())) + "\n")
output.write("\n")

# Aluno
aluno_data = []
for user in aluno_users:
    name, surname, phone = user[0], user[1], user[2]
    unit = random.choice(units_data)[0]
    aluno_data.append((name, surname, phone, unit))
    output.write(generate_insert("Aluno", ["Nome", "Sobrenome", "Telefone", "Unidade"], aluno_data[-1]) + "\n")
output.write("\n")

# Funcionario_Administrativo
funcionario_admin_data = []
for user in funcionario_users:
    name, surname, phone = user[0], user[1], user[2]
    unit = random.choice(units_data)[0]
    funcionario_admin_data.append((name, surname, phone, unit))
    output.write(generate_insert("Funcionario_Administrativo", ["Nome", "Sobrenome", "Telefone", "Unidade"], funcionario_admin_data[-1]) + "\n")
output.write("\n")

# Matricula
start_date = datetime(2023, 1, 1)
end_date = datetime(2024, 12, 31)
status_options = ['Ativa', 'Trancada', 'Cancelada', 'Concluída']

# Armazenar chaves primárias já usadas para evitar duplicatas
matricula_entries = set()

for i in range(NUM_MATRICULAS):
    if not aluno_data or not disciplines_data:
        continue

    student = random.choice(aluno_data)
    discipline = random.choice(disciplines_data)
    enrollment_date = fake.date_between(start_date=start_date, end_date=end_date)
    
    pk = (enrollment_date.strftime('%Y-%m-%d'), student[0], student[1], student[2], discipline[0])
    if pk in matricula_entries:
        continue  # pular duplicatas

    matricula_entries.add(pk)

    periodo_letivo = f"{enrollment_date.year}-{1 if enrollment_date.month <= 6 else 2}"
    status = random.choice(status_options)
    notes = round(random.uniform(0.0, 10.0), 2) if status == 'Concluída' else 0.0
    desconto_bolsa = round(random.uniform(0.0, 2000.0), 2)
    taxa = round(random.uniform(500.0, 3000.0), 2)
    data_limite = (enrollment_date + timedelta(days=random.randint(90, 180))).strftime('%Y-%m-%d')

    output.write(generate_insert("Matricula", [
        "Data", "Aluno_Nome", "Aluno_Sobrenome", "Aluno_Telefone",
        "Sigla", "Status", "Notas", "DescontoBolsa", "Taxa", "DataLimite"
    ], [
        f"TO_DATE('{pk[0]}', 'YYYY-MM-DD')", pk[1], pk[2], pk[3],
        pk[4], status, notes, desconto_bolsa, taxa, f"TO_DATE('{data_limite}', 'YYYY-MM-DD')"
    ]) + "\n")

output.write("\n")

# --- CORREÇÃO AQUI para Periodo_Letivo ---
# Gerar períodos letivos únicos com uma data representativa para evitar violação da PK
unique_periodos_letivos_map = {} # Usar um dicionário para mapear periodo_letivo -> data_representativa

# Percorre o intervalo de anos/semestres desejado
for year in range(start_date.year, end_date.year + 1):
    for semester in [1, 2]:
        periodo_letivo_str = f"{year}-{semester}"
        
        # Define uma data representativa para o início do semestre
        if semester == 1:
            representative_date = datetime(year, 1, 1)
        else: # semester == 2
            representative_date = datetime(year, 7, 1)
        
        # Armazena apenas se ainda não foi adicionado (garante unicidade)
        if periodo_letivo_str not in unique_periodos_letivos_map:
            unique_periodos_letivos_map[periodo_letivo_str] = representative_date.strftime('%Y-%m-%d')

# Agora, escreva as instruções INSERT para os períodos letivos únicos
for periodo, data_str in unique_periodos_letivos_map.items():
    output.write(generate_insert("Periodo_Letivo", ["Data", "PeriodoLetivo"], [f"TO_DATE('{data_str}', 'YYYY-MM-DD')", periodo]) + "\n")
output.write("\n")

# NotaDisciplina
nota_disciplina_entries = set() # Usar um set para garantir unicidade da chave composta

for i in range(NUM_NOTES_DISC):
    if not aluno_data or not disciplines_data or not unique_periodos_letivos_map:
        continue # Garante que os dados necessários existam

    student = random.choice(aluno_data)
    discipline = random.choice(disciplines_data)
    periodo_letivo = random.choice(list(unique_periodos_letivos_map.keys())) # Escolhe um período que já existe

    # Crie a tupla da chave primária
    pk_tuple = (student[0], student[1], student[2], discipline[0], periodo_letivo)

    # Se a combinação já existe no set, pule esta iteração para evitar duplicatas
    if pk_tuple in nota_disciplina_entries:
        continue

    nota_disciplina_entries.add(pk_tuple) # Adiciona a combinação única ao set

    texto = fake.sentence()
    nota_didatica = random.randint(0, 20)
    nota_material = random.randint(0, 20)
    nota_conteudo = random.randint(0, 20)
    nota_infra = random.randint(0, 20)

    output.write(generate_insert("NotaDisciplina", [
        "Aluno_Nome", "Aluno_Sobrenome", "Aluno_Telefone", "Sigla",
        "PeriodoLetivo", "Texto", "NotaDidatica", "NotaMaterial", "NotaConteudo", "NotaInfraestrutura"
    ], [
        student[0], student[1], student[2], discipline[0],
        periodo_letivo, texto, nota_didatica, nota_material, nota_conteudo, nota_infra
    ]) + "\n")
output.write("\n")

# NotaProfessor
# Implemente a mesma lógica de set para NotaProfessor para evitar duplicatas, se necessário.
nota_professor_entries = set() # Adicionado para evitar duplicatas em NotaProfessor

for i in range(NUM_NOTES_PROF):
    if not aluno_data or not professors_data or not unique_periodos_letivos_map:
        continue
    student = random.choice(aluno_data)
    professor = random.choice(professors_data)
    
    periodo_letivo = random.choice(list(unique_periodos_letivos_map.keys()))

    # Crie a tupla da chave primária para NotaProfessor
    pk_tuple_prof = (student[0], student[1], student[2], professor[0], professor[1], professor[2], periodo_letivo)

    if pk_tuple_prof in nota_professor_entries:
        continue

    nota_professor_entries.add(pk_tuple_prof)
    
    texto = fake.sentence()
    nota_didatica_prof = random.randint(0, 20)

    output.write(generate_insert("NotaProfessor", [
        "Aluno_Nome", "Aluno_Sobrenome", "Aluno_Telefone",
        "Professor_Nome", "Professor_Sobrenome", "Professor_Telefone",
        "PeriodoLetivo", "Texto", "NotaDidaticaProfessor"
    ], [
        student[0], student[1], student[2],
        professor[0], professor[1], professor[2],
        periodo_letivo, texto, nota_didatica_prof
    ]) + "\n")
output.write("\n")

# Mensagem_Professor_Aluno
for i in range(NUM_MESSAGES_PA):
    if not professors_data or not aluno_data: continue
    
    if not professors_data or not aluno_data: continue
    sender = random.choice(professors_data)
    receiver = random.choice(aluno_data)
    
    timestamp = fake.date_time_between(start_date=start_date, end_date=end_date)
    text = fake.paragraph(nb_sentences=1)

    output.write(generate_insert("Mensagem_Professor_Aluno", [
        "Remetente_Nome", "Remetente_Sobrenome", "Remetente_Telefone",
        "Destinatario_Nome", "Destinatario_Sobrenome", "Destinatario_Telefone",
        "Timestamp", "Texto"
    ], [
        sender[0], sender[1], sender[2],
        receiver[0], receiver[1], receiver[2],
        f"TIMESTAMP '{timestamp.strftime('%Y-%m-%d %H:%M:%S')}'", text
    ]) + "\n")
output.write("\n")

# Mensagem_Aluno_Professor
for i in range(NUM_MESSAGES_AP):
    if not aluno_data or not professors_data: continue
    
    if not aluno_data or not professors_data: continue
    sender = random.choice(aluno_data)
    receiver = random.choice(professors_data)
    
    timestamp = fake.date_time_between(start_date=start_date, end_date=end_date)
    text = fake.paragraph(nb_sentences=1)

    output.write(generate_insert("Mensagem_Aluno_Professor", [
        "Remetente_Nome", "Remetente_Sobrenome", "Remetente_Telefone",
        "Destinatario_Nome", "Destinatario_Sobrenome", "Destinatario_Telefone",
        "Timestamp", "Texto"
    ], [
        sender[0], sender[1], sender[2],
        receiver[0], receiver[1], receiver[2],
        f"TIMESTAMP '{timestamp.strftime('%Y-%m-%d %H:%M:%S')}'", text
    ]) + "\n")
output.write("\n")

# Avisos_Gerais
for i in range(NUM_AVISOS_GERAIS):
    if not funcionario_admin_data or not users_data: continue
    
    if not funcionario_admin_data or not users_data: continue
    admin = random.choice(funcionario_admin_data)
    user = random.choice(users_data)
    
    timestamp = fake.date_time_between(start_date=start_date, end_date=end_date)
    text = fake.paragraph(nb_sentences=1)

    output.write(generate_insert("Avisos_Gerais", [
        "Admin_Nome", "Admin_Sobrenome", "Admin_Telefone",
        "Usuario_Nome", "Usuario_Sobrenome", "Usuario_Telefone",
        "Timestamp", "Texto"
    ], [
        admin[0], admin[1], admin[2],
        user[0], user[1], user[2],
        f"TIMESTAMP '{timestamp.strftime('%Y-%m-%d %H:%M:%S')}'", text
    ]) + "\n")
output.write("\n")

output.close()
sys.stderr.write(f"Data generation complete. SQL inserts saved to {output_file_name}\n")