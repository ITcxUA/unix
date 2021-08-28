<pre>
<code>
sudo dnf install nginx
</code>
</pre>

---------------------


<div class="single_post">
<header>
<h1 class="title single-title entry-title">Резервное копирование Ubuntu</h1>

</header>
<!--.headline_area-->
<div class="post-single-content box mark-links entry-content">

<p>Резервное копирование системы очень важно, поскольку если у вас есть резервная копия всех файлов, настроек или даже системы полностью, то вы можете ее восстановить в случае возникновения проблем. Несмотря на стабильность Linux, эта система может ломаться, например, после обновления или когда вы экспериментировали и сделали что-то не так.</p>

<p>Если вы делаете резервное копирование Ubuntu, то потом сможете все очень просто восстановить, даже если система была почти убита. Уже существует множество программ для создания резервных копий как файлов, так и всего диска, одна из самых популярных из них - это <a href="https://losst.ru/klonirovanie-diska-clonezilla">CloneZilla</a>. Но мы не будем их сегодня рассматривать. В этой статье мы поговорим о том, как выполнить резервное копирование системы без сторонних программ, с помощью системных команд. Это может быть полезнее в некоторых случаях.<br>
<span id="more-16646">
</span>
</p>
<div id="ez-toc-container" class="ez-toc-v2_0_17 counter-hierarchy counter-numeric">
<div class="ez-toc-title-container">
<p class="ez-toc-title">Содержание статьи:</p>
<span class="ez-toc-title-toggle">
</span>
</div>
<nav>
<ul class="ez-toc-list ez-toc-list-level-1">
<li class="ez-toc-page-1 ez-toc-heading-level-2">
<a class="ez-toc-link ez-toc-heading-1" href="#%D0%A0%D0%B5%D0%B7%D0%B5%D1%80%D0%B2%D0%BD%D0%BE%D0%B5_%D0%BA%D0%BE%D0%BF%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5_Ununtu" title="Резервное копирование Ununtu">Резервное копирование Ununtu</a>
<ul class="ez-toc-list-level-3">
<li class="ez-toc-heading-level-3">
<a class="ez-toc-link ez-toc-heading-2" href="#%D0%A1%D0%BF%D0%BE%D1%81%D0%BE%D0%B1_1_%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA_%D0%BF%D0%B0%D0%BA%D0%B5%D1%82%D0%BE%D0%B2" title="Способ 1. Список пакетов">Способ 1. Список пакетов</a>
</li>
<li class="ez-toc-page-1 ez-toc-heading-level-3">
<a class="ez-toc-link ez-toc-heading-3" href="#%D0%A1%D0%BF%D0%BE%D1%81%D0%BE%D0%B1_2_%D0%A1%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5_%D0%B0%D1%80%D1%85%D0%B8%D0%B2%D0%B0" title="Способ 2. Создание архива">Способ 2. Создание архива</a>
</li>
<li class="ez-toc-page-1 ez-toc-heading-level-3">
<a class="ez-toc-link ez-toc-heading-4" href="#%D0%A1%D0%BF%D0%BE%D1%81%D0%BE%D0%B1_3_%D0%A0%D0%B5%D0%B7%D0%B5%D1%80%D0%B2%D0%BD%D0%BE%D0%B5_%D0%BA%D0%BE%D0%BF%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5_%D0%B2_rsync" title="Способ 3. Резервное копирование в rsync">Способ 3. Резервное копирование в rsync</a>
</li>
<li class="ez-toc-page-1 ez-toc-heading-level-3">
<a class="ez-toc-link ez-toc-heading-5" href="#%D0%A1%D0%BF%D0%BE%D1%81%D0%BE%D0%B1_4_%D0%A1%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5_%D0%BE%D0%B1%D1%80%D0%B0%D0%B7%D0%B0_%D1%80%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB%D0%B0" title="Способ 4. Создание образа раздела">Способ 4. Создание образа раздела</a>
</li>
<li class="ez-toc-page-1 ez-toc-heading-level-3">
<a class="ez-toc-link ez-toc-heading-6" href="#%D0%A1%D0%BF%D0%BE%D1%81%D0%BE%D0%B1_5_%D0%A1%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5_Squashfs_%D0%BE%D0%B1%D1%80%D0%B0%D0%B7%D0%B0" title="Способ 5. Создание Squashfs образа">Способ 5. Создание Squashfs образа</a>
</li>
</ul>
</li>
<li class="ez-toc-page-1 ez-toc-heading-level-2">
<a class="ez-toc-link ez-toc-heading-7" href="#%D0%92%D1%8B%D0%B2%D0%BE%D0%B4%D1%8B" title="Выводы">Выводы</a>
</li>
</ul>
</nav>
</div>
<h2>
<span class="ez-toc-section" id="%D0%A0%D0%B5%D0%B7%D0%B5%D1%80%D0%B2%D0%BD%D0%BE%D0%B5_%D0%BA%D0%BE%D0%BF%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5_Ununtu">
</span>Резервное копирование Ununtu<span class="ez-toc-section-end">
</span>
</h2>
<p>Рассмотрим самые распространенные способы копирования среди администраторов и обычных пользователей.</p>
<h3>
<span class="ez-toc-section" id="%D0%A1%D0%BF%D0%BE%D1%81%D0%BE%D0%B1_1_%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA_%D0%BF%D0%B0%D0%BA%D0%B5%D1%82%D0%BE%D0%B2">
</span>Способ 1. Список пакетов<span class="ez-toc-section-end">
</span>
</h3>
<p>Самый простой способ резервного копирования Ubuntu, кстати, именно эту возможность использует MintBackup в LinuxMint, это получение списка всех установленных пакетов. Да, тут вы не сохраните всю конфигурацию, зато сможете очень быстро восстановить все установленные программы.</p>
<p>Если учесть, что большинство конфигурационных файлов находятся в домашней папке пользователя, а она не стирается при переустановке, то остальные файлы не такая уже большая проблема. А такая резервная копия будет занимать всего несколько килобайт. Для выполнения резервной копии наберите такую команду:</p>
<p>
<pre><code>
dpkg --get-selections | grep -v deinstall &gt; backup.txt
</code></pre>
</p>
<p>
<img loading="lazy" class="size-large wp-image-16654 aligncenter" src="https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-23-10-1024x576.png" alt="" width="750" height="422" srcset="https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-23-10-1024x576.png 1024w, https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-23-10-300x169.png 300w, https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-23-10-768x432.png 768w, https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-23-10.png 1920w" sizes="(max-width: 750px) 100vw, 750px">
</p>
<p>Далее, скопируйте полученный файл в надежное место. Когда система сломается, переустановите ее с установочного носителя, а затем просто выполните команды:</p>
<p>
<pre><code>
sudo dpkg --set-selections backup.txt
</code></pre>
</p>
<p>

