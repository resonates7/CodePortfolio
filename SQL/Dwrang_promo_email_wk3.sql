/*
Data Wrangling and AB Testing class
- Find the last item each user viewed, but didn't purchase
    so the marketing team can send them an email to see if they want to buy it

*/

SELECT 
  sub_rank.user_id
  , users.email_address
  , sub_rank.item_id      AS most_recent_viewItemId
  , items.name            AS item_name
  , items.category        AS item_category
  , orders.item_id 
FROM(
    SELECT
      user_id
      , item_id
      , event_time
      , ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_time DESC) AS view_number
    FROM dsv1069.view_item_events
    --ORDER BY user_id
    ) sub_rank
INNER JOIN dsv1069.users ON sub_rank.user_id = users.id
INNER JOIN dsv1069.items ON sub_rank.item_id = items.id
LEFT OUTER JOIN dsv1069.orders ON orders.item_id = sub_rank.item_id
    AND sub_rank.user_id = orders.user_id

WHERE view_number = 1
  AND orders.item_id IS NULL

