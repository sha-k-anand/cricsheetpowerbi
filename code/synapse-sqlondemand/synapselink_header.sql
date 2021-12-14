SELECT 
	TOP 100 
	_rid,_ts,id,
	JSON_VALUE(meta,'$.data_version')					as meta_data_version,
    JSON_VALUE(meta,'$.created')						as meta_created,         
    JSON_VALUE(meta,'$.revision')						as meta_revision,    

	JSON_VALUE(info ,'$.balls_per_over')			    as info_balls_per_over,
	JSON_VALUE(info ,'$.city')							as info_city,
	JSON_VALUE(info ,'$.dates[0]')					    as info_dates_01,
	JSON_VALUE(info ,'$.event.name')					as info_event_name,     
	JSON_VALUE(info ,'$.event.match_number')			as info_event_match_number,

	JSON_VALUE(info ,'$.gender')						as info_gender,
	JSON_VALUE(info ,'$.match_type')					as info_match_type,
	JSON_VALUE(info ,'$.officials.match_referees[0]')   as info_officials_match_referees,
	JSON_VALUE(info ,'$.officials.umpires[0]')			as info_officials_umpires_01,
	JSON_VALUE(info ,'$.officials.umpires[1]')			as info_officials_umpires_02,

	
	JSON_VALUE(info ,'$.outcome.winner')				as info_outcome_winner,         
	JSON_VALUE(info ,'$.outcome.by.wickets')            as info_outcome_by_wickets,
	JSON_VALUE(info ,'$.outcome.by.runs')				as info_outcome_by_runs,

	JSON_VALUE(info ,'$.overs')							as info_overs,
	JSON_VALUE(info ,'$.player_of_match')				as info_player_of_match,

	JSON_VALUE(info ,'$.season')						as info_season,
	JSON_VALUE(info ,'$.team_type')						as info_team_type,
	JSON_VALUE(info ,'$.teams[0]')						as info_teams_01,
	JSON_VALUE(info ,'$.teams[1]')						as info_teams_02   ,

	JSON_VALUE(info ,'$.toss.decision')					as info_toss_decision,        
	JSON_VALUE(info ,'$.toss.winner')					as info_toss_winner,
	JSON_VALUE(info ,'$.venue')							as info_venue
FROM 
	OPENROWSET(​PROVIDER = 'CosmosDB',CONNECTION = 'Account=zzshacosmos01;Database=db0001',OBJECT = 'cont002',SERVER_CREDENTIAL = 'zzshacosmos01zz') AS [cont002]
WHERE 
	id in 
	(
	'9ebb127c-91fc-4f36-9e66-fb0d5c4f69e5',
	'03eb6000-154c-4bb4-802f-18df0134edf1',
	'6f284c8e-a296-4516-a07c-888cd9a2aa10',
	'9e9430fb-7cb9-47b8-9c8d-5365574d02a2',
	'ff76778c-d954-425e-bbb1-f9dbd8c65548',
	'36a10a8e-fb4a-4fb8-969f-c5e1acfbb514'
	)