ALTER view [dbo].[vwMatchInfo] as
SELECT 
	s.matchid

	,s.meta_data_version
	,s.meta_created
	,s.meta_revision

		,s.info_venue 
	,s.info_city 

	,s.info_venue + ', ' + s.info_city as info1_venue_city

	,CAST(s.info_dates as DATE) as info1_dates
	,YEAR(s.info_dates ) as info1_dates_year
	,s.info_gender

	,s.info_teams_01
	,s.info_teams_02
	, CASE 
		WHEN s.info_teams_01  < s.info_teams_02  THEN	
			s.info_teams_01  + ' vs ' + s.info_teams_02
		ELSE 
			s.info_teams_02  + ' vs ' + s.info_teams_01
		END as info1_team1_vs_team2
	,s.info_toss_winner
	,s.info_toss_decision


	,s.info_outcome_winner
	,s.info_outcome_by_runs
	,s.info_outcome_by_wickets
	, CASE 
	  WHEN  s.info_outcome_by_runs     IS NOT NULL THEN 'Defending-Winner'
	  WHEN  s.info_outcome_by_wickets  IS NOT NULL THEN 'Chasing-Winner'
	  ELSE 'No-Result' 
	  END as info1_outcome_wintype

	, CASE 
	  WHEN  s.info_toss_winner  =  s.info_outcome_winner  THEN 'TossWinner-GameWinner'
	  WHEN  s.info_outcome_winner  IS NULL THEN 'No-Result'
	  ELSE 'TossWinner-GameLoser'
	  END as info1_tosswinner_gamestatus


	,s.info_player_of_match_01
	,s.info_player_of_match_02


	,s.info_match_type
	,s.info_overs

	,s.info_umpires_1 as info_umpire_01
	,s.info_umpires_2 as info_umpire_02

	,s.info_competition

 FROM 
	raw_MatchInfo  s



GO


