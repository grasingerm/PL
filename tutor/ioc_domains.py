from requests import *
import json

f = open("ioc_domains.txt")
ioc_domains = f.readlines()

for ioc_domain in ioc_domains:
	ioc_domain = ioc_domain.strip()
	print(ioc_domain)
	# execute this curl command
	req = get(ioc_domain)
	# if we want to pass headers...
	#req = get(ioc_domain, headers={"Content-Type":"application/json"})
	req_json = req.text
	req_dict = json.loads(req_json)
	# for example, print some info.
        # print(req_dict["hits"]["total"])
        # print(req_dict["hits"]["_source"]["ports"])
	#
	# w = open("searchdata.csv", "w")
        # w.write("{}, {}, {}\n".format(req_dict["hits"]["total"], req_dist["hits"]["_source"]["ports"], req_dict[""])
        # close(w)

f.close()
