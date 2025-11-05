from pymongo import MongoClient

# ------------------ Create Connection ------------------
def create_connection():
    client = MongoClient('localhost', 27017)
    mydatabase = client['Rohit']
    print("Connected to MongoDB successfully!")
    return mydatabase


# ------------------ Insert User ------------------
def insert_User(collection):
    id = input("Enter ID: ")
    name = input("Enter Name: ")
    city = input("Enter City: ")
    age = input("Enter Age: ")

    record = {"_id": id, "name": name, "city": city, "age": age}
    collection.insert_one(record)
    print(f"User {name} added successfully.")


# ------------------ Delete User ------------------
def delete_User(collection):
    id = input("Enter the ID of the User to delete: ")
    result = collection.delete_one({"_id": id})
    if result.deleted_count > 0:
        print(f"User with ID {id} deleted successfully.")
    else:
        print(f"No User found with ID {id}.")


# ------------------ Update User ------------------
def update_User(collection):
    id = input("Enter the ID of the User to update: ")
    name = input("Enter new Name: ")
    city = input("Enter new City: ")
    age = input("Enter new Age: ")

    query = {"_id": id}
    new_values = {"$set": {"name": name, "city": city, "age": age}}
    result = collection.update_one(query, new_values)

    if result.modified_count > 0:
        print(f"User with ID {id} updated successfully.")
    else:
        print(f"No User found with ID {id}.")


# ------------------ Select All Users ------------------
def select_User(collection):
    users = collection.find()
    print("User data:")
    for user in users:
        print(f"ID: {user['_id']}, Name: {user['name']}, City: {user['city']}, Age: {user['age']}")


# ------------------ Menu ------------------
def show_menu():
    print("\nMenu:")
    print("1. Insert User")
    print("2. Delete User")
    print("3. Update User")
    print("4. Select All Users")
    print("5. Exit")


# ------------------ Main Program ------------------
database = create_connection()
collection = database["User"]

while True:
    show_menu()
    choice = input("Enter your choice (1/2/3/4/5): ")

    if choice == '1':
        insert_User(collection)
    elif choice == '2':
        delete_User(collection)
    elif choice == '3':
        update_User(collection)
    elif choice == '4':
        select_User(collection)
    elif choice == '5':
        print("Exiting program...")
        break
    else:
        print("Invalid choice, please try again.")

# call the function
if __name__ == "__main__":
    create_connection()