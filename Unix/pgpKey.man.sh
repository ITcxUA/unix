

## Ключи PGP и SSH на Yubikey NEO
## 2 января 2015 г.Оставить комментарийПерейти к комментариям
## С наступлением нового года я решил, что пора сделать новый ключ PGP. Я хотел оставить этот ключ на Yubikey NEO и NEO-n для повседневного использования. Благодаря использованию аппаратных токенов, таких как Yubikey, личные ключи PGP никогда не нужно хранить на моем компьютере. Ключи PGP на Yubikey также могут использоваться для аутентификации с открытым ключом SSH.

## Мой текущий ключ PGP всегда можно найти на https://www.esev.com/pgp.key .

## Мастер-ключи, подключи и идентификаторы пользователей
## Ключи OpenPGP обычно состоят из трех частей: один главный ключ, один или несколько подключей и один или несколько идентификаторов пользователей.

## Мастер-ключ - самый важный ключ. Наличие закрытой половины главного ключа доказывает, что вы владеете ключом OpenPGP. Главный ключ используется для добавления / удаления подключей, а также для подписи / сертификации чужих ключей. Для повседневной подписи и шифрования не требуется наличие главного ключа. Если возможно, главный ключ следует хранить в автономном режиме и использовать только при добавлении или отзыве подключей или при сертификации ключа PGP другого лица.

## Подключи упрощают обслуживание ключа OpenPGP. Подключи могут использоваться для подписи данных, шифрования данных и / или для аутентификации. Время жизни и цель (шифрование, подпись, аутентификация) подключей контролируются главным ключом. Подключи могут быть добавлены и удалены из ключа PGP в любое время владельцем главного ключа.

## Подключи можно установить на компьютер, у которого нет доступа к главному ключу. На этом компьютере подключи будут использоваться для шифрования / дешифрования и подписи. Если подключи (или компьютер) когда-либо будут украдены, главный ключ может быть использован для отзыва украденных подключей и для добавления новых подключей к ключу PGP. Все это можно сделать без создания нового ключа PGP, если главный ключ также не был украден.

## Дополнительную информацию о подразделах см. На вики-странице Debian о подразделах .

## Идентификаторы пользователей используются для идентификации владельца ключа OpenPGP. Идентификатор пользователя обычно содержит имя и адрес электронной почты человека, владеющего ключом PGP. Идентификаторы пользователей добавляются к ключу PGP с помощью главного ключа. Когда другой человек подписывает ваш ключ PGP, он подписывает и открытый главный ключ, и части идентификатора пользователя ключа PGP.

## Генерация мастер-ключа:
## Обычно при генерации ключа OpenPGP с помощью GnuPG создается главный ключ, а ключ шифрования добавляется как подключ. Мастер-ключ может подписывать данные и удостоверять (подписывать) подключи; а подключ шифрования используется для получения зашифрованных сообщений. В приведенном ниже примере показано, как выглядит ключ при выборе значений по умолчанию при создании ключа.

## pub 2048R / AAAAAAAA истекает: 2 года использования: SC  
## sub 2048R / BBBBBBBB истекает: 2 года использования: E
## В приведенном выше примере AAAAAAAA является главным ключом. Его использование установлено , чтобы ключ S IGN данных и Си ertify подразделов. BBBBBBBB является подразделом ограничивается используется только для E ncryption.

## Я действительно не хочу, чтобы мой главный ключ хранился на Yubikey, потому что, если Yubikey будет утерян или мой ноутбук украден, мне придется отозвать главный ключ и воссоздать новый ключ PGP. Вместо этого я собираюсь сгенерировать и сохранить главный ключ на автономном USB-накопителе, который будет храниться в месте, доступном только мне.

## pub 3072R / AAAAAAAA истекает: 1 год использования: C
## Я также удалил возможность для главного ключа подписывать данные. Я не планирую иметь главный ключ доступным для повседневного использования и хочу, чтобы главный ключ использовался только для сертификации / отзыва подключей и для сертификации PGP-ключей других людей. Для создания такого ключа требуется использование флага –expert для GnuPG.

## # Обязательно сохраните мастер-ключ на USB-накопителе
## > mv .gnupg .gnupg.orig
## > ln -s / media / USB .gnupg

## # Настройте GnuPG на предпочтение надежных алгоритмов хеширования и шифрования
## echo "cert-digest-algo SHA512" >> .gnupg / gpg.conf
## echo "список предпочтений по умолчанию SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP без сжатия" >> .gnupg / gpg.conf

## > gpg --expert --gen-key
## Пожалуйста, выберите, какой тип ключа вы хотите:
##    (1) RSA и RSA (по умолчанию)
##    (2) DSA и Эльгамал
##    (3) DSA (только подпись)
##    (4) RSA (только знак)
##    (7) DSA (установите свои возможности)
##    (8) RSA (установите свои возможности)
## Ваш выбор? 8

## Возможные действия для ключа RSA: подписать, подтвердить, зашифровать, аутентифицировать
## Текущие разрешенные действия: Подтвердить

##    (S) Переключить возможность знака
##    (E) Переключить возможность шифрования
##    (A) Переключить возможность аутентификации
##    (Q) Готово 

## Ваш выбор? s
## Ваш выбор? е
## Ваш выбор? q

## Ключи RSA могут иметь длину от 1024 до 4096 бит.
## Какой размер ключа вам нужен? (2048) 3072
## Запрошенный размер ключа - 3072 бита
## Пожалуйста, укажите срок действия ключа.
##          0 = срок действия ключа не истекает
##         = срок действия ключа истекает через n дней
##       w = срок действия ключа истекает через n недель
##       m = срок действия ключа истекает через n месяцев
##       y = срок действия ключа истекает через n лет
## Ключ действителен для? (0) 1г
## Срок действия ключа истекает в пятницу, 1 января 2016 г., 19:15:54 PST
## Это правильно? (г / н) г

## GnuPG необходимо создать идентификатор пользователя для идентификации вашего ключа.

## Настоящее имя: Эрик Северанс
## Электронный адрес: esev@esev.com
## Комментарий:
## Вы выбрали этот USER-ID:
##     "Эрик Северанс <esev@esev.com>"

## Изменить (N) сообщение, (C) сообщение, (E) почту или (O) kay / (Q) uit? о

