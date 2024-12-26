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


RUN echo "=====> 开始设置环境变量"


# 创建 .dev.vars 文件
RUN touch .dev.vars



# 声明所有需要的构建参数
ARG UUID
# 如果需要在容器运行时使用，转换为环境变量
ENV UUID=${UUID}

# 方法1：在 RUN 指令中使用双引号打印
RUN echo "UUID is: ${UUID}"

RUN printenv

# 将环境变量写入 .dev.vars
RUN echo "UUID=748df15d-cb58-48de-930c-9d6fd68f088e" >> .dev.vars

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
