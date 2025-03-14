# tur
termux user repository
这是一个 termux用户仓库。
[跳转到目录](#contents)

# 多语言 <a name="i8k">
[__en__](README.en.md)

# 使用 <a name="use"/>
在源文件中添加`deb [trusted=yes] https://raw.githubusercontent.com/wwbcici/tur/main/ stable main`
或直接使用`echo deb [trusted=yes] https://raw.githubusercontent.com/wwbcici/tur/main/ stable main > $PREFIX/etc/apt/sources.list.d/ctur.list`

# 创建自定义仓库 <a name="creatingCustomRepository"/>

### 构建仓库 <a name="buildProject"/>
1. 安装工具：`apt install dpkg-scanpacka ges apt-ftparchive` # 用于创建索引文件

2. 创建项目目录：`mkdir -p tur/dists/stable/main/binary-aarch64  tur/pool/main`

```
tur/
├── dists/
│   └── stable/
│       └── main/
│           ├── binary-amd64/    # 架构特定的二进制软件包，用于区分架构  # `x86_64` 或 `ARM64`
│           ├── binary-aarch64/    # termux是创建这个即可 `ARMv8`
│           │   ├── Packages    # 包索引文件（未压缩版）
│           │   ├── Packages.gz    # 建议使用 gzip 压缩
│           │   └── Release    # 发行版描述文件（可选签名）
│           └── source/    # 如有源码包，可在此放置
└── pool/
    └── main/
        └── your-package.deb    # 仓库的 deb 安装包
```

3. 生成Packages文件：
  - `dpkg-scanpackages pool/ /dev/null > dists/stable/main/binary-aarch64/Packages` 或 `apt-ftparchive packages pool/ > dists/stable/main/binary-aarch64/Packages`
  - `gzip -c dists/stable/main/binary-aarch64/Packages > dists/stable/main/binary-aarch64/Packages.gz`

__*或*__
  - `dpkg-scanpackages pool/ /dev/null > dists/stable/main/binary-aarch64/Packages`
> 为了保持兼容性，`Packages` 与 `Packages.gz` 通常是同时存在的，但也可以仅存在一个。

4. `apt-ftparchive release dists/stable > dists/stable/Release`

### 提交至GitHub <a name="commitToGitHub"/>

- 初始化仓库：`git init`
- 重命名分支：`git branch -m main`  # 要求和github分支名一致
- `git add .`
- `git commit`
- 添加GitHub仓库源为`origin`：`git remote add origin https://github.com/<your name>/<repo name>.git`
- 以rebase方式拉取远程仓库变更：`git pull --rebase origin main`
- 推送至远程仓库并将`origin`设置为默认推送源：`git push --set-upstream origin main`

# 目录 <a name="contents"/>
- [多语言](#i8k)
- [使用](#use)
- [创建自定义仓库](#creatingCustomRepository)
  - [构建仓库](#buildProject)
  - [提交至GitHub](#commitToGitHub)
