select	u.display_name, 
		u.id as user_id,
		u.facebook_id,
		c.id as chord_id,
		substr(c.data,locate('title',c.data)+10,15) as chartTitle,
		co.share_status,
		c.data
from	chords c
inner join chord_owner co
	on 	co.chord_id = c.id
inner join vf_users u
	on 	co.user_id = u.id
where	u.display_name like 'Noah%'

union all

select	u.display_name, 
		u.id as user_id,
		u.facebook_id,
		c.id as chord_id,
		substr(c.data,locate('title',c.data)+10,15) as chartTitle,
		co.share_status,
		c.data
from	chords c
inner join chord_owner co
	on 	co.chord_id = c.id
inner join vf_users u
	on 	co.user_id = u.id
where	u.display_name like 'Erin%'

order by 1, 6, 5