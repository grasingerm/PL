import json

# My goal here is to calculate the number of hits that each player has for
# the season (there have only been three games)

with open("mlbstats.json", "r") as mlb_datafile:

    mlb_data = json.load(mlb_datafile)
    total_hits = {}

    for game in mlb_data:
        print("\nCounting hits from the game against ", game["opponent"])
        for batter in game["batters"]:
            print("\t", batter["name"], " batted this game. Counting their hits...")

            # Check to see if this batter already appear in a game this season.
            # If they do, add to their total. If they don't start a total.
            if batter["name"] in total_hits.keys():
                total_hits[batter["name"]] += batter["hits"]
            else:
                total_hits[batter["name"]] = batter["hits"]
    
print("\nHere are the totals for the season thus far:")
for (name, hits) in total_hits.items():
    print(name, " has ", hits, " hits.")
