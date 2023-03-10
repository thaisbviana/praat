clearinfo

#Abre o arquivo TextGrid
form Diretório
	sentence Dir_txtgrd
endform
#dir: C:\Users\thais\Documents\UFMG\E) Monografia\Dados doc Bárbara\txtgrd + audios\trecho_bpubmn13\trecho_bpubmn13.TextGrid
textgrid = Read from file: "'dir_txtgrd$'"

#seleciona o arquivo TextGrid e conta quantos pontos têm em cada camada
selectObject: 'textgrid'
points_ntb = Get number of points: 2
points_tb = Get number of points: 3

#cria um objeto Table
ntb_tab = Create Table with column names: "ntb_length", 'points_ntb', "point_1 label_1 point_2 label_2 interval" 

#Pega os pontos e calcula os intervalos entre eles
#Atenção: aqui somente das não terminais!
for i to points_ntb-1
	selectObject: 'textgrid'
	lab_1 = Get label of point: 2, i
	t_0 = Get time of point: 2, i
	n = i+1
	lab_2 = Get label of point: 2, n
	t = Get time of point: 2, n
	dif_ntb = t - t_0
	selectObject: 'ntb_tab'
	p_1 = Set numeric value: i, "point_1", i
	l_1 = Set numeric value: i, "label_1", lab_1
	p_2 = Set numeric value: i, "point_2", n
	l_2 = Set numeric value: i, "label_2", lab_2
	int = Set numeric value: i, "interval", dif_ntb
endfor

#Salva o objeto Table
selectObject: 'ntb_tab'
Save as tab-separated file: "'textgrid$'table_ntb.txt"

#Repete o processo com as terminais
tb_tab = Create Table with column names: "tb_length", 'points_tb', "point_1 label_1 point_2 label_2 interval"

for j to points_ntb-1
	selectObject: 'textgrid'
	lab1 = Get label of point: 3, j
	t0 = Get time of point: 3, j
	m = j+1
	lab2 = Get label of point: 3, m
	tf = Get time of point: 3, m
	dif_tb = tf - t0
	selectObject: 'tb_tab'
	p_1 = Set numeric value: j, "point_1", j
	l_1 = Set numeric value: j, "label_1", lab1
	p_2 = Set numeric value: j, "point_2", m
	l_2 = Set numeric value: j, "label_2", lab2
	int = Set numeric value: j, "interval", dif_tb
endfor

selectObject: 'tb_tab'
Save as tab-separated file: "'textgrid$'table_tb.txt"

select all
Remove

print Done.