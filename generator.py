import random
import codecs


events = [
    ('Bahrain Grand Prix', 5), 
    ('Saudi Arabian Grand Prix', 5), 
    ('Australian Grand Prix', 5), 
    ('Gran Premio del Made in Italy', 5),
    ('Miami Grand Prix', 5), 
    ('Gran Premio de España', 5), 
    ('Grand Prix de Monaco', 5), 
    ('Azerbaijan Grand Prix', 5),
    ('Grand Prix du Canada', 5), 
    ('British Grand Prix', 5), 
    ('Grosser Preis von Österreich', 5), 
    ('Grand Prix de France', 5),
    ('Magyar Nagydíj', 5), 
    ('Belgian Grand Prix', 5), 
    ('Dutch Grand Prix', 5), 
    ("Gran Premio d''Italia", 5),
    ('Singapore Grand Prix', 5), 
    ('Japanese Grand Prix', 5),
    ('United States Grand Prix', 5), 
    ('Gran Premio de la Ciudad de México', 5),
    ('Grande Prêmio de São Paulo', 5), 
    ('Abu Dhabi Grand Prix', 5),
]

pilots = [
    ('RSSGRG98B15Z114G', 'Mercedes'), ('HMLLWS85A07Z114F', 'Mercedes'), ('VRSMXA97P30Z126X', 'Red Bull'), ('PRZSRG90A26Z514G', 'Red Bull'), 
    ('LCLCRL97R16Z123N', 'Ferrari'), ('SNZCLS94P01Z131Y', 'Ferrari'), ('RCCDNL89L01Z700U', 'McLaren'), ('NRRLND99S13Z114I', 'McLaren'), 
    ('LNSFNN81L29Z131M', 'Alpine'), ('CNOSBN96P17Z110F', 'Alpine'), ('GSLPRR96B07Z110S', 'AlphaTauri'), ('TSNYKU00E11Z219F', 'AlphaTauri'), 
    ('STRLNC98R29Z401K', 'Aston Martin'), ('VTTSST87L03Z110A', 'Aston Martin'), ('LBNLND96C23Z241E', 'Williams'), ('LTFNHL95H29Z401V', 'Williams'), 
    ('BTTVTT89M28Z109S', 'Alfa Romeo'), ('ZHOGNY99E30Z210K', 'Alfa Romeo'), ('MGNKVN92R05Z107H', 'Haas'), ('SCHMCK99C22Z110X', 'Haas')
]

penalties = [
    'Taglio di curva', 'Eccessiva velocità in pit lane', 'Eccessiva velocità durante safety car'
]

vehicles_id = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 ]

supervisors = [ '290-42-0000', '419-54-0000', '639-94-0000', '158-16-0000' ]

teams = [ 'Ferrari', 'Red Bull', 'Mercedes', 'McLaren', 'Alpine', 'AlphaTauri', 'Aston Martin', 'Williams', 'Alfa Romeo', 'Haas' ]
names = [ 'Kendra', 'Kimberly', 'Jeanne', 'Clara', 'Clarissa', 'Beard', 'Dillon', 'Allen', 'Carlisle', 'Carlisle' ]
mechanic_roles = [ 'Capo strategista', 'Meccanico' ]
cities = [ 'Boynton', 'New York', 'San Diego', 'Atlanta' ]


def lapGenerator():
    gen_laps = []
    lap_count = 0

    for (event_name, event_laps) in events:
        for (pilot, team) in pilots:
            did_finish = random.random() <= 0.8 # 80% of the pilots complete the competition
            pilot_laps = event_laps if did_finish else random.randint(1, event_laps-1)

            for i in range(pilot_laps):
                gen_laps.append({
                    "id": lap_count, 
                    "number": i+1, 
                    "time": random.randint(60000, 120000), 
                    "event": event_name, 
                    "pilot": pilot,
                    "team": team
                })
                lap_count += 1

    return gen_laps

def mechanicGenerator():
    gen_mechanics = []
    index = 0

    for team in teams:
        for _ in range(10, 20):
            gen_mechanics.append({
                "cf": f"000-00-00{index}",
                "name": random.choice(names), "surname": random.choice(names),
                "birth": f"{random.randint(1950, 2000)}-{random.randint(1, 12)}-{random.randint(1, 28)}",
                "city": random.choice(cities),
                "role": random.choice(mechanic_roles),
                "team": team
            })
            index += 1
    
    return gen_mechanics

def pitstopGenerator(laps, mechanics):
    gen_pitstops = []
    gen_worksAt = []

    for lap in laps:
        if random.random() <= 0.3: # 30% of laps has a pit stop
            pitstop_time = random.randint(1000, 5000)
            gen_pitstops.append({
                "lap": lap["id"], 
                "time": pitstop_time,
                "total_time": pitstop_time + random.randint(10000, 30000)
            })

            team_mechanics = [mechanic for mechanic in mechanics if mechanic["team"] == lap["team"]]
            for i in random.sample(range(len(team_mechanics)), random.randint(6, min(len(team_mechanics), 12))):
                gen_worksAt.append({
                    "pitstop": lap["id"], "mechanic": team_mechanics[i]["cf"]
                })

    return gen_pitstops, gen_worksAt

