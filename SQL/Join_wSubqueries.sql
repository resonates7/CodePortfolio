
/*
Sharing SQL code for a job can be problematic b/c everyone has different databases. But, here's an
exercise I completed and I've included a screenshot of the database schema in the powerpoint
file named PostgreSQL Practice Schema
*/


select mems.firstname ||' ' ||mems.surname as member, facs.name as facility,
	(CASE
		when mems.memid = 0 then facs.guestcost
		Else facs.membercost
	 END
	 ) * bks.slots AS cost
	 --,facs.guestcost, facs.membercost, date(bks.starttime)as dt,bks.starttime, bks.slots
from cd.bookings AS bks
	left join cd.members as mems on bks.memid=mems.memid
	left join cd.facilities as facs on bks.facid=facs.facid
where date(bks.starttime)='2012-09-14' AND
	(CASE
		when mems.memid = 0 then facs.guestcost
		Else facs.membercost
	 END
	 ) * bks.slots > 30
	 
Order by cost desc, facility