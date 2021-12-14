create view [dbo].[vwMatchTeamMap] AS 
SELECT t.MatchID,t.TeamName ,TossWon,TossLost, MatchWon,MatchLost,NoResult,MatchWinStatus
FROM 
(
	SELECT 
		MatchID as MatchID,
		info_teams_01 as TeamName, 
		CASE WHEN info_toss_winner    =  info_teams_01 THEN 1 ELSE 0 END as TossWon ,
		CASE WHEN info_toss_winner    <> info_teams_01 THEN 1 ELSE 0 END as TossLost ,
		CASE WHEN info_outcome_winner =  info_teams_01 THEN 1 ELSE 0 END as MatchWon,
		CASE WHEN info_outcome_winner <> info_teams_01 THEN 1 ELSE 0 END as MatchLost,
		CASE WHEN info_outcome_winner IS NULL       THEN 1 ELSE 0 END as NoResult,
		CASE 
			WHEN info_outcome_winner IS NULL  THEN 'No Result' 
			WHEN info_outcome_winner =  info_teams_01  THEN 'Won' 
			ELSE 'Lost' 
		END as MatchWinStatus
	FROM 
		[dbo].[vwMatchInfo]
UNION ALL
	SELECT 
		MatchID,
		info_teams_02 as TeamName, 
		CASE WHEN info_toss_winner     = info_teams_02  THEN 1 ELSE 0 END as TossWon,
		CASE WHEN info_toss_winner    <> info_teams_02  THEN 1 ELSE 0 END as TossLost,
		CASE WHEN info_outcome_winner  = info_teams_02  THEN 1 ELSE 0 END as MatchWon,
		CASE WHEN info_outcome_winner <> info_teams_02  THEN 1 ELSE 0 END as MatchLost,
		CASE WHEN info_outcome_winner IS NULL        THEN 1 ELSE 0 END as NoResult,
		CASE 
			WHEN info_outcome_winner IS NULL  THEN 'No Result' 
			WHEN info_outcome_winner =  info_teams_02  THEN 'Won' 
			ELSE 'Lost' 
		END as MatchWinStatus
	FROM 
		[dbo].[vwMatchInfo]
) t

GO


