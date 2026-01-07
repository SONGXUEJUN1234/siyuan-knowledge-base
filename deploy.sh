#!/bin/bash

# SiYuan 知识库一键部署脚本
# 使用方法: chmod +x deploy.sh && ./deploy.sh

set -e

echo "=========================================="
echo "  SiYuan 知识库一键部署脚本"
echo "=========================================="
echo ""

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo "正在安装 Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo "Docker 安装完成！"
    echo "请重新登录终端以使 Docker 权限生效，然后再次运行此脚本。"
    exit 0
fi

# 检查 Docker Compose 是否可用
if ! docker compose version &> /dev/null; then
    echo "错误: Docker Compose 不可用，请确保 Docker 版本 >= 20.10"
    exit 1
fi

# 创建工作空间目录
echo "创建工作空间目录..."
mkdir -p workspace
chmod 755 workspace

# 检查 .env 文件
if [ ! -f .env ]; then
    echo "错误: 未找到 .env 配置文件"
    exit 1
fi

# 读取配置
source .env

echo ""
echo "配置信息："
echo "  - 访问端口: ${SIYUAN_PORT:-6806}"
echo "  - 时区: ${TZ:-Asia/Shanghai}"
echo ""

# 启动服务
echo "正在启动 SiYuan 服务..."
docker compose up -d

# 等待服务启动
echo "等待服务启动..."
sleep 5

# 检查服务状态
if docker compose ps | grep -q "running"; then
    echo ""
    echo "=========================================="
    echo "  部署成功！"
    echo "=========================================="
    echo ""
    echo "访问地址: http://$(hostname -I | awk '{print $1}'):${SIYUAN_PORT:-6806}"
    echo "访问授权码: ${SIYUAN_AUTH_CODE:-siyuan123}"
    echo ""
    echo "常用命令："
    echo "  查看状态: docker compose ps"
    echo "  查看日志: docker compose logs -f"
    echo "  重启服务: docker compose restart"
    echo "  停止服务: docker compose down"
    echo "  更新镜像: docker compose pull && docker compose up -d"
    echo ""
else
    echo "错误: 服务启动失败，请检查日志"
    docker compose logs
    exit 1
fi
