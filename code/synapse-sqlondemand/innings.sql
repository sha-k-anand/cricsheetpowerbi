SELECT 
    r.filename() as filename,
	c3.value,
	c1.[key] as key1,
	JSON_VALUE(c1.value,'$.team') as team_name,
	JSON_VALUE(c2.value,'$.over') as over1,
	JSON_VALUE(c3.value,'$.batter') as batter,
	JSON_VALUE(c3.value,'$.bowler') as bowler,
	c3.[key] +1 as ballnumber,
	JSON_VALUE(c3.value,'$.non_striker') as non_striker,
	JSON_VALUE(c3.value,'$.runs.batter') as runs_batter,
	JSON_VALUE(c3.value,'$.runs.extras') as runs_extras,
	JSON_VALUE(c3.value,'$.extras.wides') as runs_extras_wide,
	JSON_VALUE(c3.value,'$.extras.legbyes') as runs_extras_legbyes,
	JSON_VALUE(c3.value,'$.runs.total') as runs_total,
	JSON_VALUE(JSON_QUERY(c3.value,'$.wickets[0]'),'$.player_out') as wickets_playerout,
	JSON_VALUE(JSON_QUERY(c3.value,'$.wickets[0].fielders[0]'),'$.name') as wickets_fielders_01,
	JSON_VALUE(JSON_QUERY(c3.value,'$.wickets[0].fielders[1]'),'$.name') as wickets_fielders_02,
	JSON_VALUE(JSON_QUERY(c3.value,'$.wickets[0]'),'$.kind') as wickets_kind
FROM 
OPENROWSET
(
    BULK 'https://cricsheetdatalake.dfs.core.windows.net/fs1/2021 08/02 JSON/all_json.zip/*.json',
    FORMAT='CSV',
    FIELDTERMINATOR ='0x0b', 
    FIELDQUOTE = '0x0b', 
    ROWTERMINATOR = '0x0b'
) 
WITH 
(
    FullLine VARCHAR(MAX)
) r
	CROSS APPLY OPENJSON(r.FullLine,'$.innings') c1
	CROSS APPLY OPENJSON(c1.value,'$.overs') c2
	CROSS APPLY OPENJSON(c2.value,'$.deliveries') c3
	