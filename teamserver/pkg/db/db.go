package db

import (
	"database/sql"
	"fmt"
	"os"

	_ "github.com/mattn/go-sqlite3"
	_ "github.com/lib/pq"
)

type DB struct {
	existed bool
	db      *sql.DB
	path    string
	dbType  string
}

func DatabaseNew(dbpath string) (*DB, error) {
	var (
		db  = new(DB)
		err error
	)

	db.path = dbpath
	db.dbType = "sqlite3"

	db.existed = true
	if _, err = os.Stat(dbpath); os.IsNotExist(err) {
		db.existed = false
	}

	/* creates and or opens a db */
	db.db, err = sql.Open("sqlite3", db.path)
	if err != nil {
		return nil, err
	}

	if !db.existed {

		/* create db tables */
		err = db.init()
		if err != nil {
			return nil, err
		}

	}

	return db, nil
}

func DatabaseNewPostgres(host string, port int, user, password, dbname, sslmode string) (*DB, error) {
	var (
		db  = new(DB)
		err error
	)

	db.dbType = "postgres"
	
	// Build connection string
	connStr := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=%s",
		host, port, user, password, dbname, sslmode)
	
	db.path = connStr

	/* Try to connect */
	db.db, err = sql.Open("postgres", connStr)
	if err != nil {
		return nil, err
	}

	// Test the connection
	err = db.db.Ping()
	if err != nil {
		return nil, err
	}

	// Check if tables exist
	var tableExists bool
	err = db.db.QueryRow("SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'ts_listeners')").Scan(&tableExists)
	if err != nil {
		return nil, err
	}

	db.existed = tableExists

	if !db.existed {
		/* create db tables */
		err = db.init()
		if err != nil {
			return nil, err
		}
	}

	return db, nil
}

func (db *DB) init() error {
	var err error

	if db.dbType == "postgres" {
		// Postgres compatible schema
		_, err = db.db.Exec(`CREATE TABLE IF NOT EXISTS "TS_Listeners" ("Name" text UNIQUE, "Protocol" text, "Config" text);`)
		if err != nil {
			return err
		}

		_, err = db.db.Exec(`CREATE TABLE IF NOT EXISTS "TS_Agents" ("AgentID" int, "Active" int, "Reason" text, "AESKey" text, "AESIv" text, "Hostname" text, "Username" text, "DomainName" text, "ExternalIP" text, "InternalIP" text, "ProcessName" text, "BaseAddress" bigint, "ProcessPID" int, "ProcessTID" int, "ProcessPPID" int, "ProcessArch" text, "Elevated" text, "OSVersion" text, "OSArch" text, "SleepDelay" int, "SleepJitter" int, "KillDate" bigint, "WorkingHours" bigint, "FirstCallIn" text, "LastCallIn" text);`)
		if err != nil {
			return err
		}

		_, err = db.db.Exec(`CREATE TABLE IF NOT EXISTS "TS_Links" ("ParentAgentID" int, "LinkAgentID" int);`)
		if err != nil {
			return err
		}
	} else {
		// SQLite schema (original)
		_, err = db.db.Exec(`CREATE TABLE "TS_Listeners" ("Name" text UNIQUE, "Protocol" text, "Config" text);`)
		if err != nil {
			return err
		}

		_, err = db.db.Exec(`CREATE TABLE "TS_Agents" ("AgentID" int, "Active" int, "Reason" string, "AESKey" string, "AESIv" string, "Hostname" string, "Username" string, "DomainName" string, "ExternalIP" string, "InternalIP" string, "ProcessName" string, BaseAddress int, "ProcessPID" int, "ProcessTID" int, "ProcessPPID" int, "ProcessArch" string, "Elevated" string, "OSVersion" string, "OSArch" string, "SleepDelay" int, "SleepJitter" int, "KillDate" int, "WorkingHours" int, "FirstCallIn" string, "LastCallIn" string);`)
		if err != nil {
			return err
		}

		_, err = db.db.Exec(`CREATE TABLE "TS_Links" ("ParentAgentID" int, "LinkAgentID" int);`)
		if err != nil {
			return err
		}
	}

	return nil
}

func (db *DB) Existed() bool {
	return db.existed
}

func (db *DB) Path() string {
	return db.path
}
