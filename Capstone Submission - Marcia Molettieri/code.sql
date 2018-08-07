/*** Warby Parker Capstone***/
/***Marcia Molettieri***/

--1 

SELECT * FROM survey
 LIMIT 10;


--2 

SELECT question, COUNT(DISTINCT user_id)
	AS 'Question Count'
	FROM survey
  	GROUP BY question;


--3 (Used Excel to calculate) 

1. What are you looking for?	500	
2. What's your fit?		475	95%
3. Which shapes do you like?	380	80%
4. Which colors do you like?	361	95%
5. When was your last eye exam?	270	75%


--4 

SELECT * FROM quiz
LIMIT 5; 
SELECT * FROM home_try_on
LIMIT 5;
SELECT * FROM purchase
LIMIT 5;


--5 

WITH funnel AS
(SELECT quiz.user_id,  
	CASE
  	   WHEN hto.number_of_pairs IS NOT NULL THEN 'True'
   	   ELSE 'False'
   	   END AS 'Is_home_try_on',
 	hto.number_of_pairs,
  	CASE
  	   WHEN purchase.product_id IS NOT NULL THEN 'True'
      	   ELSE 'False'
   	   END AS 'Is_purchase'
FROM quiz
LEFT JOIN home_try_on AS 'hto'
	ON quiz.user_id = hto.user_id
LEFT JOIN purchase
	ON hto.user_id = purchase.user_id)
SELECT * FROM funnel
LIMIT 10; 


--5.1 (Changing True/False to 1's and 0's for easier analysis) 

WITH funnel AS
(SELECT quiz.user_id,  
	hto.number_of_pairs IS NOT NULL AS 'Is_Home_Try_On',
  	hto.number_of_pairs,
  	purchase.product_id IS NOT NULL AS 'Is_Purchase'
FROM quiz
LEFT JOIN home_try_on AS 'hto'
	ON quiz.user_id = hto.user_id
LEFT JOIN purchase
	ON hto.user_id = purchase.user_id)
SELECT * FROM funnel
LIMIT 10;


--6.1 (Aggregate totals) 

WITH funnel AS
(SELECT quiz.user_id,  
	hto.number_of_pairs IS NOT NULL AS 'Is_Home_Try_On',
  	hto.number_of_pairs,
  	purchase.product_id IS NOT NULL AS 'Is_Purchase'
FROM quiz
LEFT JOIN home_try_on AS 'hto'
	ON quiz.user_id = hto.user_id
LEFT JOIN purchase
	ON hto.user_id = purchase.user_id)
SELECT COUNT(user_id) AS 'Quiz Count', 
	SUM(Is_Home_Try_On) AS 'Try On Count',
  	SUM(Is_purchase) AS 'Purchase Count'
FROM funnel;


--6.2 (Calculate conversion rates)

WITH funnel AS
(SELECT quiz.user_id,  
	hto.number_of_pairs IS NOT NULL AS 'Is_Home_Try_On',
  	hto.number_of_pairs,
  	purchase.product_id IS NOT NULL AS 'Is_Purchase'
FROM quiz
LEFT JOIN home_try_on AS 'hto'
	ON quiz.user_id = hto.user_id
LEFT JOIN purchase
	ON hto.user_id = purchase.user_id)
SELECT  
  1.0 * sum(is_home_try_on) / count(user_id) AS 'Quiz to Try-on', 
  1.0 * sum(is_purchase) / sum(is_home_try_on) AS 'Try-on to Purchase',
  ROUND( 1.0 * sum(is_purchase) / count(user_id), 2) AS 'Quiz to Purchase'
FROM funnel;


--6.3 (A/B Test results) 

WITH funnel AS
(SELECT quiz.user_id,  
	hto.number_of_pairs IS NOT NULL AS 'Is_Home_Try_On',
  	hto.number_of_pairs,
  	purchase.product_id IS NOT NULL AS 'Is_Purchase'
FROM quiz
LEFT JOIN home_try_on AS 'hto'
	ON quiz.user_id = hto.user_id
LEFT JOIN purchase
	ON hto.user_id = purchase.user_id)
SELECT number_of_pairs, 
	SUM(is_home_try_on) AS 'Number of Clients Tried on Pairs',
  	SUM(is_purchase) AS 'Number of Clients Purchased Pair(s)'
FROM funnel
GROUP BY 1;


--6.4 (Insights on buying behavior)

SELECT product_id, model_name, price, COUNT(*) AS 'Product ID Count'
  FROM purchase
  GROUP BY 1
  ORDER BY COUNT(*) DESC;








