// /datum/pipeline
/datum/physical_network/power
	network_type = /datum/network/power

	Del()
		..()

	process()
		return

	OnPreBuild(var/obj/machinery/networked/power/cable/base)
		return

	OnPostBuild(var/obj/machinery/networked/power/cable/base)
		return

	OnNewMember(var/obj/machinery/networked/power/cable/item)
		if(!istype(item)) return 0

		return 1


	CanNetworkExpand(var/obj/machinery/networked/result)
		return istype(result,/obj/machinery/networked/power/cable)