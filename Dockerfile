FROM node:20-slim

# 创建应用目录
WORKDIR /app

# 添加非root用户
RUN groupadd -r nodejs && useradd -r -g nodejs nodejs

# 复制项目文件
COPY package*.json ./
RUN npm install

COPY . .

# 设置目录权限
RUN chown -R nodejs:nodejs /app

# 切换到非root用户
USER nodejs

# 创建必要的目录并设置权限
RUN mkdir -p /app/node_modules/.mf && \
    mkdir -p /app/.wrangler

EXPOSE 7860

CMD ["npm", "run", "start"]
