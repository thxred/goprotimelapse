#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Necessário introduzir o valor em segundos. ./tl.sh XXXX"
    exit 1
fi
# Apagar a pasta local do PC e do cartão SD da GOPRO
rm -rf /home/USER/10.5.5.9:8080
curl "http://10.5.5.9/gp/gpControl/command/storage/delete/all" || exit 1
echo  "Apagar pastas."
sleep 2
# Definir data e hora na Gopro com base no PC
TIME_STRING=$(printf "%%%02x%%%02x%%%02x%%%02x%%%02x%%%02x" $(date +%y_%m_%d_%H_%M_%S | sed 's/_/ /g'))
curl "http://10.5.5.9/gp/gpControl/command/setup/date_time?p=${TIME_STRING}"
echo  "Sincronização da data e hora."
sleep 2
# inicio timelapse (3600 = 1h)
curl "http://10.5.5.9/gp/gpControl/command/shutter?p=1"
echo "Iniciar timelapse durante $1 segundos."
sleep $1
# A parar a GOPRO
curl "http://10.5.5.9/gp/gpControl/command/shutter?p=0"
echo "A parar."
sleep 2
# A descobrir o nome da pasta da GOPRO e descarregar fotografias para o PC
gopro_folder=$(curl -v --silent "http://10.5.5.9:8080/gp/gpMediaList" 2>&1 | grep -o '...GOPRO')
wget -r -c --tries=0 "http://10.5.5.9:8080/videos/DCIM/"${gopro_folder}"/"
echo "A descarregar fotografias."
# A compilar as fotografias em video
ffmpeg -y -pattern_type glob -i "/home/USER/10.5.5.9:8080/videos/DCIM/"${gopro_folder}"/*.JPG" -filter:v "zoompan=z=1.1:d=1:x='px+0.5':y='ih/2-(ih/zoom/2)':s=1280x720:fps=25" -aspect 16/9 -vcodec libx264 -pix_fmt yuv420p -crf 15 /home/USER/videos/tl.mp4

