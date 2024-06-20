SELECT 
    rewardsReceiptStatus,
    AVG(totalSpent) AS average_spend
FROM 
    receipts
WHERE 
    rewardsReceiptStatus IN ('Accepted', 'Rejected')
GROUP BY 
    rewardsReceiptStatus;