<pre><code>
sudo apt -y update
</code></pre>

<br>

<pre><code>
sudo apt-get dselect-upgrade
</code></pre>

</p>
<p>Файл со списком пакетов нужно поместить в текущую папку. Таким образом, вы очень быстро вернете все ранее установленные программы с минимальными затратами времени и в то же время получите чистую систему.</p>
<h3>
<span class="ez-toc-section" id="%D0%A1%D0%BF%D0%BE%D1%81%D0%BE%D0%B1_2_%D0%A1%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5_%D0%B0%D1%80%D1%85%D0%B8%D0%B2%D0%B0">
</span>Способ 2. Создание архива<span class="ez-toc-section-end">
</span>
</h3>
<p>Резервное копирование таким способом более надежно, поскольку вы не просто создаете список установленных программ, а делаете архив из всей файловой системе. Фактически, вы можете потом развернуть этот архив на любой машине и получить полноценную операционную систему после настройки драйверов.</p>
<p>Таким способом часто создаются резервные копии систем на серверах и для него достаточно просто использовать утилиту tar и не нужны сторонние программы. Для создания архива используйте такую команду:</p>
<p>
<pre><code>
sudo tar czf /backup.tar.gz --exclude=/backup.tar.gz --exclude=/home --exclude=/media --exclude=/dev --exclude=/mnt --exclude=/proc --exclude=/sys --exclude=/tmp /
</code></pre>

</p>

