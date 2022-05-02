gcc -O0 -o main main.c
gcc -O0 -o main_fork main_fork.c
gcc -O0 -o main_philosopher main_philosopher.c
objdump -d main > text_dump
readelf -x .data main > data_dump