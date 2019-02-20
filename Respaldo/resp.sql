if DB_ID('$(database)') is not null
begin
DECLARE @Database varchar(50), @Path varchar(100), @Folder varchar(100), @Name varchar(100)

SET @Database = (select '$(database)')

SET @Folder = (select '$(folder)')

set @Name = (select 'copia_'+@Database+'_'+convert(varchar(50),GetDate(),112))

SET @Path=(SELECT @Folder+'copia_'+@Database+'_'+convert(varchar(50),GetDate(),112)+'.bak')

BACKUP DATABASE @Database TO  DISK =@Path WITH NOFORMAT, NOINIT,  NAME = N'BDFlexline-Completa Base de datos Copia de seguridad', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

end
else
print 'No such database named $(database) is found'
GO