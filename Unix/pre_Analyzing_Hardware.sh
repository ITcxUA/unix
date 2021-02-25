##==================== ≠≠≠ ====================##
#### pre_Analyzing_Hardware.sh ####

pre_Analyzing_Hardware() 
{
  echo_info() {
    msg=$1
  # Send to console screen
    (echo "") >/dev/tty1
    (echo "$msg") >/dev/tty1
  }
  echo_info "Analyzing Hardware..."

# Первая часть показывает модель процессора и количество ядер
  echo_info "1. CPU Detail info:"
  cat /proc/cpuinfo|grep -i "model name"|head -n 1 > /dev/tty1
  (echo "Core number     : `cat /proc/cpuinfo|grep -i "model name"|wc -l`") >/dev/tty1

# Вторая часть, отображение размера единой корневой памяти и общего объема памяти
  echo_info "2. Memory Detail info:"
  dmidecode --type memory|grep -i "Size:"|grep -i "MB" > /dev/tty1
  (echo "Totle Size : `dmidecode --type memory|grep -i Size|grep -i MB|awk 'BEGIN{totle=0}{totle+=$2}END{print totle}'` MB") > /dev/tty1

# Третья часть, отображение марки и модели сетевой карты
  echo_info "3. Network controller info:"
  lspci|grep -i "Ethernet"|awk -F ":" '{print $3}' > /dev/tty1

# Четвертая часть, отображение емкости жесткого диска
  echo_info "4. Disk Detail info:"
  fdisk -l|grep -iE "Disk /dev/sd*|Disk /dev/vd*" > /dev/tty1

# Информация приостанавливается на 20 секунд, через 20 секунд запускается автоматическая установка
sleep 20

}
pre_Analyzing_Hardware