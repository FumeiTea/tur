<div>
    
[**English**](README_en-US.md)
[**Japanese**](README_ja-JP.md)

</div>

## tur

<div>

[![Debian:Trixie](https://img.shields.io/badge/Debian:Trixie-A81D33?style=for-the-badge&logo=debian&logoColor=white)](#Debian-Trixie)

[![Debian:Bullseye](https://img.shields.io/badge/Debian:Bullseye-A81D33?style=for-the-badge&logo=debian&logoColor=white)](Debian-Bullseye)

[![Arch](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)](Arch)

[![ChromeOS:Crostini](https://img.shields.io/badge/ChromeOS:Crostini-4285F4?style=for-the-badge&logo=Google-chrome&logoColor=white)](ChromeOS-Crostini)

[![]()](./)
[![]()](./)

</div>

<div style="border: 2px solid #FFA500; padding: 10px; border-radius: 5px; background-color: #FFF3E0;">
    <p style="margin: 0; font-weight: bold; color: #E65100;">
        &#9888; Warning
    </p>
    <hr style="border-top: 1px solid #FFCC80; margin: 5px 0;">
    <p style="margin: 0; color: #000;">
        操作前请做好相应备份。
    </p>
</div>

<!-- HTML div 版本（带橙色边框）-->
<div style="border:2px solid #ff8c00; border-left:6px solid #ff8c00; padding:12px 14px; border-radius:6px; font-family:system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', Arial; line-height:1.4;">
  <strong style="display:inline-flex;align-items:center;gap:8px;font-size:1.05em;">
    <span aria-hidden="true">⚠️</span> Warning
  </strong>
  <div style="margin-top:6px;">
    操作前请做好相应备份。
  </div>
</div>


termux user repository  
这是一个 termux用户仓库。
[跳转到目录](#contents)


### Debian:Trixie <span id="Debian-Trixie"/>

#### 收录架构

#### 

### Debian-Bullseye <span id="Debian-Bullseye"/>
### Arch <span id="Arch"/>
### ChromeOS-Crostini <span id="ChromeOS-Crostini"/>
###  <span id=""/>
###  <span id=""/>


# 多语言 <a name="i8k">
[__en__](README.en.md)

# 使用 <a name="use"/>
- 在源文件中添加：`deb [trusted=yes] https://raw.githubusercontent.com/FumeiTea/tur/main/ stable main`  
- `echo deb [trusted=yes] https://raw.githubusercontent.com/FumeiTea/tur/main/ stable main > $PREFIX/etc/apt/sources.list.d/ctur.list`
- `curl -sSL https://raw.githubusercontent.com/FumeiTea/tur/main/setrepo |sh`

``

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
  - .
    - `dpkg-scanpackages pool/ /dev/null > dists/stable/main/binary-aarch64/Packages`
    - `apt-ftparchive packages pool/ > dists/stable/main/binary-aarch64/Packages`
  - `gzip -c dists/stable/main/binary-aarch64/Packages > dists/stable/main/binary-aarch64/Packages.gz`

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
