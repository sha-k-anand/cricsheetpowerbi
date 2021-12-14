SELECT 
	top 100
    r.filename() as filename,
	c1.[key] as key1,
	c1.*,
	c2.*
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
	CROSS APPLY OPENJSON(r.FullLine,'$.innings') c1
	CROSS APPLY OPENJSON(c1.value,'$.overs') c2