## открытый и секретный ключи созданы и подписаны.
## pub 3072R / B8EFD59D 02.01.2015 [истекает: 02.01.2016]
##       Отпечаток ключа = 856B 1F1C EAD0 1FE4 5C4C 6E97 961F 708D B8EF D59D
## uid Эрик Северанс <esev@esev.com>
## Теперь, когда у вас есть главный ключ, рекомендуется создать сертификат отзыва. Если вы когда-нибудь потеряете свой ключ PGP или забудете парольную фразу, вы можете опубликовать сертификат отзыва, чтобы сообщить другим, что ваш ключ больше не используется.

## > gpg --gen-revoke B8EFD59D> /media/USB/B8EFD59D-revocation-certificate.asc

## Создать сертификат отзыва для этого ключа? (г / н) г
## Выберите причину отзыва:         
##   0 = Причина не указана
##   1 = Ключ был взломан
##   2 = ключ заменен
##   3 = Ключ больше не используется
##   Q = Отмена
## (Вероятно, вы хотите выбрать здесь 1)
## Ваше решение? 3
## Введите необязательное описание; завершите его пустой строкой:
## > Использование сертификата отзыва, созданного при использовании ключа B8EFD59D.
## > Первый создал. Очень вероятно, что я потерял доступ к
## > закрытый ключ.
## > 
## Причина отзыва: ключ больше не используется
## Использование сертификата отзыва, созданного при использовании ключа B8EFD59D.
## первый создан. Очень вероятно, что я потерял доступ к
## закрытый ключ.
## Это нормально? (г / н) г
##                      
## Армированный вывод ASCII принудительно.
## Сертификат отзыва создан.

## Переместите его на среду, которую вы можете скрыть; если Мэллори получит
## доступ к этому сертификату он может использовать, чтобы сделать ваш ключ непригодным для использования.
## Разумно распечатать этот сертификат и хранить его на всякий случай.
## ваши СМИ становятся нечитаемыми. Но будьте осторожны: система печати
## ваша машина может хранить данные и делать их доступными для других!
## Создание подраздела шифрования
## Следующим шагом будет создание подраздела шифрования. Я решил сгенерировать ключ шифрования с помощью GnuPG, а не с помощью Yubikey по нескольким причинам.

## Закрытые ключи, созданные на Yubikey, не могут быть удалены из Yubikey. Это дает преимущество, заключающееся в том, что закрытый ключ никогда не находится на компьютере физически, но также имеет недостаток, заключающийся в том, что доступ ко всем зашифрованным данным теряется, если Yubikey когда-либо был украден или утерян или был создан новый ключ.
## У меня несколько Yubikey, и я хотел бы, чтобы все они использовали один и тот же ключ шифрования. Если бы у каждого Yubikey был свой собственный ключ шифрования, людям нужно было бы выбрать, какой ключ использовать при отправке зашифрованных сообщений (или не забудьте выбрать все ключи). На принимающей стороне мне нужно было бы убедиться, что у меня подключен правильный Yubikey при расшифровке сообщения. Наличие единого ключа шифрования позволяет избежать этих проблем.
## > gpg - клавиша редактирования B8EFD59D

## gpg> addkey
## Пожалуйста, выберите, какой тип ключа вы хотите:
##    (3) DSA (только подпись)
##    (4) RSA (только знак)
##    (5) Эльгамал (только шифрование)
##    (6) RSA (только шифрование)
## Ваш выбор? 6
## Ключи RSA могут иметь длину от 1024 до 4096 бит.
## Какой размер ключа вам нужен? (2048)
## Запрошенный размер ключа составляет 2048 бит
## Пожалуйста, укажите срок действия ключа.
##          0 = срок действия ключа не истекает
##         = срок действия ключа истекает через n дней
##       w = срок действия ключа истекает через n недель
##       m = срок действия ключа истекает через n месяцев
##       y = срок действия ключа истекает через n лет
## Ключ действителен для? (0) 1г
## Срок действия ключа истекает в пятницу, 1 января 2016 г., 19:23:39 PST
## Это правильно? (г / н) г
## Действительно создать? (г / н) г

## pub 3072R / B8EFD59D создан: 2015-01-02 истекает: 2016-01-02 использование: C   
##                      доверие: окончательная достоверность: окончательная
## sub 2048R / EE86E896 создан: 2015-01-02 истекает: 2016-01-02 использование: E   
## [окончательный] (1). Эрик Северанс <esev@esev.com>

## gpg> сохранить
## Сделайте резервную копию секретных ключей
## Ключ шифрования был последним ключом, который будет сгенерирован GnuPG. Остальные ключи будут сгенерированы непосредственно на Yubikey. Импорт ключа шифрования в Yubikey - деструктивный процесс. Он удалит секретный ключ из связки ключей GnuPG. Это хорошее время, чтобы сделать резервную копию секретных ключей.

## > gpg --export-secret-key B8EFD59D> \
##     /media/USB/B8EFD59D-2015-01-01-EE86E896-secret.pgp
## Создайте подключи для подписи и аутентификации
## Подключи для подписи и аутентификации будут уникальными для каждого Yubikey. Это позволяет создавать подключи непосредственно на Yubikey, где к закрытому ключу нельзя получить доступ с компьютера.

## Перед использованием GnuPG с Yubikey загрузите инструмент ykpersonalize и убедитесь, что флаг извлечения установлен на 82 для совместимости с OTP и CCID.

## > ykpersonalize -m82
## Версия прошивки 3.3.0 Touch level 1290 Последовательность программ 2

## Будет установлен режим USB: 0x82

## Сделать? (y / n) [n]: y
## Мне нравится удалять секретный ключ GnuPG и повторно импортировать его из резервной копии каждый раз, когда я инициализирую Yubikey. Это гарантирует наличие главного ключа и ключа шифрования в связке секретных ключей GnuPG.

## # Обновить секретный брелок GnuPG из резервной копии
## > gpg --delete-secret-key B8EFD59D
## > gpg --import </media/USB/B8EFD59D-2015-01-01-EE86E896-secret.pgp

## > gpg - клавиша редактирования B8EFD59D

## # Сначала создайте ключ подписи
## gpg> addcardkey

##  Ключ подписи ....: [нет]
##  Ключ шифрования ....: [нет]
##  Ключ аутентификации: [нет]

## Выберите тип ключа для генерации:
##    (1) Ключ для подписи
##    (2) Ключ шифрования
##    (3) Ключ аутентификации
## Ваш выбор? 1

