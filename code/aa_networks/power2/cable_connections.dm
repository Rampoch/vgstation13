/////////////////////////////////////
// POWER2 CABLE
/////////////////////////////////////

// These handle the logical connections.

/datum/cablepart
	var/dir1 = 0
	var/dir2 = 0

/obj/machinery/networked/power/cable
	name = "power cable"
	desc = "A flexible superconducting cable for heavy-duty power transfer"

	icon = 'icons/obj/power.dmi'
	icon_state = "powernet_cable"

	var/list/parts = list() // Our components

	//level = 1
	anchored = 1
	//invisibility = 101

/obj/machinery/networked/power/cable/update_icon()
	overlays=0
	for(var/i=0;i<4;i++)
		var/c_dir = 1 << i
		//testing("c_dir = [c_dir]")
		if(initialize_directions & c_dir)
			//testing("Making overlay")
			overlays += image('icons/obj/power.dmi',icon_state = "pnet_dirs", dir=num2dir(c_dir))
			//testing("Made overlay")

/obj/machinery/networked/power/cable/rebuild_connections()
	var/connections=0
	var/obj/structure/cable/C
	for(var/key in parts)
		C = parts[key]
		connections |= C.d1 | C.d2
	initialize_directions = connections
	update_icon()
	..()

/obj/machinery/networked/power/cable/proc/addLink(var/obj/structure/cable/C)
	var/key = "[C.d1]-[C.d2]"
	if(key in parts)
		return 0
	parts[key]=C
	rebuild_connections()
	return 1

/obj/machinery/networked/power/cable/proc/rmLink(var/obj/structure/cable/C,var/autoclean=1)
	var/key = "[C.d1]-[C.d2]"
	if(key in parts)
		parts.Remove(key)
		rebuild_connections()
	if(autoclean && parts.len==0)
		qdel(src)

/obj/machinery/networked/power/cable/attack_tk(var/mob/user)
	return

/obj/machinery/networked/power/Destroy()
	for(var/obj/machinery/networked/power/node in nodes)
		if(node)
			node.disconnect(src)
	..()

// shock the user with probability prb
/obj/machinery/networked/power/cable/proc/shock(mob/user, prb, var/siemens_coeff = 1.0)
	if(!prob(prb))
		return 0
	if (electrocute_mob(user, powernet, src, siemens_coeff))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		return 1
	else
		return 0

/obj/machinery/networked/power/cable/build_network()
	check_physnet()
	return physnet.return_network()

/obj/machinery/networked/power/cable/network_expand(var/datum/physical_network/power/new_network, var/obj/machinery/networked/power/cable/reference)
	check_physnet()
	return physnet.network_expand(new_network, reference)

/obj/machinery/networked/power/cable/return_network(var/obj/machinery/networked/power/cable/reference)
	check_physnet()
	return physnet.return_network(reference)

/obj/machinery/networked/power/cable/physical_expansion()
	return nodes

// These are logical objects and should never be destroyed without destroying the physical objects.
/obj/machinery/networked/power/cable/ex_act(severity)
	return