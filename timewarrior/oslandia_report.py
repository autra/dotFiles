#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import json
from datetime import datetime
from collections import defaultdict

def parse(input_stream):
    DATEFORMAT = "%Y%m%dT%H%M%SZ"
    header = True
    config = {}
    body = ""
    for line in input_stream:
        if header:
            if line == "\n":
                header = False
                continue
            try:
                key, value = line.strip().split(": ", 1)
                config[key] = value
            except ValueError:
                continue
        else:
            body += line

    totals = defaultdict(lambda: 0)
    tracked = json.loads(body)
    days = defaultdict(lambda: 0)
    for session in tracked:
        start = datetime.strptime(session["start"], DATEFORMAT)
        if "end" in session:
            end = datetime.strptime(session["end"], DATEFORMAT)
        else:
            end = datetime.utcnow()
        duration = int((end - start).total_seconds())
        days[start.date()]+=duration
        if not session.get("tags"):
            totals["untagged"] += duration
        else:
            if len(session["tags"]) > 1:
                error_and_exit("This report can only report one tag per session.")
            totals[session["tags"][0]] += duration

    
    return days, totals

if __name__ == "__main__":
    days, totals = parse(sys.stdin)
    nb_half_day = sum([2 if seconds > 60*60*5 else 1 for seconds in days.values()])
    print("Nb half days       : {}".format(nb_half_day))

    total_hours = sum([seconds/3600. for seconds in totals.values()])
    print("Total hours        : {:.2f}".format(total_hours))

    hours_per_half_day = total_hours / nb_half_day
    print("Hours per half day : {:.2f}".format(hours_per_half_day))

    tasks = [(seconds/3600., task) for task, seconds in totals.items()]

    nb_hd = 0
    attributions = defaultdict(lambda: 0)

    while nb_hd < nb_half_day:
        tasks = sorted(tasks)
        if not len(tasks):
            break
        
        task = tasks.pop()
        task_nb_hd = max(int(task[0] / hours_per_half_day),1)
        attributions[task[1]] += task_nb_hd
        nb_hd += task_nb_hd
        # keep the rest if any
        rest = task[0] - task_nb_hd * hours_per_half_day
        if ( rest > 0 ):
            tasks.append((rest, task[1]))

    print("Attributions       :")
    for task_name, nb_hd in attributions.items():
        print(" - {} : {}".format(task_name, nb_hd))

    
    
