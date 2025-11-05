// Use (or create) the database and drop old data
use mydb;
db.orders.drop();

// 1. Create 'orders' collection with sample documents
db.orders.insertMany([
    {
        Order_id: "O1001",
        Cust_id: "A1",
        Cust_name: "Alice",
        Email_id: "alice@example.com",
        Phone_no: "111-111-1111",
        DtOfOrder: new Date("2023-01-01"),
        Status: "D",               // Delivered
        Item_name: "Pen",
        Qty: 10,
        Amt: 90000
    },
    {
        Order_id: "O1002",
        Cust_id: "A1",
        Cust_name: "Alice",
        /* no Email_id for this doc */,
        Phone_no: "111-111-1111",
        DtOfOrder: new Date("2023-01-02"),
        Status: "P",               // Pending
        Item_name: "Notebook",
        Qty: 5,
        Amt: 5000
    },
    {
        Order_id: "O2001",
        Cust_id: "B1",
        Cust_name: "Bob",
        Email_id: "bob@example.com",
        Phone_no: "222-222-2222",
        DtOfOrder: new Date("2023-02-01"),
        Status: "D",               // Delivered
        Item_name: "Tablet",
        Qty: 1,
        Amt: 12000
    },
    {
        Order_id: "O2002",
        Cust_id: "B1",
        Cust_name: "Bob",
        /* no Email_id */,
        Phone_no: "222-222-2222",
        DtOfOrder: new Date("2023-02-02"),
        Status: "P",               // Pending
        Item_name: "Laptop",
        Qty: 1,
        Amt: 40000
    },
    {
        Order_id: "O3001",
        Cust_id: "C1",
        Cust_name: "Charlie",
        /* no Email_id */,
        Phone_no: "333-333-3333",
        DtOfOrder: new Date("2023-03-01"),
        Status: "P",               // Pending
        Item_name: "Chair",
        Qty: 4,
        Amt: 21000
    },
    {
        Order_id: "O3002",
        Cust_id: "C1",
        Cust_name: "Charlie",
        /* no Email_id */,
        Phone_no: "333-333-3333",
        DtOfOrder: new Date("2023-03-02"),
        Status: "P",               // Pending
        Item_name: "Table",
        Qty: 3,
        Amt: 15000
    }
]);

// 2. MapReduce: Total price per customer (all orders)
// Map: emit (Cust_id, Amt).  Reduce: sum all amounts for a given customer.
var map = function() {
    emit(this.Cust_id, this.Amt);
};
var reduce = function(keyCustId, valuesAmt) {
    return Array.sum(valuesAmt);
};
// Run MapReduce on all documents
db.orders.mapReduce(
    map,
    reduce,
    {
        out: "totalPricePerCustomer"
    }
);
// Display results
db.totalPricePerCustomer.find().pretty();

/* Expected output example (sums Amt by Cust_id):
   { "_id": "A1", "value": 95000 }
   { "_id": "B1", "value": 52000 }
   { "_id": "C1", "value": 36000 }
*/

// 3. MapReduce: Total price per customer *with* Status = 'D'
// Reuse same map & reduce, adding query filter for Status = "D"
db.orders.mapReduce(
    map,
    reduce,
    {
        query: { Status: "D" },
        out: "totalPricePerCustomer_StatusD"
    }
);
db.totalPricePerCustomer_StatusD.find().pretty();
/* Expected:
   { "_id": "A1", "value": 90000 }
   { "_id": "B1", "value": 12000 }
*/

// 4. MapReduce: Total price per customer *with* Status = 'P'
db.orders.mapReduce(
    map,
    reduce,
    {
        query: { Status: "P" },
        out: "totalPricePerCustomer_StatusP"
    }
);
db.totalPricePerCustomer_StatusP.find().pretty();
/* Expected:
   { "_id": "A1", "value": 5000 }
   { "_id": "B1", "value": 40000 }
   { "_id": "C1", "value": 36000 }
*/

// 5. MapReduce: Count all keys (field names) in the orders collection
// Map: emit each field name with count 1; Reduce: sum counts for each field.
// This pattern follows standard MongoDB MapReduce usage to count field occurrences:contentReference[oaicite:3]{index=3}:contentReference[oaicite:4]{index=4}.
var map1 = function() {
    for (var key in this) {
        if (this.hasOwnProperty(key)) {
            emit(key, { CountOfKey: 1 });
        }
    }
};
var reduce1 = function(keyField, values) {
    // Sum up all the {CountOfKey:1} values for this key
    var total = 0;
    values.forEach(function(v) {
        total += v.CountOfKey;
    });
    return { CountOfKey: total };
};
// Perform MapReduce (no query filter needed)
db.orders.mapReduce(
    map1,
    reduce1,
    {
        out: "ordersKeyCounts"
    }
);
db.ordersKeyCounts.find().sort({ _id: 1 }).pretty();

/* Expected output (each unique field name and how many documents contain it):
   { "_id" : "_id",       "value" : { "CountOfKey" : 6 } }
   { "_id" : "Amt",       "value" : { "CountOfKey" : 6 } }
   { "_id" : "Cust_id",   "value" : { "CountOfKey" : 6 } }
   { "_id" : "Cust_name", "value" : { "CountOfKey" : 6 } }
   { "_id" : "DtOfOrder","value" : { "CountOfKey" : 6 } }
   { "_id" : "Email_id",  "value" : { "CountOfKey" : 2 } }
   { "_id" : "Item_name", "value" : { "CountOfKey" : 6 } }
   { "_id" : "Order_id",  "value" : { "CountOfKey" : 6 } }
   { "_id" : "Phone_no",  "value" : { "CountOfKey" : 6 } }
   { "_id" : "Qty",       "value" : { "CountOfKey" : 6 } }
   { "_id" : "Status",    "value" : { "CountOfKey" : 6 } }
*/

