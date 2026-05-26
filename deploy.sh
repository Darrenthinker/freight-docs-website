#!/bin/bash
# ============================================================
# 陈闯单证网站 — 一键初始化 Git + 推送 GitHub
# 用法：在 Terminal 里进入本目录后运行  bash deploy.sh
# ============================================================

set -e  # 任何命令出错就停止

REPO_NAME="freight-docs-website"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "📁 项目目录：$PROJECT_DIR"
echo ""

# ── 1. 清理旧的 .git（如有残留）──────────────────────────────
if [ -d "$PROJECT_DIR/.git" ]; then
  echo "🧹 检测到旧 .git 目录，先清理..."
  rm -rf "$PROJECT_DIR/.git"
  echo "   ✅ 清理完成"
fi

# ── 2. 初始化 Git ────────────────────────────────────────────
echo "🔧 初始化 Git 仓库..."
cd "$PROJECT_DIR"
git init
git branch -m main
echo "   ✅ Git 初始化完成（分支：main）"

# ── 3. 设置 git 用户信息（如果还没设置）──────────────────────
if [ -z "$(git config --global user.name)" ]; then
  echo "⚙️  设置 Git 用户信息..."
  git config --global user.name "陈闯"
  git config --global user.email "darrenthinker@gmail.com"
fi

# ── 4. 首次提交 ──────────────────────────────────────────────
echo "📦 添加文件并提交..."
git add .
git commit -m "🚀 初始版本：陈闯单证服务网站（33种单证）"
echo "   ✅ 首次提交完成"

# ── 5. 创建 GitHub 仓库并推送 ────────────────────────────────
echo ""
if command -v gh &>/dev/null; then
  echo "🐙 检测到 GitHub CLI，自动创建仓库并推送..."
  # 检查是否已登录
  if ! gh auth status &>/dev/null; then
    echo "⚠️  GitHub CLI 未登录，正在打开登录流程..."
    gh auth login
  fi
  # 创建公开仓库并推送
  gh repo create "$REPO_NAME" \
    --public \
    --description "陈闯单证服务 | 产地证·CO·SASO·FTA·CE认证专业代办" \
    --source=. \
    --remote=origin \
    --push
  echo ""
  echo "✅ 已推送到 GitHub！"
  # 获取仓库地址
  REPO_URL=$(gh repo view --json url -q .url)
  echo "🔗 仓库地址：$REPO_URL"
else
  # 没有 gh CLI，输出手动步骤
  echo "⚠️  未检测到 GitHub CLI（gh），请按以下步骤手动操作："
  echo ""
  echo "   方法一（推荐）：安装 gh CLI 后重新运行本脚本"
  echo "   brew install gh && bash deploy.sh"
  echo ""
  echo "   方法二：手动操作"
  echo "   1. 打开 https://github.com/new"
  echo "   2. 仓库名填：$REPO_NAME"
  echo "   3. 选 Public，不要勾选初始化文件，点 Create"
  echo "   4. 复制仓库地址（格式：https://github.com/你的用户名/$REPO_NAME.git）"
  echo "   5. 在本目录终端运行："
  echo "      git remote add origin https://github.com/你的用户名/$REPO_NAME.git"
  echo "      git push -u origin main"
fi

echo ""
echo "══════════════════════════════════════════════"
echo "🎉 完成！下一步去 Cloudflare Pages 部署："
echo ""
echo "   1. 打开 https://pages.cloudflare.com"
echo "   2. 点击「Create a project」→「Connect to Git」"
echo "   3. 选择你的 GitHub 账号 → 找到 $REPO_NAME"
echo "   4. 构建设置："
echo "      - Framework preset: None（静态HTML，无需构建）"
echo "      - Build command: 留空"
echo "      - Build output directory: /（根目录）"
echo "   5. 点 Save and Deploy，等1分钟即可上线"
echo "   6. Cloudflare 会给你一个 .pages.dev 的域名"
echo "══════════════════════════════════════════════"
echo ""
