using HTTP, JSON,Graphs GraphPlot

#JSON.json(Dict("action"=>"block_count"))
#Gets a JSON as input

ac = "xrb_3m5aqg68j31o4izfm6a445zywc8ww667tpb5drjzyhrf3js9ug9mxp8opo7r"
function rpc(_body::String;server::String="http://yapraiwallet.space:5523/api")	
	r = HTTP.request("POST", server, [], _body)
	return JSON.parse(String(r.body))
end





#Gets a dictionary as input
"Calls a Nano roc command. You only have to specify the body as a Dictionary
example: rpc(Dict(\"action\" : \"block_count\"))"
function rpc(_body::Dict{String,String},_server::String="http://yapraiwallet.space:5523/api")	
	return rpc(JSON.json(_body);server=_server)
end


"Returns the history of wallet

count defines the amount of transactions to return (default is 1)
"
function history(wallet::String,count::Union{Int,String}=1;_server::String="http://yapraiwallet.space:5523/api")	
	body = Dict("action"=>"account_history","account"=>wallet,"count"=>string(count))
	return rpc(JSON.json(body);server=_server)["history"]
end

"Gets the last 'count' send operations of 'wallet'"
function history_send(wallet::String,count::Int=1;server::String="http://yapraiwallet.space:5523/api")
	h = history(wallet,count;_server=server)
	filter!(h) do x
		x["type"] == "send"
	end
	return h
end

"Gets the last 'count' receive operations of 'wallet'"
function history_receive(wallet::String,count::Union{Int,String}=1;server::String="http://yapraiwallet.space:5523/api")
	h = history(wallet,count;_server=server)
	filter!(h) do x
		x["type"] == "receive"
	end
	return h
end


function make_graph(account::String,count::Int=1)
	h = history_send(account,count)
	g = simple_graph(0)
	
	amount_vertices = 1
	vertices_map = Dict{String,Int}() #TODO use an enumeration instead of a dictionary
	vertices_map[account] = amount_vertices

	genesis_vertice = ExVertex(1,account)
	add_vertex!(g,genesis_vertice)

	
	for t in h		
		current_target = t["account"]

		if !haskey(vertices_map,current_target)
			amount_vertices +=1
			v = ExVertex(amount_vertices,current_target)
			add_vertex!(g,v)	
			vertices_map[current_target] = amount_vertices
			add_edge!(g,1,vertices_map[current_target])
		end
	end	
	plot(g)
end

