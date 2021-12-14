SELECT 
top 100
    r.filename() as FileName,
    r.filepath() as FilePath,
    --FullLine,

    JSON_VALUE(FullLine ,'$.meta.data_version')					as meta_data_version,
    JSON_VALUE(FullLine ,'$.meta.created')						as meta_created,         
    JSON_VALUE(FullLine ,'$.meta.revision')						as meta_revision,     

	JSON_VALUE(FullLine ,'$.info.balls_per_over')			    as info_balls_per_over,
	JSON_VALUE(FullLine ,'$.info.city')							as info_city,
	JSON_VALUE(FullLine ,'$.info.dates[0]')					    as info_dates_01,
	JSON_VALUE(FullLine ,'$.info.event.name')					as info_event_name,     
	JSON_VALUE(FullLine ,'$.info.event.match_number')			as info_event_match_number,

	JSON_VALUE(FullLine ,'$.info.gender')						as info_gender,
	JSON_VALUE(FullLine ,'$.info.match_type')					as info_match_type,
	JSON_VALUE(FullLine ,'$.info.officials.match_referees[0]')  as info_officials_match_referees         ,
	JSON_VALUE(FullLine ,'$.info.officials.umpires[0]')			as info_officials_umpires_01         ,
	JSON_VALUE(FullLine ,'$.info.officials.umpires[1]')			as info_officials_umpires_02         ,

	
	JSON_VALUE(FullLine ,'$.info.outcome.winner')				as info_outcome_winner,         
	JSON_VALUE(FullLine ,'$.info.outcome.by.wickets')           as info_outcome_by_wickets,
	JSON_VALUE(FullLine ,'$.info.outcome.by.runs')				as info_outcome_by_runs,

	JSON_VALUE(FullLine ,'$.info.overs')						as info_overs,
	JSON_VALUE(FullLine ,'$.info.player_of_match')				as info_player_of_match,

	JSON_VALUE(FullLine ,'$.info.season')						as info_season,
	JSON_VALUE(FullLine ,'$.info.team_type')					as info_team_type,
	JSON_VALUE(FullLine ,'$.info.teams[0]')						as info_teams_01,
	JSON_VALUE(FullLine ,'$.info.teams[1]')						as info_teams_02   ,

	JSON_VALUE(FullLine ,'$.info.toss.decision')				as info_toss_decision,        
	JSON_VALUE(FullLine ,'$.info.toss.winner')					as info_toss_winner,
	JSON_VALUE(FullLine ,'$.info.venue')						as info_venue

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