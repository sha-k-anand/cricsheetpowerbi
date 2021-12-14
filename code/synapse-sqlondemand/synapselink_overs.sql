SELECT 
	_rid,_ts,id,
	--c3.value,
	c1.[key] as key1,
	JSON_VALUE(c1.value,'$.team')											as team_name,
	JSON_VALUE(c2.value,'$.over')											as over1,
	JSON_VALUE(c3.value,'$.batter')											as batter,
	JSON_VALUE(c3.value,'$.bowler')											as bowler,
	c3.[key] +1																as ballnumber,
	JSON_VALUE(c3.value,'$.non_striker')									as non_striker,
	JSON_VALUE(c3.value,'$.runs.batter')									as runs_batter,
	JSON_VALUE(c3.value,'$.runs.extras')									as runs_extras,
	JSON_VALUE(c3.value,'$.extras.wides')									as runs_extras_wide,
	JSON_VALUE(c3.value,'$.extras.legbyes')									as runs_extras_legbyes,
	JSON_VALUE(c3.value,'$.runs.total')										as runs_total,
	JSON_VALUE(JSON_QUERY(c3.value,'$.wickets[0]'),'$.player_out')			as wickets_playerout,
	JSON_VALUE(JSON_QUERY(c3.value,'$.wickets[0].fielders[0]'),'$.name')	as wickets_fielders_01,
	JSON_VALUE(JSON_QUERY(c3.value,'$.wickets[0].fielders[1]'),'$.name')	as wickets_fielders_02,
	JSON_VALUE(JSON_QUERY(c3.value,'$.wickets[0]'),'$.kind')				as wickets_kind
FROM 
	OPENROWSET(​PROVIDER = 'CosmosDB',CONNECTION = 'Account=zzshacosmos01;Database=db0001',OBJECT = 'cont002',SERVER_CREDENTIAL = 'zzshacosmos01zz') AS [cont002]
	CROSS APPLY OPENJSON(innings,'$') c1
	CROSS APPLY OPENJSON(c1.value,'$.overs') c2
	CROSS APPLY OPENJSON(c2.value,'$.deliveries') c3

	WHERE 
	[cont002].id in 
	(
	'9ebb127c-91fc-4f36-9e66-fb0d5c4f69e5',
	'03eb6000-154c-4bb4-802f-18df0134edf1',
	'6f284c8e-a296-4516-a07c-888cd9a2aa10',
	'9e9430fb-7cb9-47b8-9c8d-5365574d02a2',
	'ff76778c-d954-425e-bbb1-f9dbd8c65548',
	'36a10a8e-fb4a-4fb8-969f-c5e1acfbb514'
	)


