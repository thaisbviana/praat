clearinfo

form Arquivo de áudio
	comment Insira abaixo o diretório de interesse.
	sentence Dir C:\Users\thais\Documents\UFMG\E) Monografia\Experimento
endform

ts_txtgrd = Read from file: "'dir$'\trecho_bmedts10_1.TextGrid"
a = Get number of intervals: 1
sp_txtgrd = Read from file: "'dir$'\trecho_bmedsp03_1a.TextGrid"
b = Get number of intervals: 1

n_intervals = b + a

tab = Create Table with column names: "start_time", 'n_intervals', "audio label start_time end_time" 

for i to b-1
	selectObject: sp_txtgrd
	t0 = Get start time of interval: 1, i
	t = Get end time of interval: 1, i
	selectObject: tab
	Set string value: i, "audio", "bmedsp03_1a"
	Set numeric value: i, "label", i
	Set numeric value: i, "start_time", 't0:4'
	Set numeric value: i, "end_time", 't:4'
endfor

for i to a-1
	selectObject: ts_txtgrd
	t0 = Get start time of interval: 1, i
	t = Get end time of interval: 1, i
	selectObject: tab
	Set string value: b-1+i, "audio", "bmedts10_1"
	Set numeric value: b-1+i, "label", i
	Set numeric value: b-1+i, "start_time", 't0:4'
	Set numeric value: b-1+i, "end_time", 't:4'
endfor

selectObject: 'tab'
Save as tab-separated file: "'dir$'\start_time.txt"
select all
Remove
print Fertig!