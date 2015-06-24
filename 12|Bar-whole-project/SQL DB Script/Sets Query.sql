select	u.display_name, 
		u.id as user_id,
		u.facebook_id,
		c.id as set_id,
		substr(c.data,locate('title',c.data)+10,15) as chartTitle,
		co.share_status,
		c.data
from	sets c
inner join set_owner co
	on 	co.set_id = c.id
inner join vf_users u
	on 	co.user_id = u.id
where	u.display_name like 'Noah%'

union all

select	u.display_name, 
		u.id as user_id,
		u.facebook_id,
		c.id as set_id,
		substr(c.data,locate('title',c.data)+10,15) as chartTitle,
		co.share_status,
		c.data
from	sets c
inner join set_owner co
	on 	co.set_id = c.id
inner join vf_users u
	on 	co.user_id = u.id
where	u.display_name like 'Erin%'

order by 1, 6, 5