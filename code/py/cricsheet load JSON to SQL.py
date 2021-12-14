import yaml
import json
import os
import pyodbc 


outfile_folder = "C:\\Cricsheet\\All_JSONtemp\\"

conn = pyodbc.connect('Driver={SQL Server Native Client 11.0};'
                      'Server=MYWIN10I7;'
                      'Database=CricSheet;'
                      'Trusted_Connection=yes;')


for filename in os.listdir(outfile_folder):
    if filename.endswith(".json"):

        
        stream = open(outfile_folder + filename,"r")
        stream1 =  stream.read()

        #stream1 = 'json1'

        
        filename1 =   "00000000000000" + filename.replace(".json","")
        filename1 = filename1[-10:]
        
        cursor = conn.cursor()

        execSQLString = "DELETE FROM [dbo].[Staging_JSON2] WHERE FileName = ?"
        execdata=(filename1)
        try:
                cursor.execute(execSQLString,execdata)
        except:
                print("Error in deletion ",filename1)

        execSQLString =" INSERT INTO [dbo].[Staging_JSON2] (FileName,FullLine) VALUES ( ?,? ) ; "
        try:         

                execdata=(filename1,stream1)
                cursor.execute(execSQLString,execdata)
        except:
                print("Error in file " + filename1 )

        conn.commit()
        #break

print("All rows Inserted")