<p>
<a href="https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-23-42.png">
<img loading="lazy" class="size-large wp-image-16653 aligncenter" src="https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-23-42-1024x576.png" alt="" width="750" height="422" srcset="https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-23-42-1024x576.png 1024w, https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-23-42-300x169.png 300w, https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-23-42-768x432.png 768w, https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-23-42.png 1920w" sizes="(max-width: 750px) 100vw, 750px">
</a>
</p>
<p>В этой команде все достаточно просто несмотря на ее запутанность. Опция c означает, что нужно создать архив (Create), z - включает сжатие Gzip. Затем с помощью опции -f мы указываем файл, в который нужно сохранить результат. Затем с помощью серии опций --exclude мы исключаем из архива сам файл архива, домашний каталог и директории с виртуальными файловыми системами. В самом конце указываем папку, с которой стоит начать сбор данных - /. Вот и все. Процесс займет очень много времени, но когда он завершится, вы получите полную резервную копию системы в корневом каталоге.</p>
<p>Если система повреждена, вам нужно загрузиться с LiveCD/USB, и примонтировать корневой каталог в /mnt/. Затем подключите носитель с резервной копией и выполните команду для распаковки:</p>
<p>
<pre><code>
sudo tar xf /run/media/имя_носителя/backup.tar.gz -C /mnt
</code></pre>

</p>
<p>Команда быстро распакует все, что было сохранено и вам останется только перезагрузить компьютер, чтобы вернуться к своей основной системе. Здесь не восстанавливается только загрузчик, <a href="https://losst.ru/vosstanovlenie-grub2">восстановить Grub</a> нужно отдельно если он был поврежден.</p>
<h3>
<span class="ez-toc-section" id="%D0%A1%D0%BF%D0%BE%D1%81%D0%BE%D0%B1_3_%D0%A0%D0%B5%D0%B7%D0%B5%D1%80%D0%B2%D0%BD%D0%BE%D0%B5_%D0%BA%D0%BE%D0%BF%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5_%D0%B2_rsync">
</span>Способ 3. Резервное копирование в rsync<span class="ez-toc-section-end">
</span>
</h3>
<p>Этот способ очень похож на второй, но здесь архив не создается, а данные просто переносятся в другую папку. Это может более полезно при простом копировании операционной системы в другое место. Команда выглядит вот так:</p>
<p>
<pre><code>
rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} / /папка/назначения
</code></pre>

</p>
<p>
<a href="https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-25-07.png">
<img loading="lazy" class="size-large wp-image-16652 aligncenter" src="https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-25-07-1024x576.png" alt="" width="750" height="422" srcset="https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-25-07-1024x576.png 1024w, https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-25-07-300x169.png 300w, https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-25-07-768x432.png 768w, https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-25-07.png 1920w" sizes="(max-width: 750px) 100vw, 750px">
</a>
</p>
<p>Набор опций -aAX включают передачу в режиме архива, что гарантирует полное копирование символических ссылок, устройств, разрешений и расширенных атрибутов, при условии, что их поддерживает целевая файловая система. Опция --exclude, как и раньше, исключает из копии виртуальные файловые системы.</p>
<p>После завершения копирования вам останется отредактировать /etc/fstab и заменить в нем адрес корневого раздела на новый. А также создать новый конфигурационный файл для загрузчика, автоматически или вручную.</p>
<h3>
<span class="ez-toc-section" id="%D0%A1%D0%BF%D0%BE%D1%81%D0%BE%D0%B1_4_%D0%A1%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5_%D0%BE%D0%B1%D1%80%D0%B0%D0%B7%D0%B0_%D1%80%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB%D0%B0">
</span>Способ 4. Создание образа раздела<span class="ez-toc-section-end">
</span>
</h3>
<p>
<a href="https://losst.ru/komanda-dd-linux">Команда dd linux</a> позволяет создать полную копию раздела или даже всего диска. Это самый надежный, но в то же время потребляющий большое количество памяти способ выполнить резервное копирование системы Ubuntu. Утилита просто переносит весь диск по одному байту в образ. Команда выглядит вот так:</p>
<p>
<pre><code>
sudo dd if=/dev/sda4 of=~/backup.img
</code></pre>

</p>
<p>
<a href="https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-25-32.png">
<img loading="lazy" class="size-large wp-image-16651 aligncenter" src="https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-25-32-1024x576.png" alt="" width="750" height="422" srcset="https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-25-32-1024x576.png 1024w, https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-25-32-300x169.png 300w, https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-25-32-768x432.png 768w, https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-25-32.png 1920w" sizes="(max-width: 750px) 100vw, 750px">
</a>
</p>
<p>Здесь /dev/sda4 - это ваш корневой раздел. После завершения выполнения команды вы получите готовый образ, затем, чтобы восстановить систему из этой копии достаточно поменять опции местами и указать путь к файлу копии:</p>
<p>
<pre><code>
sudo dd if=~/backup.img of=/dev/sda4
</code></pre>