## Пожалуйста, укажите срок действия ключа.
##          0 = срок действия ключа не истекает
##         = срок действия ключа истекает через n дней
##       w = срок действия ключа истекает через n недель
##       m = срок действия ключа истекает через n месяцев
##       y = срок действия ключа истекает через n лет
## Ключ действителен для? (0) 1г
## Срок действия ключа истекает в пятницу 1 января, 22:08:14 2016 PST
## Это правильно? (г / н) г
## Действительно создать? (г / н) г  
##                       
## pub 3072R / B8EFD59D создан: 2015-01-02 истекает: 2016-01-02 использование: C   
##                      доверие: окончательная достоверность: окончательная
## sub 2048R / EE86E896 создан: 2015-01-02 истекает: 2016-01-02 использование: E   
## sub 2048R / 79BF574F создан: 2015-01-02 истекает: 2016-01-02 использование: S   
## [окончательный] (1). Эрик Северанс <esev@esev.com>

## # Сделайте то же самое для ключа аутентификации
## gpg> addcardkey

##  Ключ для подписи ....: 546D 6A7E EB4B 5B07 B3EA 7373 12E2 68AD 79BF 574F
##  Ключ шифрования ....: [нет]
##  Ключ аутентификации: [нет]

## Выберите тип ключа для генерации:
##    (1) Ключ для подписи
##    (2) Ключ шифрования
##    (3) Ключ аутентификации
## Ваш выбор? 3
##                  
## Пожалуйста, укажите срок действия ключа.
##          0 = срок действия ключа не истекает
##         = срок действия ключа истекает через n дней
##       w = срок действия ключа истекает через n недель
##       m = срок действия ключа истекает через n месяцев
##       y = срок действия ключа истекает через n лет
## Ключ действителен для? (0) 1г
## Срок действия ключа истекает 1 января, 22:09:41 2016 PST
## Это правильно? (г / н) г
## Действительно создать? (г / н) г  
##                       
## pub 3072R / B8EFD59D создан: 2015-01-02 истекает: 2016-01-02 использование: C   
##                      доверие: окончательная достоверность: окончательная
## sub 2048R / EE86E896 создан: 2015-01-02 истекает: 2016-01-02 использование: E   
## sub 2048R / 79BF574F создан: 2015-01-02 истекает: 2016-01-02 использование: S   
## sub 2048R / 934AE2EE создан: 2015-01-02 истекает: 2016-01-02 использование: A   
## [окончательный] (1). Эрик Северанс <esev@esev.com>

## # Используйте переключатель и ключ, чтобы выбрать закрытый ключ шифрования
## gpg> переключить
## gpg> ключ 1
##           
## сек 3072R / B8EFD59D создано: 2015-01-02 истекает: 2016-01-02
## ssb * 2048R / EE86E896 создано: 2015-01-02 истекает: никогда     
## ssb 2048R / 79BF574F создан: 2015-01-02 истекает: 2016-01-02
##                      номер карты: 0006 12345678
## ssb 2048R / 934AE2EE создан: 2015-01-02 срок действия: 2016-01-02
##                      номер карты: 0006 12345678
## (1) Эрик Северанс <esev@esev.com>

## # Затем переместите ключ шифрования из связки ключей GnuPG в Yubikey
## gpg> карта-ключ
##  Ключ для подписи ....: 546D 6A7E EB4B 5B07 B3EA 7373 12E2 68AD 79BF 574F
##  Ключ шифрования ....: [нет]
##  Ключ аутентификации: DCE4 7FEA 4A72 E525 681C 6207 662E 5CA8 934A E2EE

## Выберите, где хранить ключ:
##    (2) Ключ шифрования
## Ваш выбор? 2
##                  
## сек 3072R / B8EFD59D создано: 2015-01-02 истекает: 2016-01-02
## ssb * 2048R / EE86E896 создано: 2015-01-02 истекает: никогда     
##                      номер карты: 0006 12345678
## ssb 2048R / 79BF574F создан: 2015-01-02 истекает: 2016-01-02
##                      номер карты: 0006 12345678
## ssb 2048R / 934AE2EE создан: 2015-01-02 срок действия: 2016-01-02
##                      номер карты: 0006 12345678
## (1) Эрик Северанс <esev@esev.com>
## gpg> сохранить
## Повторите те же шаги для каждого Yubikey, который будет использоваться с этим ключом OpenPGP.

## Сохранить и распространить открытый ключ OpenPGP
## Когда был создан главный ключ, и каждый раз, когда создавался подключ, также генерировался открытый и закрытый ключ RSA. Закрытые ключи должны оставаться на USB-накопителе и на Yubikey.

## Открытые ключи следует распространять в том месте, где их могут найти другие. Я предпочитаю загружать их на свой веб-сайт, но в качестве альтернативы я могу загрузить их на открытый сервер ключей .

## После того, как место выбрано, рекомендуется встроить его в ключ PGP. Таким образом, пользователи будут знать, где найти версию ключа с самыми последними подписями, подключами и отзывами. GnuPG также может автоматически получить последнюю версию ключа с помощью –refresh-keys, если расположение встроено в ключ. Команда сервера ключей вставляет URL-адрес этого ключа в открытый ключ PGP.

## > gpg - клавиша редактирования B8EFD59D

## gpg> сервер ключей
## Введите предпочитаемый URL-адрес сервера ключей: https://www.esev.com/static/B8EFD59D.asc

## gpg> showpref
## [окончательный] (1). Эрик Северанс <esev@esev.com>
##      Шифр: AES256, AES192, AES, CAST5, 3DES
##      Дайджест: SHA512, SHA384, SHA256, SHA224, SHA1
##      Сжатие: ZLIB, BZIP2, ZIP, без сжатия
##      Особенности: MDC, без модификации сервера ключей
##      Предпочтительный сервер ключей: https://www.esev.com/static/B8EFD59D.asc

## gpg> сохранить

## # Резервное копирование открытого ключа
## > gpg --armor --export B8EFD59D> B8EFD59D.asc

## # Загрузить на сайт
## #> scp B8EFD59D.asc пользователь @ сервер: public_html / static / B8EFD59D.asc

## # Или загрузите на сервер ключей
## > gpg --keyserver hkps: //hkps.pool.sks-keyservers.net --send-key B8EFD59D
## Удалите мастер-ключ и обновите Yubikey
## На этом этапе USB-накопитель можно отключить и восстановить исходный каталог .gnupg.

## # Удаляем символическую ссылку, указывающую на / media / USB
## > rm .gnupg

