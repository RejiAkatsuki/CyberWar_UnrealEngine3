/**
 * \file SQLProject_Manager.uc
 * \brief SQLProject_Manager
 */
//=============================================================================
// Author: Sebastian Schlicht, 2010-2012 Arkanology Games
//=============================================================================
/**
 * \class SQLProject_Manager
 * \extends DB_Manager
 * \brief SQLProject_Manager
 */
class SQLProject_Manager extends DB_Manager placeable;


//=============================================================================
// Variables
//=============================================================================
var int mFirstDBIdx;
var int mSecondDBIdx;

var ESQLDriver mSQLDriver;

//=============================================================================
// Functions
//=============================================================================
/**
* Initialise the databasedriver (here SQLite) and create 2 database for further testing
* - This version does NOT automatically create an empty database on initalize the driver
*/
function PostBeginPlay()
{
  super.PostBeginPlay();

	// -- sample connection string to MySQL database --
	// mDLLAPI.InitDriver(SQLDrv_MySQL);
	// mFirstDBIdx = mDLLAPI.Connect("<IP>;<User>;<Pass>;<Database>;<Port>;");
	// ------------------------------------------------
	// With MySQL you do not need to crete new databases, you can easily have more than one connection for each database.
	// CreateDatabase is generally used for SQLite, where each database is represented by a single file.
	// QueryDatabase will work with MySQL, but pay attention on SQL syntax differences between SQLite and MySQL
	// ------------------------------------------------
	// -- see DB_DLLAPI.uc for more informations
	
	
	// ------------------------------------------------
	// Following example is done for SQLite
	// ------------------------------------------------
  mDLLAPI.InitDriver(mSQLDriver); // mSQLDriver=SQLDrv_SQLite
  mFirstDBIdx = mDLLAPI.CreateDatabase();
  createTable();
  //mDLLAPI.QueryDatabase("CREATE TABLE Carproducer (ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,Name VARCHAR(30) NOT NULL,Country VARCHAR(30))");

//  mSecondDBIdx = mDLLAPI.CreateDatabase();
 // mDLLAPI.QueryDatabase("CREATE TABLE Carproducer (ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,Name VARCHAR(30) NOT NULL,Country VARCHAR(30))");
	
  //TestDatabase();

	// ------------------------------------------------
	// Following example is done for MySQL
	// ------------------------------------------------
  // mDLLAPI.InitDriver(mSQLDriver); // mSQLDriver=SQLDrv_MySQL
  // mFirstDBIdx = mDLLAPI.Connect("localhost;;;TestDB_A;;");
  // mDLLAPI.QueryDatabase("CREATE TABLE Carproducer (ID INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,Name VARCHAR(30) NOT NULL,Country VARCHAR(30))");
  //
  // mSecondDBIdx = mDLLAPI.Connect("localhost;;;TestDB_B;;");
  // mDLLAPI.QueryDatabase("CREATE TABLE Carproducer (ID INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,Name VARCHAR(30) NOT NULL,Country VARCHAR(30))");	
}

/**
* Function to test several imported DLLBind functions of UDKProjectDLL (using SQLite driver).
* - Used to create a SQL Driver, which automatically creates a in-memory database.
* - Create a table and fill it with data.
* - Save database to disc
* - Query table content and print on console
*
* After initalising the SQLDriver it would be possible to load a presaved database from disc, its content
* would be load into the current in-memory database.
* @see bool SQL_loadDatabase(string aFilename)
*/

function bool Validate(String UsernameInput)
{
  local bool lSecondDB;
  local int id;
  local string username,password;
  local string query;
  local int result;


 `log("Searching For "@ UsernameInput);
  lSecondDB = mDLLAPI.SQL_LoadDatabase("myDatabase.db");
  //mDLLAPI.SQL_queryDatabase("INSERT INTO user (id, username,password) VALUES (1, 'Germany', 'Germany');");
 // mDLLAPI.SQL_saveDatabase("myDatabase.db");

        query = "SELECT username FROM user";
        result = mDLLAPI.QueryDatabase(query);

  while (mDLLAPI.NextResult(result))
  {
  	//myDatabase.GetIntVal(result,"ID",id);
        username=class'DB_DEFINES'.static.initString(30);
	mDLLAPI.GetStringVal(result,"username",username);

	//myDatabase.GetStringVal(result,"perso_text",perso_text);
	//`log("Nom du perso : "$username$"");
	if(UsernameInput == username)
	return true;
  }
  return false;
}

