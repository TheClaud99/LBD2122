# Caricamento file su Oracle DB

## Garantire all'utente l'accesso alla directory (sistemisti)

```sql
GRANT READ, WRITE ON DIRECTORY FILES_ORCL2122_DIR TO utente2122;
```

## Creazione tabella file (da fare solo la prima volta che si caricano file su un certo utente)

Eseguire il seguente script

```sql

  define utente = 'nome utente'

  -- crea la tabella dei file
  CREATE TABLE files_&utente (
  id NUMBER(10) NOT NULL,
  name VARCHAR2(50) NOT NULL,					
  datafile BLOB NOT NULL);
  -- l'attributo id come PK
  ALTER TABLE files_&utente ADD (
  CONSTRAINT files_&utente._pk PRIMARY KEY (id)
  );
  -- attributo name univoco
  ALTER TABLE files_&utente ADD (
  CONSTRAINT files_&utente._uk UNIQUE (name)
  );
  -- crea sequenza da usare per assegnare id all'inserimento di un nuovo file
  CREATE SEQUENCE files_&utente._seq;

```

## Caricamento file

1) Mettere sul server i file nella cartella "C:/FILES_ORCL2122" (sistemisti)
2) Eseguire la seguente procedure PLSQL impostando var_table_varchar con i file che si desidera caricare:

```sql

define utente = 'nome utente'

declare
  type table_varchar is table of varchar(100);
  var_table_varchar  table_varchar;
  l_dir VARCHAR2(100) := 'FILES_ORCL2122_DIR';
  l_bfile  BFILE;
  l_blob   BLOB;
begin
  -- la tabella vuota viene inizializzata con alcuni nomi di file standard
  var_table_varchar  := table_varchar('w3.css');
  
  -- Dopo aver copiato i files nella cartella di cui sopra
  -- carico i file specificati nella tabella del DB scorrendo i nomi contenuti nella
  -- collezione inizializzata alla riga precedente
  for l_file in 1 .. var_table_varchar.count loop
      INSERT INTO files_&utente (id, name, datafile)
      VALUES (files_&utente._seq.nextVal,var_table_varchar(l_file), empty_blob())
      RETURN datafile INTO l_blob;
		
	  -- la query precedente ritorna un riferimento al blob nel quale inserire il file
	  -- per cui recupero il riferimento al file (l_bfile) e ne copio il contenuto in l_blob
      l_bfile := BFILENAME(l_dir, var_table_varchar(l_file));
      DBMS_LOB.fileopen(l_bfile, DBMS_LOB.file_readonly);
      DBMS_LOB.loadfromfile(l_blob, l_bfile, DBMS_LOB.getlength(l_bfile));
      DBMS_LOB.fileclose(l_bfile);
    
      COMMIT;
    end loop;
end;


```
	