</p>
<p>Правда, процесс может занять достаточно много времени, в зависимости от скорости работы вашего диска.</p>
<h3>
<span class="ez-toc-section" id="%D0%A1%D0%BF%D0%BE%D1%81%D0%BE%D0%B1_5_%D0%A1%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5_Squashfs_%D0%BE%D0%B1%D1%80%D0%B0%D0%B7%D0%B0">

</span>Способ 5. Создание Squashfs образа<span class="ez-toc-section-end">
</span>
</h3>
<p>Преимущество Squashfs в том, что это полноценная файловая система в одном файле, которую можно очень быстро примонтировать и быстро извлечь нужные файлы. Кроме того, файловую систему можно открыть привычными менеджерами архивов. Для создания образа со всей системы используйте:</p>
<p>
<pre><code>
apt install squashfs-tools
</code></pre>
<pre><code>
DATA=$(date +%Y%m%d-%H%M%S);
sudo mksquashfs / /root-backup_$DATA.sqsh -e root-backup.sqsh \
boot \
dev \
etc \
home \
media \
mnt \
opt \
proc \
root \
run \
srv \
sys \
tmp \
usr \
var
</code></pre>

</p>
<p>
<a href="https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-26-04.png">
<img loading="lazy" class="size-large wp-image-16650 aligncenter" src="https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-26-04-1024x576.png" alt="" width="750" height="422" srcset="https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-26-04-1024x576.png 1024w, https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-26-04-300x169.png 300w, https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-26-04-768x432.png 768w, https://losst.ru/wp-content/uploads/2017/06/Snimok-ekrana-ot-2017-06-05-21-26-04.png 1920w" sizes="(max-width: 750px) 100vw, 750px">
</a>
</p>
<p>Теперь, чтобы примонтировать созданный образ будет достаточно набрать такую команду:</p>

<pre><code>
sudo mount /root-backup.sqsh /mnt/ -t squashfs -o loop
</code></pre>
<pre><code>
# А уже отсюда вы можете извлечь любой файл или перенести все это в реальную файловую систему с помощью 
cp -p
</code></pre>
<p>Резервное копирование Ubuntu 16.04 очень важно для поддержания вашей операционной системы в нормальном состоянии. В случае любой неожиданной ситуации вы сможете все восстановить. Если вас интересуют графические программы для бэкапа, вы можете попробовать remastersys или <a href="https://losst.ru/otkat-sistemy-ubuntu">timeshift</a>. Надеюсь, эта информация была полезной для вас.</p>
  
  ---------------------------------------
утилиты, которые позволяют делать backup системы, но с расчетом, чтобы каждый раз не был Full, а также поддерживал бы дифференциальный?Понятно, что всякие дополнительные мощные средства как Symantec, Acronis, Veeam и др. умеют это делать, но именно чтобы были утилиты небольшие по размеру и желательно из репов и бесплатные?

UNCLEKRUK12 ИЮНЯ, 2017 Ответить
можно попробовать Aptik

Возможности
Поддержание/восстановление пакетов приложений и PPA
Поддержание/восстановление установленных пакетов
Поддержание/восстановление иконок из директории /usr/share/icons и тем из директории /usr/share/themes
Поддержание/восстановление настроек приложений. Оно сохраняет zip-архивы разделов конфигураций приложений из домашней директории в местоположение резервных копий.
Поддержание/восстановление пользователей и групп. Создает резервные копии пользователей и групп и восстанавливает их на новой системе
Поддержание/восстановление записей. Создает резервные копии записей в директориях /etc/fstab и /etc/crypttab и восстанавливает их на новой системе
Поддержание/восстановление данных в директории Home. Создает резервные копию данных пользовательской директории Home и восстанавливает ее на новой системе
Запланированные задачи. Создает резервные копии записей файлов заданий crontab для всех пользователей и восстанавливает их на новой системе
Зашифрованные резервные копии. Резервные копии, содержащие личную информацию, шифруются с использованием AES-128.
Отдельные или периодические операции. Можно создавать копии как одного, так и нескольких объектов
Поддержка всех видов Ubuntu и производных (Linux Mint, Elementary OS и т.д.).
Доступна для Ubuntu 17.04 Zesty/16.10 Yakkety/16.04 Xenial/14.04 Trusty/12.04 Precise/Linux Mint 18/17/13/и других производных Ubuntu.
Для установки следующие команды:
sudo add-apt-repository ppa:teejee2008/ppa
sudo apt-get update
sudo apt-get install aptik

