----------------inf17_alpha2_00_create-db.sql
/* Datenbank master verwenden*/
USE [master]
GO

/* Datenbank erstellen [DAlpha]*/
CREATE DATABASE [DAlpha];
GO

/* Datenbank DAlpha verwenden*/
USE [DAlpha];
GO



------------------------inf17_alpha2_01_create-tables.sql
/* Datenbank master verwenden*/
USE [master]
GO
/* Datenbank DAlpha verwenden*/
USE [DAlpha];
GO

----Tabellen Fallen lasen(l�schen)
----Wenn die tabellen vorhanden sind dann l�schen sie zuerst die Tabellen
--DROP TABLE T_TitelPlaylist;
--DROP TABLE T_Bewertung;
--DROP TABLE T_Titel;
--DROP TABLE T_Playlist;
--DROP TABLE T_Benutzer;
--DROP TABLE T_Genre;
--DROP TABLE T_Album;
--DROP TABLE T_Interpret;
--DROP TABLE T_Land;


/* Tabelle T_Land erstellen*/
CREATE TABLE T_Land(
	LandID_PK INTEGER IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Land nvarchar(80) NOT NULL
	);

/* Tabelle T_Interpret erstellen*/
CREATE TABLE T_Interpret(
	InterpretID_PK INTEGER IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Interpret nvarchar(100) NOT NULL, 
	);

/* Tabelle T_Album erstellen*/
CREATE TABLE T_Album(
	AlbumID_PK INTEGER IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Album nvarchar(400)NOT NULL,
	UNC nvarchar(MAX)NULL
	);
/* Tabelle T_Genre erstellen*/
CREATE TABLE T_Genre(
	GenreID_PK INTEGER IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Stilrichtung nvarchar(150) NOT NULL
	);

/* Tabelle T_Benutzer erstellen*/
CREATE TABLE T_Benutzer (
	UserID_PK INTEGER IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Name nvarchar(200),
	Nachname nvarchar(400),
	Benutzername nvarchar(200) NOT NULL,
	Passwort nvarchar(200) NOT NULL,
	Email nvarchar(MAX) NOT NULL
	);

/* Tabelle T_Playlist erstellen*/
CREATE TABLE T_Playlist(
	PlaylistID_PK INTEGER IDENTITY(1,1) PRIMARY KEY NOT NULL,
	PlaylistName nvarchar(200)NOT NULL,
	--Wenn der benutzer ge�ndert wird wird auch seine Playlist ge�ndert, wenn der benutzer gel�scht wird auch seine Playlist gel�scht(Ganze zeile unten)
	UserID_FK INTEGER FOREIGN KEY (UserID_FK) REFERENCES  T_Benutzer (UserID_PK) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL
	);

/* Tabelle T_Titel erstellen*/
CREATE TABLE T_Titel(
	TitelID_PK INTEGER IDENTITY(1,1) PRIMARY KEY NOT NULL,
	TitelName nvarchar(300) NOT NULL,
	Ausgabejahr decimal(4,0) NOT NULL,
	Kaufpreis decimal(17,2) NOT NULL,
	Kaufdatum date NOT NULL,
	Dauer time NOT NULL,
	--Wenn der Land PK Land aktualisiert wird, wird auch in der Tabelle Titel die LandID_FK aktualisiert.(Siehe Zeile Untzen dran)
	LandID_FK INTEGER FOREIGN KEY (LandID_FK) REFERENCES T_Land (LandID_PK) ON UPDATE CASCADE NOT NULL,

	--Wenn der Benutzer aktualisiert wird, wird in der Tabelle Titel auch der FOREIGN UserID entsprechend aktualisiert.(Siehe 2 Zeilen Untzen dran)
	--Wenn der Benutzer gel�scht wird auch der Titel gel�scht wegen dem FOREIGN KEY mit ON DELETE CASCADE (Siehe Zeile Untzen dran)
	UserID_FK INTEGER FOREIGN KEY (UserID_FK) REFERENCES T_Benutzer (UserID_PK) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,

	--Wenn der InterpretID aktualisiert wird wird auch in der Tabelle Titel der IinterpretFK aktualisiert(Siehe Zeile Untzen dran)
	InterpretID_FK INTEGER FOREIGN KEY (InterpretID_FK) REFERENCES T_Interpret (InterpretID_PK) ON UPDATE CASCADE NOT NULL,

	--Wenn das AlbumPK aktualisiert wird wird auch in der Tabelle Titel AlbumFK aktualisiert(Siehe Zeile Untzen dran)
	AlbumID_FK INTEGER FOREIGN KEY (AlbumID_FK) REFERENCES T_Album (AlbumID_PK) ON UPDATE CASCADE NOT NULL,

	--Wenn der GenrePK aktualisiert wird wird auch in der Tabelle Titel GenreFK aktualisiert.(Siehe Zeile Untzen dran)
	GenreID_FK INTEGER FOREIGN KEY (GenreID_FK) REFERENCES T_Genre (GenreID_PK) ON UPDATE CASCADE NOT NULL,
	);

