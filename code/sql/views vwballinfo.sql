ALTER view [dbo].[vwBallInfo] AS
SELECT 
	s.matchid,
	s.matchinnings,

	CASE 
	WHEN s.matchinnings in ('1st innings','2nd innings','3rd innings','4th innings') THEN s.matchinnings
	ELSE 'Super Over'
	END as matchinnings_seq,

	CASE 
	WHEN s.matchinnings in ('1st innings','2nd innings') THEN '1st innings'
	WHEN s.matchinnings in ('3rd innings','4th innings') THEN '2nd innings'
	ELSE 'Super Over'
	END as innings,

	CASE 
	WHEN s.matchinnings in ('1st innings','2nd innings','3rd innings','4th innings') THEN '0'
	ELSE '1'
	END as superover,



	s.ballindex,
	s.ballnum as overball,
	s.team as batting_team,
	SUBSTRING(s.ballnum, 1,CHARINDEX('.',s.ballnum)-1) + 1 as overnum,
	SUBSTRING(s.ballnum, CHARINDEX('.',s.ballnum)+1,1)  as ballnum,
	CASE WHEN s.team = s.info_teams_01 THEN s.info_teams_02 ELSE s.info_teams_01 END as bowling_team,
	--s.info_teams_01,
	--s.info_teams_02,
	s.batsman,
	s.non_striker,
	s.bowler,
	s.bowler + ' vs ' + s.batsman as i1_bowler_vs_batsman,

	CAST(s.runs_total     AS SMALLINT) as runs_total,
	CAST(s.runs_extras    AS SMALLINT) as runs_extras,
	CAST(s.runs_batsman   AS SMALLINT) as runs_batsman,
	CASE WHEN s.runs_batsman = '4' THEN	 1 ELSE NULL END as fours_count,
	CASE WHEN s.runs_batsman = '6' THEN	 1 ELSE NULL END as sizes_Count,

	
	CASE
		WHEN CAST(s.extras_wides   AS SMALLINT) IS NOT NULL OR CAST(s.extras_noballs AS SMALLINT) IS NOT NULL THEN 
			0 
		ELSE 
			1 
		END as i1_balls_batsman,
	CAST(s.extras_byes      AS SMALLINT) as extras_byes,
	CAST(s.extras_wides     AS SMALLINT) as extras_wides,
	CAST(s.extras_noballs   AS SMALLINT) as extras_noballs,
	CAST(s.extras_legbyes   AS SMALLINT) as extras_legbyes,
	s.wicket_player_out as wicket_player_out,
	CASE WHEN s.wicket_player_out IS NOT NULL THEN 1 ELSE NULL END as wicket_count,
	s.wicket_kind as wicket_kind,
	s.wicket_fielders_01 as wicket_fielders_01,
	s.wicket_fielders_02 as wicket_fielders_02,
	CASE 
		WHEN  s.wicket_kind = 'caught' THEN 
			
	   		  s.wicket_fielders_01
		ELSE
			NULL
		END as i1_wicket_fielders_caught
FROM 
	[dbo].[raw_BallInfo] s
GO


