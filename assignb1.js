// 1. Insert couple of Documents.
db.Articles.insertMany([
{
    Title: "C",
    Content: "Procedural language",
    Author: "Yashwant karnetkar",
    Author_age: 25,
    DOP: ISODate("2016-05-13T00:00:00Z"),
    Category: "IT",
    comment: [
        {Name: "sandesh", Remarks: "very Good"},
        {Name: "Ravi", Remarks: "Nice"}
    ]
},
{
    Title: "C++",
    Content: "oop",
    Author: "Robert Lafore",
    Author_age: 35,
    DOP: ISODate("2010-07-16T00:00:00Z"),
    Category: "IT",
    comment: [
        {Name: "Rishi", Remarks: "Good"},
        {Name: "Carol", Remarks: "Ok"}
    ]
    
},
{
    Title: "Java",
    Content: "oop",
    Author: "Head First",
    Author_age: 45,
    DOP: ISODate("2000-01-16T00:00:00Z"),
    Category: "COMP",
    comment: [
        {Name: "Rohan", Remarks: "Okay"},
        {Name: "Julie", Remarks: "Not nice"}
    ]
    
},
{
    Title: "CN",
    Content: "COMPUTER NETWORKS",
    Author: "FOROUZAN",
    Author_age: 55,
    DOP: ISODate("2004-09-16T00:00:00Z"),
    Category: "IT",
    comment: [
        {Name: "Sohan", Remarks: "Best"},
        {Name: "Sam", Remarks: "Great"}
    ]
    
}
]);

// db.ar.find().pretty()

// 2. Display the fisrt document found in db;
db.Articles.findOne();

// 3. Display first document belonging to a certain Author say “Sharma” found in db.
db.Articles.findOne({Author: "FOROUZAN"});

// 4. Modify the comment made by certain person on a certain article.
db.Articles.updateOne(
	{Title: "C", "comment.Name": "Ravi"},
	{$set: {"comment.$.Remarks": "Excellent explanation"}}
);


// 5. Insert record with save method with and without objectID
  // with objectId
db.Articles.insertOne({
	_id: 1,
	Title: "DBMS",
	Content: "Database",
	Author: "Silberscahtz",
	Author_age: 40,
	DOP: ISODate("2002-06-07"),
	Category: "Comp",
	comment: [
		{Name: "Sahi", Remarks: "Great"},
		{Name: "Dabang", Remarks: "Okk"}
	]
});

  // without objectId
db.Articles.insertOne({
	Title: "TOC",
	Content: "Computation",
	Author: "Kapil-Mishra",
	Author_age: 44,
	DOP: ISODate("2005-06-07"),
	Category: "IT",
	comment: [
		{Name: "Hope", Remarks: "Good Book"},
		{Name: "Sallu", Remarks: "Nice book!"}
	]
});


// 6. Update collection with save method.
db.Articles.replaceOne(
{  _id: 1},
{
  Title: 'DBMS',
  Content: 'Structured Database',
  Author: 'Silberscahtz',
  Author_age: 50,
  DOP: ISODate("2002-06-07"),
  Category: 'Comp',
  comment: [
    { Name: 'Sahi', Remarks: 'Great book' },
    { Name: 'Dabang', Remarks: 'Okk' }
  ]
});

// 7. Add one more comment for particular title
db.Articles.update(
	{Title: "TOC"},
	{$push: {comment: {Name: "Hope", Remaks: "Bad"}}}
);

// 8. Change the Category by one name to another i.e IT = Information Technology of all docs
db.Articles.updateMany(
	{Category: "IT"},
	{$set : {Category: "Information Technology"}}
);

// 9. Change the DateOfPublishing of first article published by “Silberscahtz" found by dbms.
db.Articles.update(
	{Author: "Silberscahtz"},
	{ $set: {DOP: ISODate("2001-03-24")}}
)

// 10. Change the entire document if criteria is matched else insert the document. Show both cases
db.Articles.update(
	{_id: 1},
	{$set: {Content: "Structured Database"}},
	{upsert: true}
)

db.Articles.update(
	{Title: "AIDS"},
	{
		$set: {
			Title: 'AIDS',
			Content: "Data structure",
			Author: "Horowitz",
			Author_age: 50,
			DOP: ISODate("2010-04-23")
		}
	},
	{upsert: true}
);

// 11. Find authors whose age is greater than 40
db.Articles.find(
	{Author_age: {$gt: 40}}
);

// 12. Find authors whose age is in the range of 50 to 80
db.Articles.find(
	{Author_age: {$gt: 40, $lt: 80}}
);

// 13. Insert multiple comments for a particular title at a time.
db.Articles.update(
	{_id: 1},
	{
		$push: {
			comment: {
			$each: [

				{Name: "Kyle", Remaks: "Good book"},
				{Name: "Danny", Remaks: "Okay"}
			      ]
		        }
		}
	}
)

// 14. Display all documents whose title is either Java or category is Comp.
db.Articles.find(
{
	$or: [
		{Title: "Java"},
		{Category: "Comp"}
	]
}	
)


// 15. Delete the first article written by certain author found by dbms.
db.Articles.findOne({ Title: "DBMS" }, { Author: 1, _id: 0 });

db.Articles.deleteOne({ Author: "Silberscahtz" });

// db.Articles.remove({ Author: "Forouzan" }, { multi: false })


// 16. Delete the all articles written on Politics found by dbms
db.Articles.deleteMany({ Category: "COMP" })