def penaltyGenerator(laps):
    gen_penalties = []

    for lap in laps:
        if random.random() <= 0.1: # 10% of laps has some penalties
            for _ in range(random.randint(1, 5)):
                gen_penalties.append({
                    "lap": lap["id"], 
                    "reason": random.choice(penalties),
                    "time": random.choice([3000, 5000, 10000, 15000, 20000, 25000, 30000, 60000])
                })

    return gen_penalties

def checkGenerator():
    gen_checks = []

    for vehicle_id in vehicles_id:
        for _ in range(random.randint(0, 5)):
            gen_checks.append({
                "vehicle": vehicle_id,
                "datetime": f"{random.randint(2000, 2022)}-{random.randint(1, 12)}-{random.randint(1, 28)} {random.randint(0, 23)}:{random.randint(0, 59)}:{random.randint(0, 59)}",
                "result": random.randint(0, 1),
                "supervisor": random.choice(supervisors)
            })

    return gen_checks

generated_laps = lapGenerator()
generated_mechanics = mechanicGenerator()
generated_pitstops, generated_worksAt = pitstopGenerator(generated_laps, generated_mechanics)
genarated_penalties = penaltyGenerator(generated_laps)
generated_checks = checkGenerator()

with codecs.open("gen_insert.sql", "a", "utf-8") as f:
    f.write(f"INSERT INTO Giro (id, numero, tempo, gara, pilota) VALUES\n")
    for i in range(len(generated_laps) - 1):
        lap = generated_laps[i]
        f.write(f"({lap['id']}, {lap['number']}, {lap['time']}, '{lap['event']}', '{lap['pilot']}'), ")
    f.write(f"({generated_laps[-1]['id']}, {generated_laps[-1]['number']}, {generated_laps[-1]['time']}, '{generated_laps[-1]['event']}', '{generated_laps[-1]['pilot']}');\n")

    f.write(f"INSERT INTO Meccanico (codice_fiscale, nome, cognome, data_nascita, luogo_nascita, ruolo, scuderia) VALUES\n")
    for i in range(len(generated_mechanics) - 1):
        mechanic = generated_mechanics[i]
        f.write(f"('{mechanic['cf']}', '{mechanic['name']}', '{mechanic['surname']}', '{mechanic['birth']}', '{mechanic['city']}', '{mechanic['role']}', '{mechanic['team']}'), ")
    f.write(f"('{generated_mechanics[-1]['cf']}', '{generated_mechanics[-1]['name']}', '{generated_mechanics[-1]['surname']}', '{generated_mechanics[-1]['birth']}', '{generated_mechanics[-1]['city']}', '{generated_mechanics[-1]['role']}', '{generated_mechanics[-1]['team']}');\n")

    f.write(f"INSERT INTO Pitstop (giro, tempo_operazione, tempo_totale) VALUES\n")
    for i in range(len(generated_pitstops) - 1):
        pitstop = generated_pitstops[i]
        f.write(f"({pitstop['lap']}, {pitstop['time']}, {pitstop['total_time']}),")
    f.write(f"({generated_pitstops[-1]['lap']}, {generated_pitstops[-1]['time']}, {generated_pitstops[-1]['total_time']});\n")

    f.write(f"INSERT INTO Opera (pitstop, meccanico) VALUES\n")
    for i in range(len(generated_worksAt) - 1):
        works_at = generated_worksAt[i]
        f.write(f"({works_at['pitstop']}, '{works_at['mechanic']}'), ")
    f.write(f"({generated_worksAt[-1]['pitstop']}, '{generated_worksAt[-1]['mechanic']}');\n")

    f.write(f"INSERT INTO Penalizza (id, giro, infrazione, penalita) VALUES\n")
    for i in range(len(genarated_penalties) - 1):
        penalty = genarated_penalties[i]
        f.write(f"(NULL, {penalty['lap']}, '{penalty['reason']}', {penalty['time']}), ")
    f.write(f"(NULL, {genarated_penalties[-1]['lap']}, '{genarated_penalties[-1]['reason']}', {genarated_penalties[-1]['time']});\n")

    f.write(f"INSERT INTO Controllo (veicolo, data_ora, esito, supervisore) VALUES\n")
    for i in range(len(generated_checks) - 1):
        check = generated_checks[i]
        f.write(f"({check['vehicle']}, '{check['datetime']}', {check['result']}, '{check['supervisor']}'), ")
    f.write(f"({generated_checks[-1]['vehicle']}, '{generated_checks[-1]['datetime']}', {generated_checks[-1]['result']}, '{generated_checks[-1]['supervisor']}');\n")