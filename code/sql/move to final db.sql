SELECT * INTO [azuresqlcricketdata].dbo.Match        FROM [CricSheet].[dbo].[vwMatch]
SELECT * INTO [azuresqlcricketdata].dbo.MatchTeamMap FROM [CricSheet].[dbo].[vwMatchTeamMap]
SELECT * INTO [azuresqlcricketdata].dbo.Player       FROM [CricSheet].[dbo].[vwPlayer]
SELECT * INTO [azuresqlcricketdata].dbo.Score        FROM [CricSheet].[dbo].[vwScore]

CREATE CLUSTERED COLUMNSTORE INDEX cciMatch        ON [azuresqlcricketdata].dbo.Match        
CREATE CLUSTERED COLUMNSTORE INDEX cciMatchTeamMap ON [azuresqlcricketdata].dbo.MatchTeamMap 
CREATE CLUSTERED COLUMNSTORE INDEX cciPlayer       ON [azuresqlcricketdata].dbo.Player       
CREATE CLUSTERED COLUMNSTORE INDEX cciScore        ON [azuresqlcricketdata].dbo.Score        


SELECT 'Match' as TableName,COUNT(*) as RowCount1 FROM [azuresqlcricketdata].[dbo].[Match]
UNION ALL
SELECT 'MatchTeamMap' as TableName,COUNT(*) as RowCount1 FROM [azuresqlcricketdata].[dbo].[MatchTeamMap]
UNION ALL
SELECT 'Player' as TableName,COUNT(*) as RowCount1 FROM [azuresqlcricketdata].[dbo].[Player]
UNION ALL
SELECT 'Score' as TableName,COUNT(*) as RowCount1 FROM [azuresqlcricketdata].[dbo].[Score]



--In Master
CREATE LOGIN cricketlogin01 WITH password='cricket@01';
GRANT CONNECT TO cricketlogin01;
CREATE USER cricketlogin01 FROM LOGIN cricketlogin01 WITH DEFAULT_SCHEMA =  dbo;

-- In User DB
CREATE SCHEMA views01

--DROP USER cricketlogin01
CREATE USER cricketlogin01 FROM LOGIN cricketlogin01 WITH DEFAULT_SCHEMA =  views01;
-- Sample below for SQL Pool
--EXEC sp_addrolemember 'db_owner', 'username11'
--EXEC sp_addrolemember 'xlargerc', 'username11'


GRANT CREATE VIEW TO cricketlogin01;


GRANT SELECT ON SCHEMA :: dbo  TO cricketlogin01;  
GRANT ALTER ON SCHEMA::views01 TO cricketlogin01
GRANT EXECUTE ON SCHEMA::views01 TO cricketlogin01;
GRANT SELECT ON SCHEMA ::views01  TO cricketlogin01;  

CREATE VIEW views01.indiat20batsmenstriketrate as 
SELECT 
	s.[batsman],
	COUNT(DISTINCT matchid_innings) as inningscount,
	SUM([runs_batsman]) as runs_batsman,
	SUM([i1_balls_batsman]) as balls_batsman,
	CAST((SUM([runs_batsman]) / ( SUM([i1_balls_batsman]) *1.0)*100) AS NUMERIC(10,2)) as strikerate
FROM 
	[dbo].[Match] m
INNER JOIN [dbo].[Score] s ON
	m.matchid = s.matchid
WHERE 
	(m.team_01 = 'India' OR	m.team_02 = 'India' )	and  
	 m.gender='male' AND
	 m.matchyear=2019 AND
	 s.batting_team = 'India' AND
	 m.match_type = 'T20'
GROUP BY
	s.[batsman]
ORDER BY 3 DESC


--select top 100 * from [dbo].[Score] where wicket_player_out is not null

SELECT 
	batting_team,
	matchid_innings,
	player,
	COUNT(DISTINCT matchid_innings) as innings_count,
	SUM(outcount) as dismissal_count,
	COUNT(DISTINCT matchid_innings) - SUM(outcount) as notout_count,
	CASE WHEN SUM( runs_batsman ) >  100 THEN	1	ELSE 0 END as hundred_count,
	CASE WHEN SUM( runs_batsman ) <= 100 THEN	1	ELSE 0 END as fifty_count

FROM 
	(
		SELECT s1.batting_team, s1.matchid_innings,  s1.batsman as player   ,s1.runs_batsman,      CASE WHEN s1.batsman = s1.wicket_player_out     THEN 1 ELSE 0 END    as outcount  FROM [dbo].[Score]  s1
		UNION ALL
		SELECT s2.batting_team, s2.matchid_innings,s2.non_striker as player  , 0 as  runs_bastman, CASE WHEN s2.non_striker = s2.wicket_player_out THEN 1 ELSE 0 END    as outcount  FROM [dbo].[Score]  s2
	) x
GROUP BY 
	batting_team,matchid_innings,player

