if DB_ID('$(database)') is not null
begin
DECLARE @Database varchar(50), @Path varchar(50), @Folder varchar(50)

SET @Database = (select '$(database)')

SET @Folder = (select '$(folder)')

SELECT @Path=(SELECT @Folder+'copia_'+@Database+'_'+convert(varchar(50),GetDate(),112)+'.bak')

BACKUP DATABASE @Database TO  DISK =@Path WITH NOFORMAT, NOINIT,  NAME = N'BDFlexline-Completa Base de datos Copia de seguridad', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

end
else
print 'No such database named $(database) is found'
GO