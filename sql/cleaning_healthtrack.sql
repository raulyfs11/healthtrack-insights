
-- Clean USERS table
CREATE TABLE clean_users AS
SELECT
    user_id,
    DATE(signup_date) AS signup_date,
    CASE
        WHEN LOWER(gender) IN ('m', 'male') THEN 'M'
        WHEN LOWER(gender) IN ('f', 'female') THEN 'F'
        WHEN LOWER(gender) IN ('o', 'other') THEN 'O'
        ELSE NULL
    END AS gender,
    UPPER(region) AS region,
    CASE
        WHEN LOWER(subscription_type) IN ('premium') THEN 'Premium'
        ELSE 'Free'
    END AS subscription_type
FROM healthtrack_users
WHERE signup_date IS NOT NULL;

-- Clean DAILY ACTIVITY table
CREATE TABLE clean_daily_activity AS
SELECT
    log_id,
    user_id,
    DATE(log_date) AS log_date,
    CASE WHEN sessions BETWEEN 0 AND 10 THEN sessions ELSE NULL END AS sessions,
    CASE WHEN duration_min BETWEEN 0 AND 180 THEN duration_min ELSE NULL END AS duration_min,
    CASE WHEN steps BETWEEN 0 AND 40000 THEN steps ELSE NULL END AS steps,
    CASE WHEN calories_burned BETWEEN 0 AND 5000 THEN calories_burned ELSE NULL END AS calories_burned
FROM healthtrack_daily_activity_logs;

-- Clean MEAL TRACKING table
CREATE TABLE clean_meal_tracking AS
SELECT
    meal_id,
    user_id,
    DATE(log_date) AS log_date,
    LOWER(meal_type) AS meal_type,
    CASE WHEN calories_intake BETWEEN 0 AND 2000 THEN calories_intake ELSE NULL END AS calories_intake,
    CASE
        WHEN is_logged_correctly IN ('1', 'true', 'yes') THEN 1
        WHEN is_logged_correctly IN ('0', 'false', 'no') THEN 0
        ELSE NULL
    END AS is_logged_correctly
FROM healthtrack_meal_tracking;

-- Clean SLEEP LOGS table
CREATE TABLE clean_sleep_logs AS
SELECT
    sleep_id,
    user_id,
    DATE(sleep_date) AS sleep_date,
    CASE WHEN sleep_score BETWEEN 30 AND 100 THEN sleep_score ELSE NULL END AS sleep_score,
    CASE WHEN hours_slept BETWEEN 0 AND 16 THEN hours_slept ELSE NULL END AS hours_slept
FROM healthtrack_sleep_logs;

-- Clean ENGAGEMENT EVENTS table
CREATE TABLE clean_engagement_events AS
SELECT
    event_id,
    user_id,
    LOWER(event_type) AS event_type,
    DATE(event_date) AS event_date
FROM healthtrack_engagement_events
WHERE event_type IS NOT NULL;
