# SiYuan 个人知识库永久部署指南

**版本**: 1.0
**日期**: 2026-01-07
**作者**: Manus AI

## 1. 概述

本指南将引导您在自己的服务器上永久部署 **SiYuan（思源笔记）** 个人知识库。我们采用 **Docker Compose** 进行容器化部署，这种方式具有良好的隔离性、可移植性和易于管理的优点。部署包中包含了所有必要的配置文件和自动化脚本，帮助您快速搭建一个稳定、安全、可扩展的个人知识库系统。

### 部署包内容

| 文件/目录 | 描述 |
|---|---|
| `docker-compose.yml` | 定义了 SiYuan 服务和可选的 Nginx 反向代理服务。 |
| `.env` | 存储所有可配置的环境变量，如端口、授权码等。 |
| `deploy.sh` | 一键部署脚本，自动检查环境、安装依赖并启动服务。 |
| `backup.sh` | 备份脚本，用于定期备份您的知识库数据。 |
| `nginx/` | 包含 Nginx 反向代理的配置文件和 SSL 证书存放目录。 |
| `workspace/` | SiYuan 的数据存储目录，所有笔记和附件都保存在这里。 |
| `PERMANENT_DEPLOYMENT_GUIDE.md` | 本部署指南。 |

## 2. 环境要求

在开始部署之前，请确保您的服务器满足以下要求：

- **操作系统**: 任意主流 Linux 发行版（如 Ubuntu, CentOS, Debian）。
- **硬件**: 至少 1 核 CPU, 1GB RAM, 10GB 磁盘空间（建议 2 核 CPU, 2GB RAM 以获得更佳性能）。
- **网络**: 服务器需要有公网 IP 地址，并确保防火墙开放了您计划使用的端口（默认为 6806，以及 80/443 用于 Nginx）。
- **软件**: 无需预装任何软件，部署脚本会自动安装 Docker。

## 3. 部署步骤

### 3.1. 上传并解压部署包

首先，将我们为您准备的 `siyuan-deploy.tar.gz` 部署包上传到您的服务器，例如上传到 `/opt` 目录。然后解压文件：

```bash
# 进入目标目录
cd /opt

# 解压部署包
tar -xzvf siyuan-deploy.tar.gz

# 进入部署目录
cd siyuan-deploy
```

### 3.2. 修改配置

在部署之前，您需要根据自己的需求修改 `.env` 配置文件。这是一个关键步骤，特别是为了安全起见，**强烈建议您修改默认的访问授权码**。

```bash
# 使用您喜欢的编辑器打开 .env 文件
nano .env
```

您需要关注以下配置项：

- `SIYUAN_AUTH_CODE`: **（必须修改）** 设置一个强密码作为您的知识库访问授权码。
- `SIYUAN_PORT`: 如果默认的 `6806` 端口已被占用，您可以修改为其他端口。
- `TZ`: 根据您所在的地理位置修改时区，例如 `America/New_York`。

### 3.3. 执行一键部署脚本

完成配置后，执行一键部署脚本即可启动服务。脚本会自动检查并安装 Docker，然后根据您的配置启动 SiYuan 容器。

```bash
# 赋予脚本执行权限
chmod +x deploy.sh

# 运行部署脚本
./deploy.sh
```

如果这是您第一次在服务器上运行此脚本，它会首先安装 Docker，然后提示您重新登录终端以使用户组权限生效。重新登录后，再次运行 `./deploy.sh` 即可完成部署。

部署成功后，您将看到类似以下的输出信息：

```
==========================================
  部署成功！
==========================================

访问地址: http://<您的服务器IP>:<端口>
访问授权码: <您设置的授权码>
```

现在，您可以通过浏览器访问该地址，开始使用您的个人知识库了。

## 4. 服务管理

部署包中的 `docker-compose.yml` 文件使得服务管理变得非常简单。您可以使用 `docker compose` 命令来管理您的 SiYuan 服务。

| 操作 | 命令 |
|---|---|
| 查看服务状态 | `docker compose ps` |
| 查看服务日志 | `docker compose logs -f` |
| 启动服务 | `docker compose up -d` |
| 停止服务 | `docker compose down` |
| 重启服务 | `docker compose restart` |
| 更新镜像 | `docker compose pull && docker compose up -d` |

## 5. 数据备份与恢复

### 5.1. 自动备份

我们为您提供了一个 `backup.sh` 脚本，可以方便地备份您的整个知识库。该脚本会将 `workspace` 目录压缩，并默认保留最近 7 次的备份。

您可以设置一个定时任务（Cron Job）来自动执行备份。例如，每天凌晨 3 点执行备份：

```bash
# 编辑定时任务
crontab -e

# 添加以下内容 (请将 /path/to/siyuan-deploy 替换为您的实际路径)
0 3 * * * /bin/bash /path/to/siyuan-deploy/backup.sh > /dev/null 2>&1
```

### 5.2. 手动恢复

如果需要从备份中恢复数据，请按照以下步骤操作：

1.  **停止服务**: `docker compose down`
2.  **备份当前数据**: `mv workspace workspace_bak`
3.  **解压备份文件**: `tar -xzvf backups/siyuan_backup_YYYYMMDD_HHMMSS.tar.gz`
4.  **启动服务**: `docker compose up -d`

确认恢复成功后，可以删除 `workspace_bak` 目录。

## 6. 配置域名和 HTTPS (可选)

为了更专业和安全地访问您的知识库，建议您配置一个域名并启用 HTTPS。部署包中的 Nginx 服务可以帮助您实现这一点。

### 6.1. 前提条件

- 您拥有一个域名，并已将其 DNS 解析到您的服务器 IP 地址。
- 您已为您的域名获取了 SSL 证书（例如通过 Let's Encrypt 获取免费证书）。

### 6.2. 配置步骤

1.  **上传 SSL 证书**
    将您的 SSL 证书文件（通常是 `fullchain.pem` 和 `privkey.pem`）上传到 `nginx/ssl/` 目录下。

2.  **修改 Nginx 配置**
    编辑 `nginx/nginx.conf` 文件：

    ```nginx
    # 找到 HTTPS 服务器配置块
    server {
        listen 443 ssl http2;
        server_name your-domain.com; # <-- 修改为您的域名

        ssl_certificate /etc/nginx/ssl/fullchain.pem;
        ssl_certificate_key /etc/nginx/ssl/privkey.pem;
        # ... 其他 SSL 配置 ...
    }
    ```

    同时，建议您将 HTTP 请求强制重定向到 HTTPS。在 `listen 80` 的 `server` 配置块中，取消注释 `return 301 https://$host$request_uri;` 这一行。

3.  **启动 Nginx 服务**
    使用 `docker compose` 启动带有 Nginx 的服务。`--profile` 参数会激活 `docker-compose.yml` 文件中定义了 `profiles: ["with-nginx"]` 的服务。

    ```bash
docker compose --profile with-nginx up -d
    ```

现在，您就可以通过 `https://your-domain.com` 访问您的 SiYuan 知识库了。

---

祝您使用愉快！如有任何问题，请参考 SiYuan 官方文档或社区寻求帮助。
