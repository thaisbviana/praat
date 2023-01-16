#produces Shannon-type AM noise from single selected Sound file using  4 bands
#can be easily tweaked to give other bands

fname$ = selected$  ("Sound", 1 )

#cut-off frequencies for (contiguous with hi/10 transition) four bands
b1 = 50
b2 = 800
b3 = 1500
b4 = 2500
b5 = 4000

#smoothing parameter for AM: minimum fo Hz (to get rid of Fo ripple)
minfo = 50
#produce the noise bands
call modnoise 'fname$' 'b1' 'b2'
call modnoise 'fname$' 'b2' 'b3'
call modnoise 'fname$' 'b3' 'b4'
call modnoise 'fname$' 'b4' 'b5'

#add up the separate bands
select Sound 'fname$'_'b1'_'b2'
plus Sound 'fname$'_'b2'_'b3'
plus Sound 'fname$'_'b3'_'b4'
plus Sound 'fname$'_'b4'_'b5'
execute "cjdisk:Applications (Mac OS 9):Sound:speech:Praat:scripts:Add_dynamic" no 1 Point-by-point values

#=======================
procedure modnoise nwave$ flo fhi
#=======================
#modnoise produces a band-pass noise between flo and fhi Hz, amplitude modulated to have same energy as original has in that band
select Sound 'nwave$'
durn = Get duration
sr = Get sample rate
Filter (pass Hann band)... 'flo' 'fhi' 'fhi'/10
Extract part... 0 'durn' Rectangular 1 no
opwr = Get power... 0 0
To Intensity... 'minfo' 0 yes
Down to IntensityTier

#make white noise
Create Sound... Noise 0 'durn' 'sr' randomGauss(0,0.1)
De-emphasize (in-line)... 50
Filter (pass Hann band)... 'flo' 'fhi' 'fhi'/10
Extract part... 0 'durn' Rectangular 1 no
plus IntensityTier 'nwave$'_band_part
Multiply
#NB Multiply scales to maximum of 0.9, so rescale to get same power as original
fpwr = Get power... 0 0
fmax = Get maximum... 0 0 None
Scale...  fmax*sqrt(opwr/fpwr)

Rename... 'nwave$'_'flo'_'fhi'

#tidy-up
select Sound Noise
plus Sound Noise_band
plus Sound Noise_band_part
plus Sound 'nwave$'_band
plus Sound 'nwave$'_band_part
plus Intensity 'nwave$'_band_part
plus IntensityTier 'nwave$'_band_part
Remove
endproc