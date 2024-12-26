# 使用 Node.js 官方镜像作为基础镜像
FROM node:20-slim

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json (如果存在)
COPY package*.json ./

# 安装项目依赖
RUN npm install

# 复制项目文件
COPY . .

# 暴露端口 (wrangler dev 默认使用 8787)
EXPOSE 7860

# 启动开发服务器
CMD ["npm", "run", "start"]