function bool checkCharacter(String UsernameInput,String PlayerType)
{
  local bool lSecondDB;
  local string username,type;
  local string query;
  local int result;



  lSecondDB = mDLLAPI.SQL_LoadDatabase("CharDB.db");

  query = "SELECT Name,PlayerType FROM Database";
  result = mDLLAPI.QueryDatabase(query);

  while (mDLLAPI.NextResult(result))
  {
  	//myDatabase.GetIntVal(result,"ID",id);
        username=class'DB_DEFINES'.static.initString(30);
        type=class'DB_DEFINES'.static.initString(30);

	mDLLAPI.GetStringVal(result,"Name",username);
        mDLLAPI.GetStringVal(result,"PlayerType",type);

	if(UsernameInput == username && PlayerType == type )
        return true;
  }



  return false;
}

function String GetItem(String UsernameInput,String PlayerType)
{
        local bool lSecondDB;
        local string username,type,item;
        local string query;
        local int result;



        lSecondDB = mDLLAPI.SQL_LoadDatabase("CharDB.db");

        query = "SELECT Name,PlayerType,Item1 FROM Database";
        result = mDLLAPI.QueryDatabase(query);

        while (mDLLAPI.NextResult(result))
        {

                username=class'DB_DEFINES'.static.initString(30);
                type=class'DB_DEFINES'.static.initString(30);
                item=class'DB_DEFINES'.static.initString(30);

	        mDLLAPI.GetStringVal(result,"Name",username);
                mDLLAPI.GetStringVal(result,"PlayerType",type);
                mDLLAPI.GetStringVal(result,"Item1",item);


	       if(UsernameInput == username && PlayerType == type )
               {
               return item;

               }
        }

}

