#using HTTP, JSON

#JSON.json(Dict("action"=>"block_count"))
#Gets a JSON as input
function rpc(_body::String,server="http://yapraiwallet.space:5523/api")	
	r = HTTP.request("POST", server, [], _body)
	return JSON.parse(String(r.body))
end

#Gets a dictionary as input
function rpc(_body::Dict{String,String},server="http://yapraiwallet.space:5523/api")	
	return rpc(JSON.json(_body))
end

