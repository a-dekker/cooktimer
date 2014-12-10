.import QtQuick.LocalStorage 2.0 as LS

function getUnixTime() {
    return (new Date()).getTime()
}

function connectDB() {
    // connect to the local database
    return LS.LocalStorage.openDatabaseSync("cooktimer", "1.0",
                                            "Cooktimer Database", 100000)
}

function initializeDB() {
    // initialize DB connection
    var db = connectDB()

    // run initialization queries
    db.transaction(function (tx) {
        // create table
        tx.executeSql(
                    "CREATE TABLE IF NOT EXISTS dishes(Dish TEXT, Duration TEXT)")
        tx.executeSql("CREATE UNIQUE INDEX IF NOT EXISTS uid ON dishes(Dish)")
    })
    return db
}

/***************************************/
/*** SQL functions for DISH handling ***/
/***************************************/

// select dishes and push them into the dishlist
function readDishes() {
    var db = connectDB()

    db.transaction(function (tx) {
        var result = tx.executeSql("SELECT * FROM dishes ORDER BY Dish COLLATE NOCASE;")
        for (var i = 0; i < result.rows.length; i++) {
            dishPage.appendDish(result.rows.item(i).Dish,
                                result.rows.item(i).Duration)
        }
    })
}

function readDishesEdit() {
    var db = connectDB()

    db.transaction(function (tx) {
        var result = tx.executeSql("SELECT * FROM dishes ORDER BY Dish COLLATE NOCASE;")
        for (var i = 0; i < result.rows.length; i++) {
            dishesDialog.appendDish(result.rows.item(i).Dish,
                                    result.rows.item(i).Duration)
        }
    })
}

function RemoveAllDishes() {
    var db = connectDB()

    db.transaction(function (tx) {
        var result = tx.executeSql("delete FROM dishes;")
        tx.executeSql("COMMIT;")
    })
}

// save dish
function writeDish(dish, duration) {
    var db = connectDB()
    var result

    try {
        db.transaction(function (tx) {
            tx.executeSql("INSERT INTO dishes (Dish, Duration) VALUES (?, ?);",
                          [dish, duration])
            tx.executeSql("COMMIT;")
            result = tx.executeSql("SELECT Dish FROM dishes WHERE Dish=?;",
                                   [dish])
        })

        return result.rows.item(0).Dish
    } catch (sqlErr) {
        return "ERROR"
    }
}
