#!/bin/bash

# SiYuan 知识库备份脚本
# 使用方法: chmod +x backup.sh && ./backup.sh

set -e

# 配置
BACKUP_DIR="./backups"
WORKSPACE_DIR="./workspace"
MAX_BACKUPS=7  # 保留最近 7 个备份

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 生成备份文件名
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/siyuan_backup_$TIMESTAMP.tar.gz"

echo "=========================================="
echo "  SiYuan 知识库备份"
echo "=========================================="
echo ""

# 检查工作空间目录
if [ ! -d "$WORKSPACE_DIR" ]; then
    echo "错误: 工作空间目录不存在: $WORKSPACE_DIR"
    exit 1
fi

# 创建备份
echo "正在创建备份..."
tar -czvf "$BACKUP_FILE" -C "$(dirname $WORKSPACE_DIR)" "$(basename $WORKSPACE_DIR)"

# 计算备份大小
BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)

echo ""
echo "备份完成！"
echo "  - 备份文件: $BACKUP_FILE"
echo "  - 文件大小: $BACKUP_SIZE"
echo ""

# 清理旧备份
echo "清理旧备份（保留最近 $MAX_BACKUPS 个）..."
cd "$BACKUP_DIR"
ls -t siyuan_backup_*.tar.gz 2>/dev/null | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm -f
cd - > /dev/null

BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/siyuan_backup_*.tar.gz 2>/dev/null | wc -l)
echo "当前备份数量: $BACKUP_COUNT"
echo ""
echo "备份列表："
ls -lh "$BACKUP_DIR"/siyuan_backup_*.tar.gz 2>/dev/null || echo "  无备份文件"
