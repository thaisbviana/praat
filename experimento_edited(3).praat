clearinfo

form Arquivo de áudio
	comment Insira abaixo o diretório de interesse.
	sentence Dir D:\Monografia\RECORTE_BÁRBARA
endform

#Para bmedsp03_1a:
txtgrd_bar = Read from file: "'dir$'\trecho_bmedsp03_1a\trecho_bmedsp03_1a.TextGrid"
txtgrd_tha = Read from file: "'dir$'\trecho_bmedsp03_1a.TextGrid"

table_sp = Read Table from tab-separated file: "'dir$'\table_sp.txt"
n_rows = Get number of rows
n_columns = Get number of columns

for i to n_rows-1
	selectObject: table_sp
	x = Get value: i, "interval_id"
	y = Get value: i+1, "interval_id"
	selectObject: txtgrd_tha
	t0 = Get start point: 1, x
	t = Get start point: 1, y
	selectObject: txtgrd_bar
	ext_txtgrd = Extract part: t0, t+0.05, 0
	selectObject: ext_txtgrd
	Save as text file: "'dir$'\bmedsp03_1a - txtgrd_bar - cut\'x'.TextGrid"
endfor

selectObject: table_sp
b = Get value: n_rows, "interval_id"
selectObject: txtgrd_tha
t0 = Get start time of interval: 1, b
t = Get end time of interval: 1, b
selectObject: txtgrd_bar
ext_txtgrd = Extract part: t0, t+0.05, 0
selectObject: ext_txtgrd
Save as text file: "'dir$'\bmedsp03_1a - txtgrd_bar - cut\'x'.TextGrid"

select all
Remove

#Para bmests10_1:
txtgrd_barb = Read from file: "'dir$'\trecho_bmedts10\segundo corte\19 segmentadores\trecho_bmedts10_1.TextGrid"
txtgrd_thai = Read from file: "'dir$'\trecho_bmedts10_1.TextGrid"

table_ts = Read Table from tab-separated file: "'dir$'\table_ts.txt"
n_rows = Get number of rows
n_columns = Get number of columns

for i to n_rows-1
	selectObject: table_ts
	z = Get value: i, "interval_id"
	w = Get value: i+1, "interval_id"
	selectObject: txtgrd_thai
	t0 = Get start point: 1, z
	t = Get start point: 1, w
	selectObject: txtgrd_barb
	ext_txtgrd = Extract part: t0, t+0.05, 0
	selectObject: ext_txtgrd
	Save as text file: "'dir$'\bmedts10_1 - txtgrd_bar - cut\'z'.TextGrid"
endfor

selectObject: table_ts
a = Get value: n_rows, "interval_id"
selectObject: txtgrd_thai
t0 = Get start time of interval: 1, a
t = Get end time of interval: 1, a
selectObject: txtgrd_barb
ext_txtgrd = Extract part: t0, t+0.05, 0
selectObject: ext_txtgrd
Save as text file: "'dir$'\bmedts10_1 - txtgrd_bar - cut\'a'.TextGrid"

select all
Remove

print Done!