## 获取

```sh
git clone https://github.com/lscho/sshp.git
```

## 使用

```sh
chmod +x ./sshp.sh
```

#### 添加

```sh
./sshp.sh add
```

#### 查看

```sh
./sshp.sh ls
```

#### 删除

```sh
./sshp.sh rm server_name
```

#### 登陆

```sh
./sshp.sh server_name
```

## 全局

```sh
cp sshp.sh /usr/local/bin/sshp #仅在当前用户全局使用

sshp ls
```