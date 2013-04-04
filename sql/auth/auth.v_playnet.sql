/*
   auth.auth_customer
        Sun Sep  2 16:06:59 CDT 2007 ogs
        Returns active bans from player_notes with a qualification of
        who issued them.
*/

USE `auth` ;

DROP TABLE IF EXISTS auth.auth_customer ;
CREATE OR REPLACE
        DEFINER = CURRENT_USER
        SQL SECURITY INVOKER
        VIEW `auth`.`auth_customer`
        AS
        SELECT pc.user_id as customer_id,
        	pc.username,
        	pc.password,
        	pc.username as handle,
        	'normal' as status,
        	0 as flags,
        	null as first,
        	null as last,
        	null as email,
        	pc.modified
        FROM  `playnet`.`auth_customers` pc
;


/*
   auth.auth_subscribed
        Sun Sep  2 16:06:59 CDT 2007 ogs
        Returns active bans from player_notes with a qualification of
        who issued them.
*/

USE `auth` ;

DROP TABLE IF EXISTS auth.auth_subscribed ;
CREATE OR REPLACE
        DEFINER = CURRENT_USER
        SQL SECURITY INVOKER
        VIEW `auth`.`auth_subscribed`
        AS
        SELECT ps.user_id as customer_id,
        	ps.product_id as subscriptionID,
        	if(ps.status IN ('active','grace'), 1,0) as status
        FROM  `playnet`.`auth_customer_subscriptions` ps
;

/*
   auth.wwiiol_players
        Sun Sep  2 16:06:59 CDT 2007 ogs
        Returns active bans from player_notes with a qualification of
        who issued them.
*/

USE `auth` ;

DROP TABLE IF EXISTS auth.wwiiol_players ;
CREATE OR REPLACE
        DEFINER = CURRENT_USER
        SQL SECURITY INVOKER
        VIEW `auth`.`wwiiol_players`
        AS
        SELECT wp.player_id,
        	wp.user_id as customer_id,
        	wp.added
        FROM  `playnet`.`wwii_players` wp
;

/*
   auth.rapid_assault_players
        Sun Sep  2 16:06:59 CDT 2007 ogs
        Returns active bans from player_notes with a qualification of
        who issued them.
*/

USE `auth` ;

DROP TABLE IF EXISTS auth.rapid_assault_players ;
CREATE OR REPLACE
        DEFINER = CURRENT_USER
        SQL SECURITY INVOKER
        VIEW `auth`.`rapid_assault_players`
        AS
        SELECT rp.player_id,
        	rp.user_id as customer_id,
        	rp.added
        FROM  `playnet`.`ra_players` rp
;

