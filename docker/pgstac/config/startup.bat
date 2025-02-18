@echo off

if not exist c:\data\pgdata\postgresql.conf (
 initdb -D c:\data\pgdata\ --encoding=UTF8 --username=postgres --pwfile=c:\config\postgres.init.password
 copy c:\config\postgresql.conf c:\data\pgdata\postgresql.conf /Y
 copy c:\config\pg_hba.conf c:\data\pgdata\pg_hba.conf /Y
)

postgres -D c:\data\pgdata\