## # Заменить исходный каталог
## > mv .gnupg.orig .gnupg
## Следующим шагом является изменение PIN-кодов Yubikey и импорт открытого ключа.

## > gpg --card-edit

## Идентификатор приложения ...: D2760001240102000006123456780000
## Версия ..........: 2.0
## Производитель .....: Yubico
## Серийный номер ....: 12345678
## Имя держателя карты: [не указано]
## Языковые настройки ...: [не задано]
## Пол ..............: не указан
## URL открытого ключа: [не задан]
## Данные для входа .......: [не задано]
## PIN-код подписи ....: не принудительно
## Ключевые атрибуты ...: 2048R 2048R 2048R
## Максимум. Длина PIN: 127 127 127
## Счетчик повторных попыток ввода PIN-кода: 3 3 3
## Счетчик подписей: 2
## Ключ для подписи ....: 546D 6A7E EB4B 5B07 B3EA 7373 12E2 68AD 79BF 574F
##       создано ....: 2015-01-02 06:08:04
## Ключ шифрования ....: 2D45 A494 1428 C03C 45A9 47C0 19C9 D37E EE86 E896
##       создано ....: 2015-01-02 03:23:39
## Ключ аутентификации: DCE4 7FEA 4A72 E525 681C 6207 662E 5CA8 934A E2EE
##       создано ....: 2015-01-02 06:09:40
## Общая ключевая информация ..: [нет]

## gpg / card> admin
## Команды администратора разрешены

## # Изменить PIN-код и PIN-коды администратора
## gpg / card> пароль
## gpg: номер карты OpenPGP. D2760001240102000006123456780000 обнаружен

## 1 - сменить ПИН
## 2 - разблокировать PIN
## 3 - изменить PIN-код администратора
## 4 - установить код сброса
## Q - выйти

## Ваш выбор? 1
## PIN изменен.     

## 1 - сменить ПИН
## 2 - разблокировать PIN
## 3 - изменить PIN-код администратора
## 4 - установить код сброса
## Q - выйти

## Ваш выбор? 3
## PIN изменен.     

## 1 - сменить ПИН
## 2 - разблокировать PIN
## 3 - изменить PIN-код администратора
## 4 - установить код сброса
## Q - выйти

## Ваш выбор? q

## # Убедитесь, что PIN-код введен перед подписанием
## gpg / card> forceig

## # Установить URL-адрес, по которому можно найти открытый ключ OpenPGP.
## gpg / card> url
## URL для получения открытого ключа: https://www.esev.com/static/B8EFD59D.asc

## # Получить открытый ключ в локальную связку ключей
## gpg / card> получить
##                                                           
## gpg / card> выйти

## # Наконец, заполните секретный брелок ключами-заглушками, указывающими на Yubikey
## > gpg --card-status
## Идентификатор приложения ...: D2760001240102000006123456780000
## Версия ..........: 2.0
## Производитель .....: Yubico
## Серийный номер ....: 12345678
## Имя держателя карты: [не указано]
## Языковые настройки ...: [не задано]
## Пол ..............: не указан
## URL открытого ключа: https://www.esev.com/static/B8EFD59D.asc
## Данные для входа .......: [не задано]
## ПИН-код подписи ....: принудительно
## Ключевые атрибуты ...: 2048R 2048R 2048R
## Максимум. Длина PIN: 127 127 127
## Счетчик повторных попыток ввода PIN-кода: 3 3 3
## Счетчик подписей: 2
## Ключ для подписи ....: 546D 6A7E EB4B 5B07 B3EA 7373 12E2 68AD 79BF 574F
##       создано ....: 2015-01-02 06:08:04
## Ключ шифрования ....: 2D45 A494 1428 C03C 45A9 47C0 19C9 D37E EE86 E896
##       создано ....: 2015-01-02 03:23:39
## Ключ аутентификации: DCE4 7FEA 4A72 E525 681C 6207 662E 5CA8 934A E2EE
##       создано ....: 2015-01-02 06:09:40
## Общая ключевая информация ..: pub 2048R / 79BF574F 02.01.2015 Эрик Северанс <esev@esev.com>
## sec # 3072R / B8EFD59D создано: 2015-01-02 истекает: 2016-01-02
## ssb> 2048R / EE86E896 создано: 2015-01-02 истекает: 2016-01-02
##                       номер карты: 0006 12345678
## ssb> 2048R / 79BF574F создан: 2015-01-02 истекает: 2016-01-02
##                       номер карты: 0006 12345678
## ssb> 2048R / 934AE2EE создано: 2015-01-02 истекает: 2016-01-02
##                       номер карты: 0006 12345678
## Обратите внимание на то, что главный ключ имеет «sec #». Знак «#» в конце означает, что закрытый ключ отсутствует. Он хранится на USB-накопителе (который теперь следует извлечь и сохранить в безопасном месте). Вы также можете проверить это с помощью gpg -K

## > gpg -K
## sec # 3072R / B8EFD59D 02.01.2015 [истекает: 02.01.2016]
## uid Эрик Северанс <esev@esev.com>
## ssb> 2048R / EE86E896 2015-01-02
## ssb> 2048R / 79BF574F 2015-01-02
## ssb> 2048R / 934AE2EE 2015-01-02
## Настроить SSH аутентификацию
## Вы могли заметить, что на Yubikey был создан отдельный подключ для аутентификации. Подраздел аутентификации можно использовать с OpenSSH для входа на сервер с аутентификацией с открытым ключом. GnuPG gpg-agent имеет флаг –enable-ssh-support, который позволяет ему работать как ssh-agent.

## > gpg-agent --daemon --enable-ssh-support --write-env-file ~ / .gpg-agent-info
## GPG_AGENT_INFO = / tmp / gpg-Z74lEJ / S.gpg-agent: 25585: 1; экспорт GPG_AGENT_INFO;
## SSH_AUTH_SOCK = / tmp / gpg-KS5kJr / S.gpg-agent.ssh; экспорт SSH_AUTH_SOCK;
## SSH_AGENT_PID = 25585; экспорт SSH_AGENT_PID;
## Скопируйте и вставьте переменные среды в свой терминал, чтобы включить поддержку gpg-agent. Переменные также хранятся в ~ / .gpg-agent-info, который можно получить в .bash_profile при входе в систему.

## Открытые ключи OpenPGP можно преобразовать в открытые ключи SSH с помощью gpgkey2ssh. Укажите идентификатор подраздела аутентификации при запуске gpgkey2ssh.

