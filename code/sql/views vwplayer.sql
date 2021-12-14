ALTER view [dbo].[vwPlayer] AS
SELECT x.Player 
FROM 
(
	SELECT batsman as Player FROM [dbo].[vwBallInfo]
	UNION 
	SELECT bowler  as Player FROM [dbo].[vwBallInfo]
	UNION 
	SELECT non_striker  as Player FROM [dbo].[vwBallInfo]
	UNION 
	SELECT wicket_fielders_01  as Player FROM [dbo].[vwBallInfo]
	UNION 
	SELECT wicket_fielders_02  as Player FROM [dbo].[vwBallInfo]

) x
