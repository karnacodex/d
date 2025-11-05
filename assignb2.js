// Drop existing collection if it exists, then create 'orders' collection
db.orders.drop();

// Insert sample documents into 'orders' collection 
// (fields: Order_id, Cust_id, Cust_name, Phone_no (array), Email_id (optional), Item_name, DtOfOrder, Qty, Amt, Status)
db.orders.insertMany([
    {
        Order_id: 1,
        Cust_id: "A1",
        Cust_name: "Aryan",
        Phone_no: [9890151243, 8806048721],
        Email_id: "aryan@gmail.com",
        Item_name: "Laptop",
        DtOfOrder: ISODate("2017-06-12T00:00:00Z"),
        Qty: 2,
        Amt: 90000,
        Status: "D"
    },
    {
        Order_id: 2,
        Cust_id: "B1",
        Cust_name: "Carol",
        Phone_no: [9860151243, 8806048723],
        Item_name: "Watch",
        DtOfOrder: ISODate("2017-02-12T00:00:00Z"),
        Qty: 3,
        Amt: 40000,
        Status: "P"
    },
    {
        Order_id: 3,
        Cust_id: "C1",
        Cust_name: "Sam",
        Phone_no: [9960151243, 8706048723],
        Item_name: "Mobile",
        DtOfOrder: ISODate("2017-02-12T00:00:00Z"),
        Qty: 2,
        Amt: 30000,
        Status: "P"
    },
    {
        Order_id: 4,
        Cust_id: "A1",
        Cust_name: "Aryan",
        Phone_no: [9890151243, 8806048721],
        Email_id: "aryan@gmail.com",
        Item_name: "Belt",
        DtOfOrder: ISODate("2017-09-12T00:00:00Z"),
        Qty: 3,
        Amt: 5000,
        Status: "P"
    },
    {
        Order_id: 5,
        Cust_id: "B1",
        Cust_name: "Carol",
        Phone_no: [9860151243, 8806048723],
        Item_name: "T-shirt",
        DtOfOrder: ISODate("2017-08-22T00:00:00Z"),
        Qty: 6,
        Amt: 12000,
        Status: "D"
    },
    {
        Order_id: 6,
        Cust_id: "C1",
        Cust_name: "Sam",
        Phone_no: [9960151243, 8706048723],
        Item_name: "Jio Router",
        DtOfOrder: ISODate("2017-02-12T00:00:00Z"),
        Qty: 3,
        Amt: 6000,
        Status: "P"
    }
]);

// 1. Create simple indexes on Cust_id and Item_name
db.orders.createIndex({ Cust_id: 1 });
db.orders.createIndex({ Item_name: 1 });

// Verify indexes created
db.orders.getIndexes();

// 2. Create a unique index on Order_id to prevent duplicates
db.orders.createIndex({ Order_id: 1 }, { unique: true });

// Attempt to insert a duplicate Order_id (should fail due to unique index constraint)
try {
    db.orders.insertOne({ Order_id: 3 });
} catch (e) {
    print("Expected duplicate key error:", e.message);
}

// 3. Create a multikey index on the Phone_no array field
db.orders.createIndex({ Phone_no: 1 });
// Find customers with exactly 2 phone numbers (array size 2)
db.orders.find({ Phone_no: { $size: 2 } }).pretty();

// 4. Create a sparse index on Email_id and compare query plans
// Explain plan before creating sparse index (should be a collection scan since no index exists)
printjson(db.orders.find({ Email_id: "aryan@gmail.com" }).explain("executionStats"));
// Create sparse index on Email_id
db.orders.createIndex({ Email_id: 1 }, { sparse: true });
// Explain plan after creating sparse index (should use index)
printjson(db.orders.find({ Email_id: "aryan@gmail.com" }).explain("executionStats"));

// 5. A) Display all indexes on orders collection
db.orders.getIndexes();
// 5. B) Display total index size in bytes
print("Total index size (bytes):", db.orders.totalIndexSize());

// 6. A) Delete the index on Cust_id
db.orders.dropIndex({ Cust_id: 1 });
// 6. B) Delete all user-created indexes (keep default _id)
db.orders.dropIndexes();

// 7. A) Find customers without an Email_id (field missing) 
db.orders.find({ Email_id: { $exists: false } });
// 7. B) Find customers who have an Email_id
db.orders.find({ Email_id: { $exists: true } });

// 8. Display all distinct customer names (no duplicates)
print("Distinct customer names:", db.orders.distinct("Cust_name"));

// 9. A) Count total number of delivered orders (Status 'D')
print("Delivered orders count:", db.orders.countDocuments({ Status: "D" }));
// 9. B) Count total number of pending orders (Status 'P')
print("Pending orders count:", db.orders.countDocuments({ Status: "P" }));

// 10. Display all orders sorted by amount (Amt) in ascending order
db.orders.find().sort({ Amt: 1 }).pretty();

// 11. Aggregate: number of orders per customer name
db.orders.aggregate([
    { $group: { _id: "$Cust_name", cnt_of_order: { $sum: 1 } } }
]);

// 12. Aggregate: total pending order amount per customer (Status 'P'), sorted descending
db.orders.aggregate([
    { $match: { Status: "P" } },
    { $group: { _id: "$Cust_id", pend_amt: { $sum: "$Amt" } } },
    { $sort: { pend_amt: -1 } }
]);

// 13. Aggregate: total delivered order amount per customer (Status 'D'), sorted by Cust_id ascending
db.orders.aggregate([
    { $match: { Status: "D" } },
    { $group: { _id: "$Cust_id", tot_amt: { $sum: "$Amt" } } },
    { $sort: { _id: 1 } }
]);

// 14. Aggregate: top three selling items by total quantity sold
db.orders.aggregate([
    { $group: { _id: "$Item_name", totqty: { $sum: "$Qty" } } },
    { $sort: { totqty: -1 } },
    { $limit: 3 }
]);

// 15. Aggregate: date with maximum number of orders
db.orders.aggregate([
    { $group: { _id: "$DtOfOrder", cnt_of_order: { $sum: 1 } } },
    { $sort: { cnt_of_order: -1 } },
    { $limit: 1 }
]);

// 16. Aggregate: customer with maximum orders
db.orders.aggregate([
    { $group: { _id: "$Cust_name", cnt_orderid: { $sum: 1 } } },
    { $sort: { cnt_orderid: -1 } },
    { $limit: 1 }
]);

