/*
This first-touch query evaluates how many users visited the site and at from what source
*/

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
LIMIT 5;

SELECT DISTINCT utm_campaign
FROM page_visits;

SELECT DISTINCT utm_source
FROM page_visits;

SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;

/* distinct page_names are the:
1) Landing_page
2) shopping_cart
3) checkout
4) purchase
*/
SELECT DISTINCT page_name
FROM page_visits;

-- Next query shows how many first touches each campaign is responsible for
WITH first_touch_campaign AS (
  SELECT user_id, utm_campaign,
    MIN(timestamp) as first_touch_at
  FROM page_visits
  GROUP by user_id
)
SELECT ft.utm_campaign, COUNT(ft.user_id) as Count_of_campaigns
FROM first_touch_campaign as ft
INNER JOIN page_visits as pv
  ON ft.user_id = pv.user_id
  AND ft.first_touch_at = pv.timestamp
GROUP by ft.utm_campaign;

-- Next query shows how many last touches each campaign is responsible for
WITH last_touch_campaign AS (
  SELECT user_id, utm_campaign,
    MAX(timestamp) as last_touch_at
  FROM page_visits
  GROUP BY user_id
)
SELECT lt.utm_campaign, COUNT(lt.user_id) as Count_of_campaigns
FROM last_touch_campaign as lt
INNER JOIN page_visits as pv
  ON lt.user_id = pv.user_id
  AND lt.last_touch_at = pv.timestamp
GROUP BY lt.utm_campaign;

-- Number of distinct users who purchased a product
SELECT DISTINCT COUNT(user_id)
FROM page_visits
WHERE page_name like '4 - purchase';

--  Query shows number of last touches on the purchase page. Also shows which campaign is responsible for it.
WITH last_touch_campaign_purchase AS (
  SELECT user_id, utm_campaign, page_name,
    MAX(timestamp) as last_touch_at
  FROM page_visits
  WHERE page_name LIKE '4 - purchase'
  GROUP BY user_id
)
SELECT lt.utm_campaign, COUNT(lt.user_id) as Count_of_campaigns
FROM last_touch_campaign_purchase as lt
INNER JOIN page_visits as pv
  ON lt.user_id = pv.user_id
  AND lt.last_touch_at = pv.timestamp
GROUP by lt.utm_campaign;