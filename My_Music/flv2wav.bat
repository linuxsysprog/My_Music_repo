ffmpeg -i "%~d1%~p1%~n1.flv" -acodec pcm_s16le -ar 44100 -ac 2 "%~d1%~p1%~n1.wav"
pause
