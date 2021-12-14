import yaml
import json
import os
import pyodbc 


infile_folder = "C:\\Cricsheet\\2020 April\\all\\"
outfile_folder = "C:\\Cricsheet\\All_JSONtemp\\"


conn = pyodbc.connect('Driver={SQL Server Native Client 11.0};'
                      'Server=MYWIN10I7;'
                      'Database=CricSheet;'
                      'Trusted_Connection=yes;')

cursor  = conn.cursor()
cursor.execute("SELECT FileName FROM [dbo].[Staging_JSON2]")
tables = cursor.fetchall()

filelist=[]
for i in tables:
    filelist.append(i[0])

print("Count of files  in database ",tables.count)

missingfiles=0

for filename in os.listdir(infile_folder):
    if filename.endswith(".yaml"):

        infile_path=infile_folder + filename
        outfile_path =  outfile_folder + filename.replace(".yaml",".json")

        #print(filename.replace(".yaml",""))

        filename1 = "00000000000000" + filename.replace(".yaml","")
        filename1 = filename1[-10:]

        if not filename1 in filelist:
            missingfiles=missingfiles+1

            stream = open(infile_path,"r")
            stream1 =  stream.read()
            stream.close()

            try:
                x=yaml.load(stream1,Loader=yaml.BaseLoader)
                print(type(x))
                addtojson = {"id":filename.replace(".yaml","")}
                x["meta"].update(addtojson)
                x1=json.dumps(x)
                print(type(x1))

                #print(x["meta"])
                #print(x["meta"])

                outfile = open(outfile_path,"w")
                outfile.write(x1)
                outfile.close
            except:
                    print("Error")

print("Total missing files ",missingfiles)
conn.close