## > gpgkey2ssh 934AE2EE
## ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAA ... oSFl8ZpqJ КОММЕНТАРИЙ
## Затем этот ключ можно добавить в ~ / .ssh / authorized_keys на удаленном сервере. Закрытый ключ, хранящийся на Yubikey, будет использоваться при подключении к удаленному серверу.

## Основные размеры и срок действия
## В настоящее время 2048-битный ключ - это самый большой размер ключа, поддерживаемый Yubikey. По словам Дигисерта, 2048-битные ключи RSA достаточно надежны, чтобы прослужить дольше, чем срок службы. На странице Digicert « Сила сертификата SSL » есть видео и ссылка на математику, лежащую в основе этой логики.

## Я надеюсь, что никогда не придется создавать новый мастер-ключ. Я увеличил размер главного ключа до 3072 бита, что рекомендовано NIST в SP 800-57, часть 1 , для ключей, срок службы которых истекает после 2031 года.

## С помощью GnuPG можно сгенерировать 4096-битные ключи RSA, но несколько источников в списке рассылки GnuPG предположили, что ключи RSA, превышающие 3072 бит, не добавляют особой дополнительной безопасности, чтобы оправдать требуемые дополнительные ресурсы ЦП. Более 3072 битов лучше использовать ключи Elliptic Curve (EC / ECC) вместо RSA. К сожалению, сегодня ключи ECC широко не поддерживаются в OpenGPG. Возможно, к 2031 году мы будем использовать ключи ECC в OpenPGP, и тогда будет смысл сгенерировать новый ключ.

## Я выбрал срок жизни ключа в один год, основываясь на некоторых передовых методах работы с ключами OpenPGP . Есть и другие, кто выступал за неизменные главные ключи , но я думаю, что установка срока действия главного ключа побудит пользователей обновлять ключ не реже одного раза в год, чтобы получать новые / отозванные подключи.

## Дополнительные ресурсы
## Веб-сайт Yubico для моделей Yubikey NEO и NEO-n
## Страница Yubico о Yubikey NEO и OpenPGP
## Публикация с практическими рекомендациями на форуме Yubico об аутентификации Yubikey NEO, OpenPGP, OpenSSH описывает более подробную информацию о том, как настроить это на Mac
## Еще одно упоминание Томаса Хабетса о GPG и SSH с Yubikey NEO .
## Страница справочника GnuPG по управлению ключами OpenPGP .
## OpenPGP смарт - карты , альтернатива Yubikey для хранения ключей OpenPGP в аппаратных маркеров.
## Вики Debian для подключей имеет хорошие ресурсы для создания подключей и использования их вместо главного ключа.

## ##============ ≠≠≠≠ ============

## PGP and SSH keys on a Yubikey NEO
## January 2nd, 2015Leave a commentGo to comments
## With the new year, I decided it was time to make a new PGP key. I wanted to keep this key on a Yubikey NEO and NEO-n for every day use. By using hardware tokens like the Yubikey, the private PGP keys never need to be stored on my computer. The PGP keys on the Yubikey can also be used for SSH public-key authentication.

## My current PGP key can always be found at https://www.esev.com/pgp.key.

## Master keys, Subkeys, and User IDs
## OpenPGP keys normally have three parts: a single master key, one or more subkeys, and one or more user ids.

## The master key is the most important key. Having the private half of the master key proves that you own the OpenPGP key. The master key is used to add/remove subkeys as well as to sign/certify other people’s keys. You don’t need to have the master key present for everyday signing and encryption. If possible, the master key should be kept offline and only used when adding or revoking subkeys or when certifying another person’s PGP key.

## Subkeys make maintenance of a OpenPGP key easier. Subkeys can be used for signing data, encrypting data, and/or for authentication. The lifetime and purpose (encrypt,sign,authenticate) of a subkey is controlled by the master key. Subkeys can be added and removed from the PGP key at any time by the owner of the master key.

## Subkeys can be installed on a computer that does not have access to the master key. On that computer, the subkeys will be used for encryption/decryption and signing. If the subkeys (or computer) are ever stolen, the master key can then be used to revoke the stolen subkeys and to add new subkeys to the PGP key. This can all be done without generating a new PGP key as long as the master key was not also stolen.

## For more information about subkeys, see the Debian wiki page about Subkeys.

## User IDs are used to identify the owner of the OpenPGP key. The User ID normally contains the name and email address of the person who owns the PGP key. User IDs are added to a PGP key using the master key. When another person signs your PGP key, they sign both the public master key and the User ID parts of the PGP key.

## Generating the master key:
## Normally, when generating an OpenPGP key with GnuPG, a master key is created and an encryption key is added as a subkey. The master key can sign data and certify (sign) subkeys; and the encryption subkey is used to receive encrypted messages. The example below shows what the key looks like when choosing the defaults when creating the key.

## pub  2048R/AAAAAAAA expires: 2y usage: SC  
## sub  2048R/BBBBBBBB expires: 2y usage: E
## In the example above, AAAAAAAA is the master key. Its usage is set to allow the key to Sign data and Certify subkeys. BBBBBBBB is a subkey restricted to being used only for Encryption.

## I don’t really want my master key stored on the Yubikey because if the Yubikey is lost, or my laptop stolen, I would have to revoke the master key and recreate a new PGP key. Instead, I’m going to generate and store the master key on a offline USB drive that is kept in a location that only I can access.

## pub 3072R/AAAAAAAA expires: 1y usage: C
## I’ve also removed the ability for the master key to sign data. I don’t plan to have the master key available for daily use and only want the master key to be used for certifying/revoking subkeys and for certifying other people’s PGP keys. Generating the key like this requires the use of the –expert flag for GnuPG.

## # Make sure to store the master key on the USB drive
## > mv .gnupg .gnupg.orig
## > ln -s /media/USB .gnupg

## # Set GnuPG to prefer strong hash and encryption algorithms
## echo "cert-digest-algo SHA512" >> .gnupg/gpg.conf
## echo "default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed" >> .gnupg/gpg.conf

## > gpg --expert --gen-key
## Please select what kind of key you want:
##    (1) RSA and RSA (default)
##    (2) DSA and Elgamal
##    (3) DSA (sign only)
##    (4) RSA (sign only)
##    (7) DSA (set your own capabilities)
##    (8) RSA (set your own capabilities)
## Your selection? 8

