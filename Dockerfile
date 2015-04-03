# 指令的一般格式为:INSTRUCTION arguments
# 以#开头的为注释行

# 第一条指令必须为FORM指令，指定基础镜像信息
# 格式为FROM <image>或FROM <image>:<tag>
# 可以在同一个Dockerfile中多次使用FROM指令以创建多个镜像
FROM myrepo/myimage:mytag

# 维护者信息，格式为MAINTAINER <name>
MAINTAINER Liang Xia <xialiangseason@gmail.com>

# 镜像操作指令
# ENV指令，格式为ENV <key> <value>
# 指定一个环境变量，会被后续RUN指令使用，并在容器运行时保持
ENV PATH /usr/local/bin:$PATH
# VOLUME指令，格式为VOLUME ["/data"]
# 创建一个可以从本地主机或其它容器挂载的挂载点
# 一般用来存放数据库和需要保持的数据等
VOLUME ["/dbdata"]
# USER指令，格式为USER daemon
# 指定运行容器时的用户名或UID，后续的RUN也会使用指定用户
# 当服务不需要管理员权限时，可以通过该命令指定运行用户
# 并且可以在之前创建所需要的用户
# 要临时获取管理员权限可以使用gosu，而不推荐sudo
USER user1
# WORKDIR指令，格式为WORKDIR /path/to/workdir
# 为后续的RUN、CMD、ENTRYPOINT指令配置工作目录
# 可以使用多个WORKDIR指令，后续命令如果是相对路径，则会基于之前的路径
WORKDIR /tmp/
# ADD指令，格式为ADD <src> <dest>
# 该命令将复制指定的<src>到容器中的<dest>
# 其中<src>可以是Dockerfile所在目录的一个相对路径
# 也可以是一个URL；还可以是一个tar文件（自动解压为目录）
ADD ./config.tar /config
# COPY指令，格式为COPY <src> <dest>；当使用本地目录为源目录时，推荐使用
# 复制本地主机的<src>（为Dockerfile所在目录的相对路径）到容器中的<dest>
COPY ./config.yml /config
# RUN指令,格式为RUN <command>或RUN ["executable", "param1", "param2"]
# 前者在shell终端中运行命令，即/bin/sh -c；后者则使用exec执行
# 每条RUN指令将在当前镜像基础上执行指定命令，并提交为新的镜像
# 当命令较长时可以使用\来换行
RUN echo "example here"
# EXPOSE指令，格式为EXPOSE <port> [<port>...]
# 告诉docker服务端容器暴露的端口号，供互联系统使用
EXPOSE 5000 5001

# CMD指令，容器启动时执行的指令,支持三种格式：
# CMD ["executable", "param1", "param2"]使用exec执行，推荐方式
# CMD command param1 param2在/bin/sh中执行，提供给需要交互的应用
# CMD ["param1", "param2"]提供给ENTRYPOINT的默认参数
# 每个Dockerfile创建的每个镜像只有最后一条CMD命令会执行
# 如果用户启动容器时指定了运行的命令，则会覆盖掉CMD指定的命令
CMD /usr/sbin/nginx

# ENTRYPOINT指令，两种格式：
# ENTRYPOINT ["executable", "param1", "param2"]
# ENTRYPOINT command param1 param2
# 配置容器启动后执行的命令，并且不可被docker run提供的参数覆盖
# 每个Dockerfile只能有一个；当指定多个时，只有最后一个起效
ENTRYPOINT echo "This is entrypoint"

# ONBUILD指令，格式为ONBUILD [instruction]
# 配置当所创建的镜像作为其它新创建镜像的基础镜像时，所执行的指令
# 使用ONBUILD指令的镜像，推荐在标签中注明，例如ruby:1.9-onbuild
