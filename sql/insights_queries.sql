
-- 1. Average sleep score per subscription type
SELECT subscription_type, ROUND(AVG(s.sleep_score), 1) AS avg_sleep
FROM clean_users u
JOIN clean_sleep_logs s USING(user_id)
GROUP BY subscription_type;

-- 2. Top 5 regions by average session duration
SELECT region, ROUND(AVG(a.duration_min), 2) AS avg_duration
FROM clean_users u
JOIN clean_daily_activity a USING(user_id)
GROUP BY region
ORDER BY avg_duration DESC
LIMIT 5;

-- 3. Engagement intensity: average events per user by subscription
SELECT subscription_type, ROUND(COUNT(e.event_id) / COUNT(DISTINCT u.user_id), 2) AS avg_events
FROM clean_users u
JOIN clean_engagement_events e USING(user_id)
GROUP BY subscription_type;

-- 4. Percentage of users logging meals regularly
SELECT
  ROUND(SUM(CASE WHEN meals_logged > 5 THEN 1 ELSE 0 END) / COUNT(DISTINCT user_id) * 100, 1) AS pct_frequent_meal_loggers
FROM (
  SELECT user_id, COUNT(*) AS meals_logged
  FROM clean_meal_tracking
  GROUP BY user_id
) AS sub;

-- 5. Sleep consistency: stddev of sleep hours per user
SELECT user_id, ROUND(STDDEV(hours_slept), 2) AS sleep_consistency
FROM clean_sleep_logs
GROUP BY user_id
ORDER BY sleep_consistency ASC
LIMIT 10;

-- 6. Users with both high sleep and high activity
SELECT u.user_id, AVG(s.sleep_score) AS avg_sleep, AVG(a.duration_min) AS avg_activity
FROM clean_users u
JOIN clean_sleep_logs s USING(user_id)
JOIN clean_daily_activity a USING(user_id)
GROUP BY u.user_id
HAVING avg_sleep > 85 AND avg_activity > 20
ORDER BY avg_activity DESC;

-- 7. Churn signal: users with low events and no meals
SELECT u.user_id
FROM clean_users u
LEFT JOIN clean_engagement_events e USING(user_id)
LEFT JOIN clean_meal_tracking m USING(user_id)
GROUP BY u.user_id
HAVING COUNT(e.event_id) = 0 AND COUNT(m.meal_id) = 0;

-- 8. Average sleep by region
SELECT region, ROUND(AVG(s.sleep_score), 1) AS avg_sleep
FROM clean_users u
JOIN clean_sleep_logs s USING(user_id)
GROUP BY region;

-- 9. Most popular engagement events
SELECT event_type, COUNT(*) AS total
FROM clean_engagement_events
GROUP BY event_type
ORDER BY total DESC;

-- 10. Average hours slept by users who log meals frequently
SELECT ROUND(AVG(s.hours_slept), 2) AS avg_hours
FROM clean_sleep_logs s
JOIN (
  SELECT user_id
  FROM clean_meal_tracking
  GROUP BY user_id
  HAVING COUNT(*) > 5
) m ON s.user_id = m.user_id;