## Possible actions for a RSA key: Sign Certify Encrypt Authenticate
## Current allowed actions: Certify

##    (S) Toggle the sign capability
##    (E) Toggle the encrypt capability
##    (A) Toggle the authenticate capability
##    (Q) Finished 

## Your selection? s
## Your selection? e
## Your selection? q

## RSA keys may be between 1024 and 4096 bits long.
## What keysize do you want? (2048) 3072
## Requested keysize is 3072 bits
## Please specify how long the key should be valid.
##          0 = key does not expire
##         = key expires in n days
##       w = key expires in n weeks
##       m = key expires in n months
##       y = key expires in n years
## Key is valid for? (0) 1y
## Key expires at Fri 01 Jan 2016 07:15:54 PM PST
## Is this correct? (y/N) y

## GnuPG needs to construct a user ID to identify your key.

## Real name: Eric Severance
## Email address: esev@esev.com
## Comment:
## You selected this USER-ID:
##     "Eric Severance <esev@esev.com>"

## Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? o

## public and secret key created and signed.
## pub   3072R/B8EFD59D 2015-01-02 [expires: 2016-01-02]
##       Key fingerprint = 856B 1F1C EAD0 1FE4 5C4C  6E97 961F 708D B8EF D59D
## uid                  Eric Severance <esev@esev.com>
## Now that you have the master key, it’s good practice to create a revocation certificate. If you ever lose your PGP key, or forget the passphrase, you can use publish the revocation certificate to inform others that your key is no longer in use.

## > gpg --gen-revoke B8EFD59D > /media/USB/B8EFD59D-revocation-certificate.asc

## Create a revocation certificate for this key? (y/N) y
## Please select the reason for the revocation:         
##   0 = No reason specified
##   1 = Key has been compromised
##   2 = Key is superseded
##   3 = Key is no longer used
##   Q = Cancel
## (Probably you want to select 1 here)
## Your decision? 3
## Enter an optional description; end it with an empty line:
## > Using revocation certificate that was generated when key B8EFD59D was
## > first created.  It is very likely that I have lost access to the
## > private key.
## > 
## Reason for revocation: Key is no longer used
## Using revocation certificate that was generated when key B8EFD59D was
## first created.  It is very likely that I have lost access to the
## private key.
## Is this okay? (y/N) y
##                      
## ASCII armored output forced.
## Revocation certificate created.

## Please move it to a medium which you can hide away; if Mallory gets
## access to this certificate he can use it to make your key unusable.
## It is smart to print this certificate and store it away, just in case
## your media become unreadable.  But have some caution:  The print system of
## your machine might store the data and make it available to others!
## Generating the encryption subkey
## The next step is to create an encryption subkey. I chose to generate the encryption key using GnuPG, rather than with the Yubikey for a couple of reasons.

## Private keys that are generated on the Yubikey cannot be removed from the Yubikey. This has a benefit that the private key is never physically on the computer, but it also has the disadvantage that access to all encrypted data is lost if the Yubikey is ever stolen or lost or a new key is generated.
## I have multiple Yubikeys and I would like them all to share the same encryption key. If each Yubikey had its own encryption key then people would need to choose which key to use when sending encrypted messages (or remember to choose all keys). On the receiving side, I would need to make sure I have the correct Yubikey plugged in when decrypting a message. Having a single encryption key avoids these issues.
## > gpg --edit-key B8EFD59D

## gpg> addkey
## Please select what kind of key you want:
##    (3) DSA (sign only)
##    (4) RSA (sign only)
##    (5) Elgamal (encrypt only)
##    (6) RSA (encrypt only)
## Your selection? 6
## RSA keys may be between 1024 and 4096 bits long.
## What keysize do you want? (2048)
## Requested keysize is 2048 bits
## Please specify how long the key should be valid.
##          0 = key does not expire
##         = key expires in n days
##       w = key expires in n weeks
##       m = key expires in n months
##       y = key expires in n years
## Key is valid for? (0) 1y
## Key expires at Fri 01 Jan 2016 07:23:39 PM PST
## Is this correct? (y/N) y
## Really create? (y/N) y

## pub  3072R/B8EFD59D  created: 2015-01-02  expires: 2016-01-02  usage: C   
##                      trust: ultimate      validity: ultimate
## sub  2048R/EE86E896  created: 2015-01-02  expires: 2016-01-02  usage: E   
## [ultimate] (1). Eric Severance <esev@esev.com>

## gpg> save
## Make a backup of the secret keys
## The encryption key was the last key that will be generated with GnuPG. The remaining keys will be generated directly on the Yubikey. Importing the encryption key into the Yubikey is a destructive process. It will remove the secret key from the GnuPG keyring. This is a good time to make a backup of the secret keys.

## > gpg --export-secret-key B8EFD59D > \
##     /media/USB/B8EFD59D-2015-01-01-EE86E896-secret.pgp
## Generate the signing and authentication subkeys
## The subkeys for signing and authentication will be unique for each Yubikey. This allows the subkeys to be generated directly on the Yubikey, where the private key cannot be accessed from the computer.

## Before using GnuPG with the Yubikey, download the ykpersonalize tool and make sure the eject flag is set to 82 for OTP and CCID compatibility.

## > ykpersonalize -m82
## Firmware version 3.3.0 Touch level 1290 Program sequence 2

## The USB mode will be set to: 0x82

## Commit? (y/n) [n]: y
## I like to delete the GnuPG secret key and reimport it from a backup each time I initialize the Yubikey. This makes sure the master and encryption keys are present in the GnuPG secret keyring.

## # Refresh the GnuPG secret keyring from the backup
## > gpg --delete-secret-key B8EFD59D
## > gpg --import < /media/USB/B8EFD59D-2015-01-01-EE86E896-secret.pgp

## > gpg --edit-key B8EFD59D

## # First, create the signing key
## gpg> addcardkey

##  Signature key ....: [none]
##  Encryption key....: [none]
##  Authentication key: [none]

## Please select the type of key to generate:
##    (1) Signature key
##    (2) Encryption key
##    (3) Authentication key
## Your selection? 1

