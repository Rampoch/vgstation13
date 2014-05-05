/obj/machinery/networked/power
	name = "Powered Machine"
	desc = "A machine that can directly tie into the power network."

	// Replaces node1/2/3 vars
	var/list/obj/machinery/networked/power/nodes=list()

	var/datum/network/power/network
	var/datum/physical_network/power/physnet

	network_type = /datum/network/power
	physnet_type = /datum/physical_network/power

/obj/machinery/networked/power/check_network()
	network=..()

/obj/machinery/networked/power/check_physnet()
	physnet=..()

/obj/machinery/networked/power/findAllConnections(var/connect_dirs)
	var/node_id=0
	for(var/direction in alldirs)
		if(connect_dirs & direction)
			node_id++
			var/obj/machinery/networked/power/found
			var/node_type=getNodeType(node_id)
			switch(node_type)
				if(NETTYPE_POWER)
					found = findConnectingWire(direction)
			if(!found) continue
			if(!nodes[node_id])
				nodes[node_id] = found

/obj/machinery/networked/power/proc/rebuild_connections()
	findAllConnections()
	update_icon()
	build_network()
	for(var/obj/machinery/networked/power/node in nodes)
		if(!node) continue
		node.initialize()
		node.build_network()

/obj/machinery/networked/power/proc/getAvailable()
	check_network()
	return network.avail