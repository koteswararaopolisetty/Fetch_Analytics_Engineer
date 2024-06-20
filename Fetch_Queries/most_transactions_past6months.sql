WITH recent_users AS (
    SELECT _id AS user_id
    FROM users
    WHERE createdDate >= DATE_SUB(NOW(), Interval 6 Month)
),
user_receipts AS (
    SELECT r._id AS receipt_id, r.userId, ri.brandId
    FROM receipts r
    JOIN receipt_items ri ON r._id = ri.receiptId
    WHERE r.userId IN (SELECT user_id FROM recent_users)
)
SELECT 
    b._id AS brand_id,
    b.name AS brand_name,
    COUNT(ur.receipt_id) AS transaction_count
FROM 
    user_receipts ur
JOIN 
    brands b ON ur.brandId = b._id
GROUP BY 
    b._id, b.name
ORDER BY 
    transaction_count DESC
LIMIT 1;