## Please specify how long the key should be valid.
##          0 = key does not expire
##         = key expires in n days
##       w = key expires in n weeks
##       m = key expires in n months
##       y = key expires in n years
## Key is valid for? (0) 1y
## Key expires at Fri Jan  1 22:08:14 2016 PST
## Is this correct? (y/N) y
## Really create? (y/N) y  
##                       
## pub  3072R/B8EFD59D  created: 2015-01-02  expires: 2016-01-02  usage: C   
##                      trust: ultimate      validity: ultimate
## sub  2048R/EE86E896  created: 2015-01-02  expires: 2016-01-02  usage: E   
## sub  2048R/79BF574F  created: 2015-01-02  expires: 2016-01-02  usage: S   
## [ultimate] (1). Eric Severance <esev@esev.com>

## # Do the same for the authentication key
## gpg> addcardkey

##  Signature key ....: 546D 6A7E EB4B 5B07 B3EA  7373 12E2 68AD 79BF 574F
##  Encryption key....: [none]
##  Authentication key: [none]

## Please select the type of key to generate:
##    (1) Signature key
##    (2) Encryption key
##    (3) Authentication key
## Your selection? 3
##                  
## Please specify how long the key should be valid.
##          0 = key does not expire
##         = key expires in n days
##       w = key expires in n weeks
##       m = key expires in n months
##       y = key expires in n years
## Key is valid for? (0) 1y
## Key expires at Fri Jan  1 22:09:41 2016 PST
## Is this correct? (y/N) y
## Really create? (y/N) y  
##                       
## pub  3072R/B8EFD59D  created: 2015-01-02  expires: 2016-01-02  usage: C   
##                      trust: ultimate      validity: ultimate
## sub  2048R/EE86E896  created: 2015-01-02  expires: 2016-01-02  usage: E   
## sub  2048R/79BF574F  created: 2015-01-02  expires: 2016-01-02  usage: S   
## sub  2048R/934AE2EE  created: 2015-01-02  expires: 2016-01-02  usage: A   
## [ultimate] (1). Eric Severance <esev@esev.com>

## # Use toggle and key to select the private encryption key
## gpg> toggle
## gpg> key 1
##           
## sec  3072R/B8EFD59D  created: 2015-01-02  expires: 2016-01-02
## ssb* 2048R/EE86E896  created: 2015-01-02  expires: never     
## ssb  2048R/79BF574F  created: 2015-01-02  expires: 2016-01-02
##                      card-no: 0006 12345678
## ssb  2048R/934AE2EE  created: 2015-01-02  expires: 2016-01-02
##                      card-no: 0006 12345678
## (1)  Eric Severance <esev@esev.com>

## # Then move the encryption key from the GnuPG keyring to the Yubikey
## gpg> keytocard
##  Signature key ....: 546D 6A7E EB4B 5B07 B3EA  7373 12E2 68AD 79BF 574F
##  Encryption key....: [none]
##  Authentication key: DCE4 7FEA 4A72 E525 681C  6207 662E 5CA8 934A E2EE

## Please select where to store the key:
##    (2) Encryption key
## Your selection? 2
##                  
## sec  3072R/B8EFD59D  created: 2015-01-02  expires: 2016-01-02
## ssb* 2048R/EE86E896  created: 2015-01-02  expires: never     
##                      card-no: 0006 12345678
## ssb  2048R/79BF574F  created: 2015-01-02  expires: 2016-01-02
##                      card-no: 0006 12345678
## ssb  2048R/934AE2EE  created: 2015-01-02  expires: 2016-01-02
##                      card-no: 0006 12345678
## (1)  Eric Severance <esev@esev.com>
## gpg> save
## Repeat the same steps for each Yubikey that will be used with this OpenPGP key.

## Save and Distribute the public OpenPGP key
## When the master key was created, and each time a subkey was created, a public and private RSA key was also generated. The private keys should remain on the USB drive and on the Yubikey.

## The public keys should be distributed to a location where others can find it. I’m choosing to upload them to my website, but an alternative would be to upload them to a public keyserver.

## Once a location has been chosen, it’s a good idea to embed the location into the PGP key. That way users know where to find the version of the key with the most up-to-date signatures, subkeys, and revocations. GnuPG can also automatically fetch the latest version of the key with –refresh-keys if the location is embedded within the key. The keyserver command embeds a URL to this key within the public PGP key.

## > gpg --edit-key B8EFD59D

## gpg> keyserver
## Enter your preferred keyserver URL: https://www.esev.com/static/B8EFD59D.asc

## gpg> showpref
## [ultimate] (1). Eric Severance <esev@esev.com>
##      Cipher: AES256, AES192, AES, CAST5, 3DES
##      Digest: SHA512, SHA384, SHA256, SHA224, SHA1
##      Compression: ZLIB, BZIP2, ZIP, Uncompressed
##      Features: MDC, Keyserver no-modify
##      Preferred keyserver: https://www.esev.com/static/B8EFD59D.asc

## gpg> save

## # Backup the public key
## > gpg --armor --export B8EFD59D > B8EFD59D.asc

## # Upload it to the website
## # > scp B8EFD59D.asc user@server:public_html/static/B8EFD59D.asc

## # Or upload it to a keyserver
## > gpg --keyserver hkps://hkps.pool.sks-keyservers.net --send-key B8EFD59D
## Remove the master key and update the Yubikey
## At this point, the USB drive can be disconnected and the original .gnupg directory restored.

## # Remove the symlink pointing to /media/USB
## > rm .gnupg

## # Replace the original directory
## > mv .gnupg.orig .gnupg
## The next step is to change the Yubikey PINs and import the public key.

## > gpg --card-edit

## Application ID ...: D2760001240102000006123456780000
## Version ..........: 2.0
## Manufacturer .....: Yubico
## Serial number ....: 12345678
## Name of cardholder: [not set]
## Language prefs ...: [not set]
## Sex ..............: unspecified
## URL of public key : [not set]
## Login data .......: [not set]
## Signature PIN ....: not forced
## Key attributes ...: 2048R 2048R 2048R
## Max. PIN lengths .: 127 127 127
## PIN retry counter : 3 3 3
## Signature counter : 2
## Signature key ....: 546D 6A7E EB4B 5B07 B3EA  7373 12E2 68AD 79BF 574F
##       created ....: 2015-01-02 06:08:04
## Encryption key....: 2D45 A494 1428 C03C 45A9  47C0 19C9 D37E EE86 E896
##       created ....: 2015-01-02 03:23:39
## Authentication key: DCE4 7FEA 4A72 E525 681C  6207 662E 5CA8 934A E2EE
##       created ....: 2015-01-02 06:09:40
## General key info..: [none]

## gpg/card> admin
## Admin commands are allowed