/* Tabelle T_Bewertung erstellen*/
CREATE TABLE T_Bewertung(
	BewertungID_PK INTEGER IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Bewertung decimal(2,1) NOT NULL,
	--Wenn der TitelPK aktualisiert wird wird auch der TitelFK in der Tabelle T_Bewertung aktualisiert.(Siehe 2 zeilen unten dran)
	--Wenn der TitelPK gel�scht wird auch entsprechend die Bewertungen in der Tabelle Bewertung zum TitelPK gel�scht werden. (Siehe zeile unten dran)
	TitelID_FK INTEGER FOREIGN KEY (TitelID_FK) REFERENCES T_Titel (TitelID_PK) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,

	--Wenn der UserID_PK aktualisiert wird auch in der Tabelle Bewertung der UserID_FK aktualisiert. (Siehe 2 zeilen unten dran)
	--Wenn der UserID_PK gel�scht wird, wird auch in der Tabelle Bewertung alle Bewertungen zum Benutzer gel�scht. (Siehe zeile unten dran)
	UserID_FK INTEGER FOREIGN KEY (UserID_FK) REFERENCES T_Benutzer (UserID_PK) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL
	);

/* Tabelle T_TitelPlaylist erstellen*/
CREATE TABLE T_TitelPlaylist(
	TitelPlaylistID_PK INTEGER IDENTITY(1,1) PRIMARY KEY NOT NULL,

	--Wenn der der TitelID_PK gel�scht wird, wird in der Tabelle TitelPlaylist der Titel gel�scht. (Siehe 2 zeilen unten dran)
	--Wenn der Titel_PK aktualisiert wird, wird in der Tabelle TitelPlaylist der Titel_FK aktualisiert. (Siehe zeile unten dran)
	TitelID_FK INTEGER FOREIGN KEY (TitelID_FK) REFERENCES T_Titel (TitelID_PK) NOT NULL,

	--Wenn der PlaylistID_PK aktulisiert wird, wird auch in der Tabelle TitelPlaylist der Playlist_FK aktualisiert. (Siehe 2 zeilen unten dran)
	--Wenn die PlaylistID_PK gel�scht wird, werden auch in der Tabelle TitelPLaylist alle eintr�ge zum entsprechenden PlaylistID_PK gel�scht. (Siehe zeile unten dran)
	PlaylistID_FK INTEGER FOREIGN KEY (PlaylistID_FK) REFERENCES T_Playlist (PlaylistID_PK) NOT NULL,
	);

/******Datenbank master verwenden******/


----Constrainst hinzuf�gen


------------------------inf17_alpha2_02_insert.sql
/* Datenbank master verwenden*/
USE [master]
GO
/* Datenbank DAlpha verwenden*/
USE [DAlpha];
GO



------------------------inf17_alpha2_03_select.sql
/* Datenbank master verwenden*/
USE [master]
GO
/* Datenbank DAlpha verwenden*/
USE [DAlpha];
GO