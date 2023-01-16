clearinfo
#Abre os arquivos .TextGrid
form
	sentence Dir C:\Users\thais\Documents\UFMG\E) Monografia\Intervalos entre pausas\
endform

txtgrd_1 = Read from file: "'dir$'trecho_bmedsp03_1a.TextGrid"
txtgrd_2 = Read from file: "'dir$'trecho_bmedts10_1.TextGrid"

#Conta a quantidade de etiqueta por camada
selectObject: 'txtgrd_1'
p_1 = Get number of intervals: 1
selectObject: 'txtgrd_2'
p_2 = Get number of intervals: 1
p = p_1 + p_2

#cria um objeto Table
tab = Create Table with column names: "pauses", 'p', "audio number label time interval" 

#Calcula os tempos de pausas e de fala corrida
for i to p_1-1
	selectObject: 'txtgrd_1'
	t0 = Get start time of interval: 1, i
	t = Get end time of interval: 1, i
	int = t - t0
	lab$ = Get label of interval: 1, i
	selectObject: 'tab'
	Set string value: i, "audio", "bmedsp03_1a"
	Set numeric value: i, "number", i
	Set string value: i, "label", lab$
	Set numeric value: i, "time", 't:4'
	Set numeric value: i, "interval", 'int:4'
endfor

for j to p_2-1
	selectObject: 'txtgrd_2'
	t0 = Get start time of interval: 1, j
	t = Get end time of interval: 1, j
	int = t - t0
	lab$ = Get label of interval: 1, j
	selectObject: 'tab'
	Set string value: p_1-1+j, "audio", "bmedts01_1"
	Set numeric value: p_1-1+j, "number", j
	Set string value: p_1-1+j, "label", lab$
	Set numeric value: p_1-1+j, "time", 't:4'
	Set numeric value: p_1-1+j, "interval", 'int:4'
endfor

#Salva o objeto Table
selectObject: 'tab'
Save as tab-separated file: "'dir$'table_pauses.txt"