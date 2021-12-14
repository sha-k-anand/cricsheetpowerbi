ALTER proc [dbo].[usp_LoadStageIntoRaw] AS
BEGIN

	IF OBJECT_ID('dbo.raw_BallInfo') IS NOT NULL
	BEGIN
		DROP TABLE dbo.raw_BallInfo
	END


	IF OBJECT_ID('dbo.raw_MatchInfo') IS NOT NULL
	BEGIN
		DROP TABLE dbo.raw_MatchInfo
	END



	SELECT 
		 s.FileName as matchid,
	JSON_VALUE(FullLine,'$.meta.data_version')			as meta_data_version,
	JSON_VALUE(FullLine,'$.meta.created')				as  meta_created,
	JSON_VALUE(FullLine,'$.meta.revision')				as meta_revision,
	JSON_VALUE(FullLine,'$.info.city')					as info_city,
	JSON_VALUE(FullLine,'$.info.dates[0]')				as info_dates,
	JSON_VALUE(FullLine,'$.info.gender')				as info_gender,
	JSON_VALUE(FullLine,'$.info.match_type')			as info_match_type,
	JSON_VALUE(FullLine,'$.info.match_type_number')     as info_match_type_number,
	JSON_VALUE(FullLine,'$.info.outcome.winner')		as info_outcome_winner,
	JSON_VALUE(FullLine,'$.info.outcome.by.runs')		as info_outcome_by_runs,
	JSON_VALUE(FullLine,'$.info.outcome.by.wickets')	as info_outcome_by_wickets,
	JSON_VALUE(FullLine,'$.info.overs')					as info_overs,
	JSON_VALUE(FullLine,'$.info.player_of_match[0]')	as info_player_of_match_01,
	JSON_VALUE(FullLine,'$.info.player_of_match[1]')	as info_player_of_match_02,
	JSON_VALUE(FullLine,'$.info.teams[0]')				as info_teams_01,
	JSON_VALUE(FullLine,'$.info.teams[1]')				as info_teams_02,
	JSON_VALUE(FullLine,'$.info.toss.decision')			as info_toss_decision,
	JSON_VALUE(FullLine,'$.info.toss.winner')			as info_toss_winner,
	JSON_VALUE(FullLine,'$.info.umpires[0]')			as info_umpires_1,
	JSON_VALUE(FullLine,'$.info.umpires[1]')			as info_umpires_2,
	JSON_VALUE(FullLine,'$.info.venue')					as info_venue ,
	JSON_VALUE(FullLine,'$.info.competition')			as info_competition


	INTO 
		dbo.raw_MatchInfo
	FROM 
		[dbo].[Staging_JSON2]  s

	
	SELECT
		s.[FileName]								as matchid,
		JSON_VALUE(FullLine,'$.info.teams[0]')		as info_teams_01,
		JSON_VALUE(FullLine,'$.info.teams[1]')		as info_teams_02,

		c2.[key]									as matchinnings,
		c3.[key]									as ballindex,
		c4.[key]									as ballnum	,

		JSON_VALUE(c2.value,'$.team')				as team,
		JSON_VALUE(c4.value,'$.batsman')			as batsman,
		JSON_VALUE(c4.value,'$.non_striker')		as non_striker,
		JSON_VALUE(c4.value,'$.bowler')				as bowler,

		JSON_VALUE(c4.value,'$.runs.total')			as runs_total,
		JSON_VALUE(c4.value,'$.runs.extras')		as runs_extras,
		JSON_VALUE(c4.value,'$.runs.batsman')		as runs_batsman,
		JSON_VALUE(c4.value,'$.extras.byes')		as extras_byes,
		JSON_VALUE(c4.value,'$.extras.wides')		as extras_wides,
		JSON_VALUE(c4.value,'$.extras.noballs')		as extras_noballs,
		JSON_VALUE(c4.value,'$.extras.legbyes')		as extras_legbyes,
		JSON_VALUE(c4.value,'$.wicket.player_out')	as wicket_player_out,
		JSON_VALUE(c4.value,'$.wicket.kind')		as wicket_kind,
		JSON_VALUE(c4.value,'$.wicket.fielders[0]') as wicket_fielders_01,
		JSON_VALUE(c4.value,'$.wicket.fielders[1]') as wicket_fielders_02
	INTO 
		dbo.raw_BallInfo
	FROM [dbo].[Staging_JSON2] s 
		CROSS APPLY OPENJSON(s.FullLine,'$.innings') c1
		CROSS APPLY OPENJSON(c1.value,'$') c2
		CROSS APPLY OPENJSON(c2.value,'$.deliveries') c3
		CROSS APPLY OPENJSON(c3.value,'$') c4
END
GO


