﻿USE [master]
GO

/*
THE PURPOSE OF THIS STORED PROCEDURE IS TO PASS IN A STRING OF VALUES AND A DELIMITER AND GET THE BEST BUY AND SELL PRICE FROM THE STRING
THE RESULTS SHOW THE DAY NUMBER AND IN BRACKETS THE OPEN PRICE FOR THE DAY
THE FIRST RESULT IS THE BUY PRIE AND THE SECOND RESULT(AFTER THE COMMA) SHOWS THE SELL PRICE

BELOW ARE TWO EXAMPLES:
1ST VALUE IS THE STRING OF VALUES
2ND VALUE IS THE DELIMITER

Example
EXEC dbo.[GetBestBuyAndSellPrices] '19.15,18.30,18.88,17.93,15.95,19.03,19.00'

Challenge Sample Set 1
EXEC dbo.[GetBestBuyAndSellPrices] '18.93,20.25,17.05,16.59,21.09,16.22,21.43,27.13,18.62,21.31,23.96,25.52,19.64,23.49,15.28,22.77,23.1,26.58,27.03,23.75,27.39,15.93,17.83,18.82,21.56,25.33,25,19.33,22.08,24.03'

Challenge Sample Set 2
EXEC dbo.[GetBestBuyAndSellPrices] '22.74,22.27,20.61,26.15,21.68,21.51,19.66,24.11,20.63,20.96,26.56,26.67,26.02,27.20,19.13,16.57,26.71,25.91,17.51,15.79,26.19,18.57,19.03,19.02,19.97,19.04,21.06,25.94,17.03,15.61'
*/

DROP TABLE IF EXISTS #OpenPrices

CREATE TABLE #OpenPrices
(
DayNumber INT IDENTITY(1,1)
,OpenPrice VARCHAR(10)
) 

INSERT INTO #OpenPrices(OpenPrice)
SELECT *
FROM STRING_SPLIT(@String,',')


;WITH Results AS
(SELECT DayNumber,OpenPrice
 FROM #OpenPrices 
 WHERE DayNumber >= (SELECT DayNumber
					 FROM #OpenPrices
					 WHERE OpenPrice = (SELECT MIN(OpenPrice)
									  FROM #OpenPrices)
					)
)
SELECT CONVERT(CHAR(2),rd.DayNumber) + '(' + rd.OpenPrice + ')' 
				+','+(SELECT CONVERT(CHAR(2),rd.DayNumber) + '(' + rd.OpenPrice + ')'
					  FROM Results rd
					  INNER JOIN (SELECT MAX(OpenPrice)Price 
								  FROM Results) mn ON rd.OpenPrice = mn.Price) BuySellPrices
FROM Results rd
INNER JOIN (SELECT MIN(OpenPrice)Price FROM Results) mn ON rd.OpenPrice = mn.Price

END
