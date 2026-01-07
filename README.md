# SiYuan 个人知识库系统

[![GitHub stars](https://img.shields.io/github/stars/SONGXUEJUN1234/siyuan-knowledge-base?style=social)](https://github.com/SONGXUEJUN1234/siyuan-knowledge-base)

> 基于 [SiYuan（思源笔记）](https://github.com/siyuan-note/siyuan) 的个人知识库部署方案，支持知识检索、双向链接、Markdown 编辑的自托管知识管理平台。

## ✨ 功能特性

- **块级引用与双向链接** - 在不同文档间建立关联，形成知识网络
- **强大的全文搜索** - 支持查询语法和类型过滤，快速定位所需内容
- **Markdown 所见即所得** - 支持大纲、数学公式、流程图、甘特图等
- **AI 写作与问答** - 支持 OpenAI API 集成，智能辅助写作
- **闪卡间隔重复** - 内置记忆系统，支持知识复习
- **隐私优先** - 数据完全本地存储，支持端到端加密

## 🚀 快速部署

### 前置要求

- Linux 服务器（Ubuntu/CentOS/Debian 等）
- Docker 和 Docker Compose
- 至少 1GB 内存，10GB 磁盘空间

### 一键部署

```bash
# 1. 克隆仓库
git clone https://github.com/SONGXUEJUN1234/siyuan-knowledge-base.git
cd siyuan-knowledge-base

# 2. 配置环境变量（重要：请修改默认授权码）
# 编辑 docker-compose.yml 中的 SIYUAN_ACCESS_AUTH_CODE

# 3. 执行部署脚本
chmod +x deploy.sh
./deploy.sh
```

### 手动部署

```bash
# 创建数据目录
mkdir -p /home/ubuntu/siyuan/workspace

# 启动容器
docker-compose up -d
```

## 📁 文件说明

| 文件 | 说明 |
|------|------|
| `docker-compose.yml` | Docker Compose 配置文件 |
| `deploy.sh` | 一键部署脚本 |
| `backup.sh` | 数据备份脚本 |
| `PERMANENT_DEPLOYMENT_GUIDE.md` | 详细部署指南 |

## 🔧 配置说明

### 环境变量

在 `docker-compose.yml` 中可配置以下参数：

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `SIYUAN_ACCESS_AUTH_CODE` | 访问授权码 | `siyuan123` |
| `SIYUAN_WORKSPACE` | 工作空间路径 | `/siyuan/workspace` |

### 端口配置

- 默认端口：`6806`
- 可在 `docker-compose.yml` 中修改端口映射

## 📦 数据备份

```bash
# 执行备份脚本
./backup.sh

# 备份文件将保存在 backups 目录下
```

## 🔗 相关链接

- [SiYuan 官方仓库](https://github.com/siyuan-note/siyuan)
- [SiYuan 官方文档](https://b3log.org/siyuan/)
- [Docker Hub](https://hub.docker.com/r/b3log/siyuan)

## 📄 许可证

本项目基于 [AGPL-3.0](https://www.gnu.org/licenses/agpl-3.0.html) 许可证开源。

---

⭐ 如果这个项目对您有帮助，请给个 Star 支持一下！
