WITH recent_receipts AS (
    SELECT r._id AS receipt_id, ri.brandId, DATE_TRUNC('month', r.dateScanned) AS scan_month
    FROM receipts r
    JOIN receipt_items ri ON r._id = ri.receiptId
    WHERE r.dateScanned >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
)
SELECT b._id AS brand_id, b.name AS brand_name, COUNT(DISTINCT rr.receipt_id) AS total_receipts
FROM recent_receipts rr
JOIN brands b ON rr.brandId = b._id
GROUP BY b._id, b.name
ORDER BY total_receipts DESC
LIMIT 5;