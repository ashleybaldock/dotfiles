
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

