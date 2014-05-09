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

  mDLLAPI.InitDriver(mSQLDriver); // mSQLDriver=SQLDrv_SQLite
  mFirstDBIdx = mDLLAPI.CreateDatabase();
  createTable();
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

        lSecondDB = mDLLAPI.SQL_LoadDatabase("myDatabase.db");

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

function String GetLevel(String UsernameInput,String PlayerType)
{
        local string username,type,level;
        local string query;
        local int result;
        

        mDLLAPI.SQL_LoadDatabase("CharDB.db");

        query = "SELECT Name,PlayerType,Level FROM Database";
        result = mDLLAPI.QueryDatabase(query);

        while (mDLLAPI.NextResult(result))
        {

                username=class'DB_DEFINES'.static.initString(30);
                type=class'DB_DEFINES'.static.initString(30);
                level=class'DB_DEFINES'.static.initString(30);

	            mDLLAPI.GetStringVal(result,"Name",username);
                mDLLAPI.GetStringVal(result,"PlayerType",type);
                mDLLAPI.GetStringVal(result,"Level",level);


	       if(UsernameInput == username && PlayerType == type )
               {
               return level;
               }
        }

}



function UpdateLevel(String UsernameInput,String PlayerType,int Level)
{
        local bool lSecondDB;
        local string query;




        lSecondDB = mDLLAPI.SQL_LoadDatabase("CharDB.db");

        query = "UPDATE Database SET Level = '"$Level$"' WHERE Name ='"$UsernameInput$"' AND PlayerType = '"$PlayerType$"' ";
        mDLLAPI.SQL_queryDatabase(query);
        `log(query);
        mDLLAPI.SQL_saveDatabase("CharDB.db");

}

function Wipe(String UsernameInput,String PlayerType)
{
        local bool lSecondDB;
        local string query;




        lSecondDB = mDLLAPI.SQL_LoadDatabase("CharDB.db");

        query = "UPDATE Database SET Level = '1',Item1 = 'XXX',Item2 = 'XXX',Item3 = 'XXX',Item4 = 'XXX',Item5 = 'XXX',Item6 = 'XXX' WHERE Name ='"$UsernameInput$"' AND PlayerType = '"$PlayerType$"' ";
        mDLLAPI.SQL_queryDatabase(query);
        mDLLAPI.SQL_saveDatabase("CharDB.db");

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

        mDLLAPI.SQL_queryDatabase("INSERT INTO Database (Name, PlayerType,Level,Item1,Item2,Item3,Item4,Item5,Item6) VALUES ('"$UsernameInput$"','"$PlayerType$"','1','XXX','XXX','XXX','XXX','XXX','XXX')");
        mDLLAPI.SQL_saveDatabase("CharDB.db");
}
function createTable()
{
//        mDLLAPI.SQL_queryDatabase("CREATE TABLE Database (ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,Name VARCHAR(30) NOT NULL,PlayerType VARCHAR(30),Level VARCHAR(30),Item1 VARCHAR(30),Item2 VARCHAR(30),Item3 VARCHAR(30),Item4 VARCHAR(30),Item5 VARCHAR(30),Item6 VARCHAR(30))");
//	mDLLAPI.SQL_queryDatabase("INSERT INTO Database (Name, PlayerType,Item1) VALUES ('player1', 'Blue','a100');");

//    	mDLLAPI.SQL_saveDatabase("CharDB.db");
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
