SELECT 
    r.rewardsReceiptStatus,
    SUM(ri.quantityPurchased) AS totalItemsPurchased
FROM 
    receipts r
JOIN 
    receiptItems ri ON r._id = ri.receiptId
WHERE 
    r.rewardsReceiptStatus IN ('Accepted', 'Rejected')
GROUP BY 
    r.rewardsReceiptStatus;