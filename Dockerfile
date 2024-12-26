FROM node:20-slim



# 创建应用目录
WORKDIR /app

# Wrangler will prompt, and thus hang if you don't specify this
ENV WRANGLER_SEND_METRICS=false

# 添加非root用户
RUN groupadd -r nodejs && useradd -r -g nodejs nodejs

# 复制项目文件
COPY package*.json ./
RUN npm install

COPY . .

# 创建 .dev.vars 文件
RUN touch .dev.vars

# 使用 ARG 接收构建参数
ARG UUID
# 将环境变量写入 .dev.vars
RUN if [ ! -z "${UUID}" ]; then \
    echo "UUID=${UUID}" >> .dev.vars; \
    fi
# 打印 .dev.vars 中的内容以确认
RUN cat .dev.vars

# 设置目录权限
RUN chown -R nodejs:nodejs /app

# 切换到非root用户
USER nodejs

# 创建必要的目录并设置权限
RUN mkdir -p /app/node_modules/.mf && \
    mkdir -p /app/.wrangler

RUN chown -R nodejs:nodejs /app/node_modules/.mf && \
    chown -R nodejs:nodejs /app/.wrangler

RUN chmod -R 777 /app/node_modules/.mf && \
    chmod -R 777 /app/.wrangler

EXPOSE 7860

CMD ["npm", "run", "start"]