## # Change the PIN and Admin PINs
## gpg/card> passwd
## gpg: OpenPGP card no. D2760001240102000006123456780000 detected

## 1 - change PIN
## 2 - unblock PIN
## 3 - change Admin PIN
## 4 - set the Reset Code
## Q - quit

## Your selection? 1
## PIN changed.     

## 1 - change PIN
## 2 - unblock PIN
## 3 - change Admin PIN
## 4 - set the Reset Code
## Q - quit

## Your selection? 3
## PIN changed.     

## 1 - change PIN
## 2 - unblock PIN
## 3 - change Admin PIN
## 4 - set the Reset Code
## Q - quit

## Your selection? q

## # Make sure the PIN is entered before signing
## gpg/card> forcesig

## # Set the URL where the OpenPGP public key can be found.
## gpg/card> url
## URL to retrieve public key: https://www.esev.com/static/B8EFD59D.asc

## # Fetch the public key into the local keyring
## gpg/card> fetch
##                                                           
## gpg/card> quit

## # Finally, populate the secret keyring with stub keys that point to the Yubikey
## > gpg --card-status
## Application ID ...: D2760001240102000006123456780000
## Version ..........: 2.0
## Manufacturer .....: Yubico
## Serial number ....: 12345678
## Name of cardholder: [not set]
## Language prefs ...: [not set]
## Sex ..............: unspecified
## URL of public key : https://www.esev.com/static/B8EFD59D.asc
## Login data .......: [not set]
## Signature PIN ....: forced
## Key attributes ...: 2048R 2048R 2048R
## Max. PIN lengths .: 127 127 127
## PIN retry counter : 3 3 3
## Signature counter : 2
## Signature key ....: 546D 6A7E EB4B 5B07 B3EA  7373 12E2 68AD 79BF 574F
##       created ....: 2015-01-02 06:08:04
## Encryption key....: 2D45 A494 1428 C03C 45A9  47C0 19C9 D37E EE86 E896
##       created ....: 2015-01-02 03:23:39
## Authentication key: DCE4 7FEA 4A72 E525 681C  6207 662E 5CA8 934A E2EE
##       created ....: 2015-01-02 06:09:40
## General key info..: pub  2048R/79BF574F 2015-01-02 Eric Severance <esev@esev.com>
## sec#  3072R/B8EFD59D  created: 2015-01-02  expires: 2016-01-02
## ssb>  2048R/EE86E896  created: 2015-01-02  expires: 2016-01-02
##                       card-no: 0006 12345678
## ssb>  2048R/79BF574F  created: 2015-01-02  expires: 2016-01-02
##                       card-no: 0006 12345678
## ssb>  2048R/934AE2EE  created: 2015-01-02  expires: 2016-01-02
##                       card-no: 0006 12345678
## Notice how the master key has “sec#”. The “#” at the end means that the private key is not present. It is stored on the USB drive (which should be removed and stored in a safe location now). You can also verify this with gpg -K

## > gpg -K
## sec#  3072R/B8EFD59D 2015-01-02 [expires: 2016-01-02]
## uid                  Eric Severance <esev@esev.com>
## ssb>  2048R/EE86E896 2015-01-02
## ssb>  2048R/79BF574F 2015-01-02
## ssb>  2048R/934AE2EE 2015-01-02
## Setup SSH authentication
## You may have noticed that a separate subkey was generated on the Yubikey for authentication. The authentication subkey can be used with OpenSSH to login to a server with public key authentication. The GnuPG gpg-agent has a flag, –enable-ssh-support, that allows it to function as a ssh-agent.

## > gpg-agent --daemon --enable-ssh-support --write-env-file ~/.gpg-agent-info
## GPG_AGENT_INFO=/tmp/gpg-Z74lEJ/S.gpg-agent:25585:1; export GPG_AGENT_INFO;
## SSH_AUTH_SOCK=/tmp/gpg-KS5kJr/S.gpg-agent.ssh; export SSH_AUTH_SOCK;
## SSH_AGENT_PID=25585; export SSH_AGENT_PID;
## Copy-and-paste the environment variables into your terminal to enable support for the gpg-agent. The variables are also stored in ~/.gpg-agent-info which can be sourced in .bash_profile when logging in.

## OpenPGP public keys can be converted into SSH public keys using gpgkey2ssh. Specify the id of the authentication subkey when running gpgkey2ssh.

## > gpgkey2ssh 934AE2EE
## ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAA ... oSFl8ZpqJ COMMENT
## This key can then be added to ~/.ssh/authorized_keys on a remote server. The private key, stored on the Yubikey, will be used when connecting to the remote server.

## Key Sizes and Expirations
## Currently, 2048-bit is the largest key size supported on the Yubikey. According to Digicert, 2048-bit RSA keys are strong enough to last more than a lifetime. Digicert’s “The Strength of an SSL Certificate page” has a video and a link to the math behind this logic.

## I’m hoping to never have to generate another master key. I’ve increased the key size on the master key to 3072-bits, which is recommended by NIST, in SP 800-57 Part 1, for keys that should last beyond the year 2031.

## It is possible to generate 4096-bit RSA keys with GnuPG but multiple sources on the GnuPG mailing list have suggested RSA keys beyond 3072-bits are not adding much in terms of additional security to justify the additional CPU resources required. Beyond 3072-bits, it is better to use Elliptic Curve (EC/ECC) keys instead of RSA. Unfortunately, today ECC keys aren’t widely supported in OpenGPG. Maybe by 2031 we’ll be using ECC keys in OpenPGP and it will make sense to generate a new key then.

## I’ve chosen a key lifetime of one year based on some best practices for OpenPGP keys. There are others who have made the argument for non-expiring master keys, but I think setting an expiration on the master key will encourage users to update the key at least once per year to receive new/revoked subkeys.

## Additional Resources
## Yubico product website for the Yubikey NEO and NEO-n
## Yubico’s page about Yubikey NEO and OpenPGP
## Yubico forum how-to post about Yubikey NEO, OpenPGP, OpenSSH authentication describes more detail on how to set this up on a Mac
## Another reference, by Thomas Habets, about GPG and SSH with Yubikey NEO.
## GnuPG handbook page for OpenPGP key management.
## The OpenPGP Smartcard, an alternative to the Yubikey for storing OpenPGP keys in hardware tokens.
## Debian wiki for Subkeys has good resources for creating subkeys and using them instead of a master key.