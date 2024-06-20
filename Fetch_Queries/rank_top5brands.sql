WITH recent_month AS (
    SELECT
        ri.brandId,
        COUNT(DISTINCT r._id) AS total_receipts
    FROM
        receipts r
    JOIN
        receipt_items ri ON r._id = ri.receiptId
    WHERE
        r.dateScanned >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
        AND r.dateScanned < DATE_TRUNC('month', CURRENT_DATE)
    GROUP BY
        ri.brandId
),
previous_month AS (
    SELECT
        ri.brandId,
        COUNT(DISTINCT r._id) AS total_receipts
    FROM
        receipts r
    JOIN
        receipt_items ri ON r._id = ri.receiptId
    WHERE
        r.dateScanned >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '2 months'
        AND r.dateScanned < DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
    GROUP BY
        ri.brandId
),
recent_ranked AS (
    SELECT
        rm.brandId,
        b.name AS brand_name,
        rm.total_receipts,
        ROW_NUMBER() OVER (ORDER BY rm.total_receipts DESC) AS rank_recent
    FROM
        recent_month rm
    JOIN
        brands b ON rm.brandId = b._id
),
previous_ranked AS (
    SELECT
        pm.brandId,
        b.name AS brand_name,
        pm.total_receipts,
        ROW_NUMBER() OVER (ORDER BY pm.total_receipts DESC) AS rank_previous
    FROM
        previous_month pm
    JOIN
        brands b ON pm.brandId = b._id
)
SELECT
    COALESCE(rr.brandId, pr.brandId) AS brand_id,
    COALESCE(rr.brand_name, pr.brand_name) AS brand_name,
    rr.total_receipts AS total_receipts_recent,
    rr.rank_recent,
    pr.total_receipts AS total_receipts_previous,
    pr.rank_previous
FROM
    recent_ranked rr
FULL OUTER JOIN
    previous_ranked pr ON rr.brandId = pr.brandId
WHERE
    rr.rank_recent <= 5 OR pr.rank_previous <= 5
ORDER BY
    COALESCE(rr.rank_recent, 999),
    COALESCE(pr.rank_previous, 999);
