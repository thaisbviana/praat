clearinfo

form Arquivo de áudio
	comment Insira abaixo o diretório de interesse.
	sentence Dir C:\Users\thais\Documents\UFMG\E) Monografia\Experimento
endform

sp_sound = Read from file: "'dir$'\trecho_bmedsp03_1a.wav"
sp_txtgrd = Read from file: "'dir$'\trecho_bmedsp03_1a.TextGrid"

table_sp = Read Table from tab-separated file: "'dir$'\table_sp.txt"
n_rows = Get number of rows
n_columns = Get number of columns

for i to n_rows-1
	selectObject: table_sp
	x = Get value: i, "interval_id"
	y = Get value: i+1, "interval_id"
	selectObject: sp_txtgrd
	t0 = Get start time of interval: 1, x
	t = Get start time of interval: 1, y
	ext_txtgrd = Extract part: t0, t+0.05, 0
	selectObject: ext_txtgrd
	Save as text file: "'dir$'\bmedsp03_1a - extracted\'x'.TextGrid"
	selectObject: sp_sound
	ext_sound = Extract part: t0, t+0.05, "rectangular", 1, 0
	Save as WAV file: "'dir$'\bmedsp03_1a - extracted\'x'.wav"
endfor

selectObject: table_sp
x = Get value: n_rows, "interval_id"
y = Get value: i+1, "interval_id"
selectObject: sp_txtgrd
t0 = Get start time of interval: 1, x
t = Get start time of interval: 1, y
ext_txtgrd = Extract part: t0, t+0.05, 0
selectObject: ext_txtgrd
Save as text file: "'dir$'\bmedsp03_1a - extracted\'x'.TextGrid"
selectObject: sp_sound
ext_sound = Extract part: t0, t+0.05, "rectangular", 1, 0
Save as WAV file: "'dir$'\bmedsp03_1a - extracted\'x'.wav"

select all
Remove