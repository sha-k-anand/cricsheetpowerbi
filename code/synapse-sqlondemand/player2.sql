SELECT 
	TOP 100
    r.filename() as FileName,
	c1.[key] as player_team,
	c2.[key] +1 as player_seq_id,
	c2.[value] as player_name
FROM 
OPENROWSET
(
    BULK 'https://cricsheetdatalake.dfs.core.windows.net/fs1/2021 08/02 JSON/all_json.zip/1118493.json',
    FORMAT='CSV',
    FIELDTERMINATOR ='0x0b', 
    FIELDQUOTE = '0x0b', 
    ROWTERMINATOR = '0x0b'
) 
WITH 
(
    FullLine VARCHAR(MAX)
) r
	CROSS APPLY OPENJSON(r.FullLine,'$.info.players') c1
	CROSS APPLY OPENJSON(c1.[value]) as c2