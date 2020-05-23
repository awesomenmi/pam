
### Пользователи и группы. Авторизация и аутентификация 
___
##### Задание: Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников

Были созданы два пользователя user1 и user2:
```
[root@localhost vagrant]# useradd -m -s /bin/bash user1
[root@localhost vagrant]# useradd -m -s /bin/bash user2
[root@localhost vagrant]# id user1
uid=1004(user1) gid=1004(user1) groups=1004(user1)
[root@localhost vagrant]# id user2
uid=1005(user2) gid=1005(user2) groups=1005(user2)
```
где -m 	создает начальный каталог нового пользователя, если он еще не существует. Если каталог уже существует, добавляемый пользователь должен иметь права на доступ к указанному каталогу.
-s shell 	полный путь к программе, используемой в качестве начального командного интерпретатора для пользователя сразу после регистрации. Длина этого поля не должна превосходить 256 символов. По умолчанию это поле - пустое, что заставляет систему использовать стандартный командный интерпретатор /usr/bin/sh. 

Пользователи добавлены в группу admins
```
[root@localhost vagrant]# groupadd admins
[root@localhost vagrant]# gpasswd -a user1 admins
Adding user user1 to group admins
[root@localhost vagrant]# gpasswd -a user2 admins
Adding user user2 to group admins
[root@localhost vagrant]# id user1
uid=1004(user1) gid=1004(user1) groups=1004(user1),1006(admins)
[root@localhost vagrant]# id user2
uid=1005(user2) gid=1005(user2) groups=1005(user2),1006(admins)
```

Пользователям назначены пароли:
```
[root@localhost vagrant]# echo "user1" | sudo passwd --stdin user1
Changing password for user user1.
passwd: all authentication tokens updated successfully.
[root@localhost vagrant]# echo "user2" | sudo passwd --stdin user2
Changing password for user user2.
passwd: all authentication tokens updated successfully.
```

Разрешим вход через ssh по паролю:
```
[root@localhost vagrant]# sudo bash -c "sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl restart sshd.service"
```
Настроим PAM, для этого приведем файл /etc/pam.d/sshd к виду:
```
...
account  required   pam_nologin.so
account  required   pam_exec.so  /usr/local/bin/test_login.sh
...
```
где [test_login.sh](https://github.com/awesomenmi/pam/blob/master/test_login.sh)
