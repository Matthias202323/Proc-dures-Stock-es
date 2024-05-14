DROP DATABASE IF EXISTS SectTracking
GO
CREATE DATABASE SectTracking
GO

USE SectTracking

CREATE TABLE Address(address_id INT PRIMARY KEY IDENTITY(1,1),
                     street_number INT,
                     street_name VARCHAR(120) NOT NULL)
CREATE TABLE Sect(sect_id INT PRIMARY KEY IDENTITY(1,1),
                  name VARCHAR(60) NOT NULL)
CREATE TABLE Adherent(adherent_id INT PRIMARY KEY IDENTITY(1,1),
                      name VARCHAR(60))
CREATE TABLE SectAdherent(sect_adherent_id INT PRIMARY KEY IDENTITY(1,1),
                          FK_adherent_id INT NOT NULL,
                          FOREIGN KEY (FK_adherent_id) REFERENCES Adherent(adherent_id),
                          FK_sect_id INT NOT NULL,
                          FOREIGN KEY (FK_sect_id) REFERENCES Sect(sect_id))
GO

INSERT INTO Sect(name) VALUES ('Le Concombre Sacré'), ('Tomatologie'), ('Les abricots volant')
GO

DECLARE Sect_Cursor CURSOR SCROLL FOR
   SELECT sect_id FROM Sect
DECLARE @LastAdherentId INT
DECLARE @SectId INT
WHILE (SELECT COUNT(*) FROM SectAdherent) < 30
   BEGIN
      OPEN Sect_Cursor
      FETCH FIRST FROM Sect_Cursor INTO @SectId
      WHILE @@FETCH_STATUS = 0
         BEGIN
            INSERT INTO Adherent(name) VALUES(NULL)
            SET @LastAdherentId = (SELECT TOP(1) adherent_id FROM Adherent ORDER BY adherent_id DESC)
            INSERT INTO SectAdherent(FK_adherent_id, FK_sect_id) VALUES (@LastAdherentId, @SectId)
            FETCH NEXT FROM Sect_Cursor INTO @SectId
         END
      CLOSE Sect_Cursor
   END
DEALLOCATE Sect_Cursor
GO

UPDATE Adherent SET name='Joe' where adherent_id =1;
UPDATE Adherent SET name='Bernard' where adherent_id =2;
UPDATE Adherent SET name='Marcel' where adherent_id =3;
UPDATE Adherent SET name='Yacine' where adherent_id =4;
UPDATE Adherent SET name='Moreno' where adherent_id =5;
UPDATE Adherent SET name='Jean Louis' where adherent_id =6;
UPDATE Adherent SET name='Marcello' where adherent_id =7;
UPDATE Adherent SET name='Jean Marc' where adherent_id =8;
UPDATE Adherent SET name='Bernadette' where adherent_id =9;
UPDATE Adherent SET name='Yvonne' where adherent_id =10;
UPDATE Adherent SET name='Jeanette' where adherent_id =11;
UPDATE Adherent SET name='Jean Paul' where adherent_id =12;
UPDATE Adherent SET name='James' where adherent_id =13;
UPDATE Adherent SET name='Aurelie' where adherent_id =14;
UPDATE Adherent SET name='Marion' where adherent_id =15;
UPDATE Adherent SET name='Mathilde' where adherent_id =16;
UPDATE Adherent SET name='Marianne' where adherent_id =17;
UPDATE Adherent SET name='Jean Bernard' where adherent_id =18;
UPDATE Adherent SET name='Jean Maurice' where adherent_id =19;
UPDATE Adherent SET name='Abdel' where adherent_id =20;

DROP PROCEDURE IF EXISTS sp_GetAdherentsCountForSectName
GO

CREATE PROCEDURE sp_GetAdherentsCountForSectName
  @SectName VARCHAR(60)
  AS
    SELECT COUNT(Adherent.adherent_id)
    FROM SectAdherent
    INNER JOIN Sect ON Sect.sect_id = SectAdherent.FK_sect_id
    INNER JOIN Adherent ON Adherent.adherent_id = SectAdherent.FK_adherent_id
    GROUP BY Sect.name HAVING Sect.name = @SectName
RETURN
GO

DECLARE @AdherentsCountForTomatology INT
EXECUTE @AdherentsCountForTomatology = sp_GetAdherentsCountForSectName 'Tomatologie'
PRINT @AdherentsCountForTomatology
GO

CREATE PROCEDURE sp_AddAdherentForSectName
  
  AS
    SELECT Adherent.adherent_id, Adherent.name,Sect.name
    FROM SectAdherent
    INNER JOIN Sect ON Sect.sect_id = SectAdherent.FK_sect_id
    INNER JOIN Adherent ON Adherent.adherent_id = SectAdherent.FK_adherent_id
    
RETURN
GO

DECLARE @AddAdherents INT
EXECUTE @AddAdherents= sp_AddAdherentForSectName
PRINT @AddAdherents
GO

DROP PROCEDURE IF EXISTS sp_GetCountForSects
GO

CREATE PROCEDURE sp_GetCountForSects
  @SectsCount INT OUTPUT
  AS
    SELECT @SectsCount = COUNT(Sect.name) FROM Sect;
GO

DECLARE @SectsCount INT;
EXECUTE sp_GetCountForSects @SectsCount OUTPUT;
SELECT @SectsCount As Number_Of_Sects
GO