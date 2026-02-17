#!/opt/homebrew/bin/bash


args=("$@")

col=6
if [ "$1" != "" ]; then
  col=$1
fi
alt=8
if [ "$2" != "" ]; then
  alt=$2
fi

from=15
to=255

# "𝟢𝟣𝟤𝟥𝟦𝟧𝟨𝟩𝟪️𝟫︎ᴬᴮ ᴰᴱᴀʙᴄᴅᴇ𝖠️𝖡︎𝖢𝖣𝖤𝖥𝘈𝘉𝘊𝘋𝘌𝘍𝖺𝖻𝖼𝖽𝖾𝖿 𝟶𝟷𝟸𝟹𝟺𝟻𝟼𝟽𝟾𝟿𝙰𝙱𝙲𝙳𝙴𝙵 𝖠𝖡𝖢𝖣𝖤𝖥"

for i in {1..16} ; do
  if (( i <= 16 )); then
    printf "\e[38;5;%sm􀏄􀾘%-3d\e[0m" "$i" "$i";
  fi;

  if (( i % 8 == 0 )); then
    printf "\n";
  fi;
done
printf "\n";

align=$(( $col - ($from % $col) ))
grp=$(( ($to - $from) / $alt ))

# for (( x = 0; x < "$align"; x++)) ; do
#   printf "____,";
# done
for (( i = 0; i < "$alt"; i++)) ; do
  for (( j = 1; j <= "$grp"; j++)) ; do
    x=$(( $from + ($i * $grp) + $j ))

    if (( $x >= $from && $x <= $to )) ; then
      # printf "\e[38;5;%sm􀏄%-3d\e[0m" "$x" "$x";
      # printf "\e[38;5;%sm􁷰􀟐%-3d􀟐 \e[0m" "$x" "$x";
      printf "\e[38;5;%sm􀟼%-3d \e[0m" "$x" "$x";
    else
      printf "     ";
    fi;

    if (( (($x - $align) % $col) == 0 )); then
      printf "\n";
    fi;
  done
  # printf "\n";
done
printf "\n";

#  *n              -2    -1    +0   +1    +2
# 16-21 1 a   → a             16-21
# 22-27 2  b  → a                  34-39
# 28-33 3   c → b       22-27         
# 34-39 4 a   → b                  40-45
# 40-45 5  b  → c 28-33
# 46-51 6   c → c             46-51
#
# 􁷰 172􁹬 􁷲 􁸆  􀩹  􁹬 􀂓 􀏄􀏄  􁹬 􀟐􀟐􀟐􀟊 􁹬 􀝞 􁷰 􀟇 􁹬 
# 􀀁􀮷􀂓 􀾘 􀡘 􀣯 􀏄 􁷰 􀉟 􀪫 􂧰  􃇐  􃈃  􀚈􀛧 􀚇 􂫒  􀚉􁷰􀟐  
# 􁷰 􁉖 􀧷􀲡􀛤􁹬􀥱 􀠨 􃖒  􁌣 􁹬 􀟼 􀼰􀼯􀼮     
#
# 􀮋 􁓓 􀮌 􂼼  􀮞  􀣮􀮞􀮟
# 􀣮􀥰􀟈
# 􀣯􀥱􀟉
# 􀝜􀧒  
# 􀾘􀧑􀂒
exit 0

for i in {1..3} ; do
  for j in {1..12} ; do
    for k in {1..6} ; do
      q=$(( start + (j * i * 6) + k ))
      printf "\e[38;5;􁷰%sm􁷲%-3d\e[0m" "$q" "$q";
    done
    printf "\n";
  done
  printf "\n";
done


printf "\n";
for i in {1..255} ; do
  if (( (i - 15) % 36 == 0)); then
  fi;
  if (( (i - 15) % 36 == 0)); then
  fi;
  if (( (i - 15) % 36 == 0)); then
  fi;

  printf "\e[38;5;%sm􀏄 %02x\e[0m" "$i" "$i";
  if (( i == 15 )) || (( i > 15 )) && (( (i - 15) % 36 == 0 )); then
    printf "\n";
  fi;
done
# printf "\n";
# for i in {1..255} ; do
#   printf "\e[38;5;%sm􀏄 %02x\e[0m" "$i" "$i";
#   if (( i == 15 )) || (( i > 15 )) && (( (i - 15) % 36 == 0 )); then
#     printf "\n";
#   fi;
# done
printf "\n";

for i in {1..255} ; do
  printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i";
  if (( i == 15 )) || (( i > 15 )) && (( (i - 15) % 36 == 0 )); then
    printf "\n";
  fi;
done
printf "\n";

for i in {16,52,88,1,124,160,9,196} ; do
  printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i";
done
printf "\n";
for i in {22,28,2,34,40,10,46} ; do
  printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i";
done
printf "\n";
for i in {58,64,0,70,76,10,82} ; do
  printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i";
done
printf "\n";
for i in {94,100,3,106,112,10,118} ; do
  printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i";
done
printf "\n";
for i in {130,136,3,142,148,0,154} ; do
  printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i";
done
printf "\n";
for i in {166,172,0,180,186,0,192} ; do
  printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i";
done
printf "\n";
for i in {202,208,0,214,220,11,226} ; do
  printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i";
done
printf "\n";
for i in {202,208,0,214,220,11,226} ; do
  printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i";
done
printf "\n";

for j in {0..6} ; do
  for i in {0..24} ; do
    printf "\x1b[48;5;%sm%3d\e[0m " "$((16 + j * 16 + i * 6 ))" "$((16 + j * 16 + i * 6 ))";
    if (( i % 6 == 0 )); then
      printf "\n";
    fi;
  done
  printf "\n";
done