ЕВГЕНИЙ12 ИЮНЯ, 2017 Ответить
Я использую "Luckybackup", графическая среда для rsync!
установка: sudo add-apt-repository ppa:luckybackup-maintainers/ppa
sudo apt-get update
sudo apt-get install luckybackup

НУ что сказать, работает! Правда были проблемы с cron, в приложении есть возможность создания но не запуска)
Решил установкой "Gnome Shedule"
sudo apt-get install gnome-schedule
Sheduler подтянул задания на выполнение и всё!

АЛЕКСЕЙ12 ИЮНЯ, 2017 Ответить
А есть вариант этой проги, но не GUI? У нас X-сервер нигде не установлен.

LOSSTFAN12 ИЮНЯ, 2017 Ответить
Как же могли забыть такую простую и, в то же время, незаменимую Redo Backup ?? о_0

ОЛЕГ12 ИЮНЯ, 2017 Ответить
А почему ни слова не сказано про fsarchiver? Утилита намного лучше, удобней и понятней в эксплуатации, чем клонезилла, я только fsarchiver-ом и пользуюсь, нареканий лет за 6 работы на моей машине никаких!

ABZALACOM12 ИЮНЯ, 2017 Ответить
Имеет ли смысл делать резервную копию в Bacula Backup System в Webmin? Если да, то как? Нигде не нашел внятную инструкцию.

АЛЕКСЕЙ13 ИЮНЯ, 2017 Ответить
У Bacula есть свой же Web- интерфейс, через него обычно все и работает.

DOGFAGOR12 ИЮНЯ, 2017 Ответить
Есть же штатная Backups еще.

VLAD13 ИЮНЯ, 2017 Ответить
И Systemback...правда восстанавливать систему пока еще ни разу не пришлось, в отличие от Windows)

AL14 ИЮНЯ, 2017 Ответить
Здравствуйте! Спасибо за статью, для чайника познавательно! Скажите, а есть программы для создания бекапа по расписанию? Типа acronis

АНОНИМ6 ОКТЯБРЯ, 2018 Ответить
"РЕЗЕРВНОЕ КОПИРОВАНИЕ UNUNTU"

Мелочь, но исправьте.

ИВАН25 ОКТЯБРЯ, 2018 Ответить
Спасибо

АЛЕКСЕЙ16 МАЯ, 2019 Ответить
rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"}
можно ли папку назначения сделать на удаленную машину?

РУСЛАН28 ЯНВАРЯ, 2020 Ответить
автор, а можно поподробнее про СОЗДАНИЕ SQUASHFS ОБРАЗА пожалуйста, что бы восстановить какая полная команда будет? и откуда, не понятно ничего... опиши, если не трудно

ВИКТОР30 ЯНВАРЯ, 2020 Ответить
Зачем для 1 способа используются "$ sudo apt-get -y update $ sudo apt-get dselect-upgrade" ведь тут нет обращения к репозиториям?

СЕРГЕЙ22 МАЯ, 2020 Ответить
Способ 2. Создание архива. Корневая папка будет LiveCD, а не нашей системы, которой надо копию сделать. Надо сначала смонтировать корневой раздел нашей системы в какую либо папку внутри mnt (например, mount/root), а уже потом этот раздел копировать в файл на флешке или внешнем жестком диске. Но тогда встает другая проблема. В архивный файл попадет структура mnt/root и при разархивировании будет не корневой раздел а mount/root/корневой_раздел

SUDO4 ИЮНЯ, 2020 Ответить
В начале статьи добавьте, перед:
sudo dpkg --set-selections < backup.txt
выполнить:
sudo apt-get install dselect && sudo dselect update

РОМАН12 МАЯ, 2021 Ответить
Добрый день! Данный способ не сработал.
sudo tar czf /backup.tar.gz --exclude=/backup.tar.gz --exclude=/home --exclude=/media --exclude=/dev --exclude=/mnt --exclude=/proc --exclude=/sys --exclude=/tmp /


SERGEY26 ИЮНЯ, 2021 Ответить
Друзья, проблема. Автоматическое сохранение (бэкап) сохранил базы данных в формате .ZST
Phpmyadmin у меня их восстанавливать отказывается. Других сохранений из DB нет. Что делать? Как правильно впихнуть в базу данных информацию из них? Действую с Ubuntu Server