function String GetItems(String UsernameInput,String PlayerType,int slotNumber)
{
        local bool lSecondDB;
        local string username,type,item;
        local string query;
        local int result;
        
        local string slot; 
        slot= "Item" $ slotNumber;



        lSecondDB = mDLLAPI.SQL_LoadDatabase("CharDB.db");

        query = "SELECT Name,PlayerType,"$slot$" FROM Database";
        result = mDLLAPI.QueryDatabase(query);

        while (mDLLAPI.NextResult(result))
        {

                username=class'DB_DEFINES'.static.initString(30);
                type=class'DB_DEFINES'.static.initString(30);
                item=class'DB_DEFINES'.static.initString(30);

	        mDLLAPI.GetStringVal(result,"Name",username);
                mDLLAPI.GetStringVal(result,"PlayerType",type);
                mDLLAPI.GetStringVal(result,slot,item);


	       if(UsernameInput == username && PlayerType == type )
               {
               `log("RETURNED" @ item);
               return item;

               }
        }

}



function AddItem(String UsernameInput,String PlayerType,int SlotNumber,String Item)
{
        local bool lSecondDB;
        local string query;

        local string slot;
        
        slot = "Item" $ SlotNumber;


        lSecondDB = mDLLAPI.SQL_LoadDatabase("CharDB.db");

        query = "UPDATE Database SET " $slot$ "='"$Item$"' WHERE Name ='"$UsernameInput$"' AND PlayerType = '"$PlayerType$"' ";
        mDLLAPI.SQL_queryDatabase(query);
        `log(query);
        mDLLAPI.SQL_saveDatabase("CharDB.db");

}

function createCharacter(String UsernameInput,String PlayerType)
{
        local bool lSecondDB;
        lSecondDB = mDLLAPI.SQL_LoadDatabase("CharDB.db");

        mDLLAPI.SQL_queryDatabase("INSERT INTO Database (Name, PlayerType,Item1,Item2,Item3,Item4,Item5,Item6) VALUES ('" $ UsernameInput $ "','" $ PlayerType $"','XXX','XXX','XXX','XXX','XXX','XXX');");
        mDLLAPI.SQL_saveDatabase("CharDB.db");
}
function createTable()
{
//       mDLLAPI.SQL_queryDatabase("CREATE TABLE Database (ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,Name VARCHAR(30) NOT NULL,PlayerType VARCHAR(30),Item1 VARCHAR(30),Item2 VARCHAR(30),Item3 VARCHAR(30),Item4 VARCHAR(30),Item5 VARCHAR(30),Item6 VARCHAR(30))");
//	mDLLAPI.SQL_queryDatabase("INSERT INTO Database (Name, PlayerType,Item1) VALUES ('player1', 'Blue','a100');");

//	mDLLAPI.SQL_saveDatabase("CharDB.db");
}




function TestDatabase2()
{
  local int il, lDataCount;
  local array<string> lResultData;

  local SQLProject_DataProvider_Carproducer mMainDBProvider;
  local SQLProject_DataProvider_Carproducer mSecondDBProvider;

  mMainDBProvider   = SQLProject_DataProvider_Carproducer(RegisterDataProvider(mFirstDBIdx, class'SQLProject_DataProvider_Carproducer', "MainDBDataProvider"));
  mSecondDBProvider = SQLProject_DataProvider_Carproducer(RegisterDataProvider(mSecondDBIdx, class'SQLProject_DataProvider_Carproducer', "SecondDBDataProvider"));


  mDLLAPI.SelectDatabase(mSecondDBIdx);
  mSecondDBProvider.AddCarproducer("Volkswagen", "Germany");
  mSecondDBProvider.AddCarproducer("Opel", "Germany");
  mSecondDBProvider.AddCarproducer("Ford", "Germany");
  mSecondDBProvider.AddCarproducer("BMW", "Germany");
  mSecondDBProvider.AddCarproducer("Audi", "Germany");
  mDLLAPI.SaveDatabase("test2ndDB.db"); // ONLY work with mSQLDriver=SQLDrv_SQLite


  mDLLAPI.SelectDatabase(mFirstDBIdx);
  mMainDBProvider.AddCarproducer("username", "password");
  mMainDBProvider.AddCarproducer("Opel", "Germany");
  mMainDBProvider.AddCarproducer("Ford", "Germany");
  mMainDBProvider.AddCarproducer("BMW", "Germany");
  mMainDBProvider.AddCarproducer("Audi", "Germany");
	mDLLAPI.SaveDatabase("testDB.db"); // ONLY work with mSQLDriver=SQLDrv_SQLite


  mDLLAPI.SelectDatabase(mSecondDBIdx);
  mSecondDBProvider.AddCarproducer("Toyota", "Japan");
	mDLLAPI.SaveDatabase("test2ndDB.db"); // ONLY work with mSQLDriver=SQLDrv_SQLite


  mMainDBProvider.Select();
  lDataCount = mMainDBProvider.GetDataCount();
  for (il=0; il<lDataCount; il++)
  {
    lResultData = mMainDBProvider.GetDataSet(il);
    `log("Carproducer: Id: "$lResultData[0]$", Name: "$lResultData[1]$", Country: "$lResultData[2]);
  }


  mSecondDBProvider.Select();
  lDataCount = mSecondDBProvider.GetDataCount();
  for (il=0; il<lDataCount; il++)
  {
    lResultData = mSecondDBProvider.GetDataSet(il);
    `log("Carproducer: Id: "$lResultData[0]$", Name: "$lResultData[1]$", Country: "$lResultData[2]);
  }

  mDLLAPI.SaveDatabase("testDB");
}

function bool validateUSerPass(string username, string pass)
{
    local int il, lDataCount;
  local array<string> lResultData;

  local SQLProject_DataProvider_Carproducer mMainDBProvider;
  local SQLProject_DataProvider_Carproducer mSecondDBProvider;
  
  mDLLAPI.SelectDatabase(mFirstDBIdx);
  
  mMainDBProvider.Select();
  lDataCount = mMainDBProvider.GetDataCount();
  for (il=0; il<lDataCount; il++)
  {
    lResultData = mMainDBProvider.GetDataSet(il);
    if (username == lResultData[1] && pass == lResultData[2])
        return true;
  }
  return false;
}


DefaultProperties
{
  mSQLDriver=SQLDrv_SQLite
  Name="Default__SQLProject_Manager"
}
