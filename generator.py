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
    'RSSGRG98B15Z114G', 'HMLLWS85A07Z114F', 'VRSMXA97P30Z126X', 'PRZSRG90A26Z514G', 'LCLCRL97R16Z123N', 
    'SNZCLS94P01Z131Y', 'RCCDNL89L01Z700U', 'NRRLND99S13Z114I', 'LNSFNN81L29Z131M', 'CNOSBN96P17Z110F', 
    'GSLPRR96B07Z110S', 'TSNYKU00E11Z219F', 'STRLNC98R29Z401K', 'VTTSST87L03Z110A', 'LBNLND96C23Z241E', 
    'LTFNHL95H29Z401V', 'BTTVTT89M28Z109S', 'ZHOGNY99E30Z210K', 'MGNKVN92R05Z107H', 'SCHMCK99C22Z110X'
]

penalties = [
    'Taglio di curva', 'Eccessiva velocità in pit lane', 'Eccessiva velocità durante safety car'
]


def lapGenerator():
    gen_laps = []
    lap_count = 0

    for (event_name, event_laps) in events:
        for pilot in pilots:
            did_finish = random.random() <= 0.8 # 80% of the pilots complete the competition
            pilot_laps = event_laps if did_finish else random.randint(0, event_laps-1)

            for i in range(pilot_laps):
                gen_laps.append({
                    "id": lap_count, 
                    "number": i+1, 
                    "time": random.randint(60000, 120000), 
                    "event": event_name, 
                    "pilot": pilot
                })
                lap_count += 1

    return gen_laps

def pitstopGenerator(laps):
    gen_pitstops = []

    for lap in laps:
        if random.random() <= 0.3: # 30% of laps has a pit stop
            pitstop_time = random.randint(1000, 5000)
            gen_pitstops.append({
                "lap": lap["id"], 
                "time": pitstop_time,
                "total_time": pitstop_time + random.randint(10000, 30000)
            })

    return gen_pitstops

def penaltyGenerator(laps):
    gen_penalties = []

    for lap in laps:
        if random.random() <= 0.1: # 10% of laps has some penalties
            for _ in range(random.randint(1, 5)):
                gen_penalties.append({
                    "lap": lap["id"], 
                    "reason": random.choice(penalties),
                    "time": random.randint(1000, 20000)
                })

    return gen_penalties


generated_laps = lapGenerator()
generated_pitstops = pitstopGenerator(generated_laps)
genarated_penalties = penaltyGenerator(generated_laps)

with codecs.open("giri.sql", "a", "utf-8") as f:
    f.write(f"INSERT INTO Giro (id, numero, tempo, gara, pilota) VALUES\n")
    for i in range(len(generated_laps) - 1):
        lap = generated_laps[i]
        f.write(f"  ({lap['id']}, {lap['number']}, {lap['time']}, '{lap['event']}', '{lap['pilot']}'),\n")
    f.write(f"  ({generated_laps[-1]['id']}, {generated_laps[-1]['number']}, {generated_laps[-1]['time']}, '{generated_laps[-1]['event']}', '{generated_laps[-1]['pilot']}');")

with codecs.open("pitstop.sql", "a", "utf-8") as f:
    f.write(f"INSERT INTO Pitstop (giro, tempo_operazione, tempo_totale) VALUES\n")
    for i in range(len(generated_pitstops) - 1):
        pitstop = generated_pitstops[i]
        f.write(f"  ({pitstop['lap']}, {pitstop['time']}, {pitstop['total_time']}),\n")
    f.write(f"  ({generated_pitstops[-1]['lap']}, {generated_pitstops[-1]['time']}, {generated_pitstops[-1]['total_time']});")

with codecs.open("penalizza.sql", "a", "utf-8") as f:
    f.write(f"INSERT INTO Penalizza (id, giro, infrazione, penalita) VALUES\n")
    for i in range(len(genarated_penalties) - 1):
        penalty = genarated_penalties[i]
        f.write(f"  (NULL, {penalty['lap']}, '{penalty['reason']}', {penalty['time']}),\n")
    f.write(f"  (NULL, {genarated_penalties[-1]['lap']}, '{genarated_penalties[-1]['reason']}', {genarated_penalties[-1]['time']});")