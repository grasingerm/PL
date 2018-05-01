from subprocess import call

f = open("ioc_domains.txt")
ioc_domains = f.readlines()

for ioc_domain in ioc_domains:
	ioc_domain = ioc_domain.strip()
	print(ioc_domain)
	# execute this curl command
	curl_list = ["curl","-XGET","'blah_blah.com:xxxx/_search?pretty'","-H","'Content-Type: application/json'","-d","{\"query\":\"bool\"affected_file\":\"" + ioc_domain + "\"}}}"]
	call(curl_list)
	call(["sleep","1"])
	print(curl_list)

f.close()
