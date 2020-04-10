
## 在 Kubernetes 上部署的可自动更新的静态网站

此项目包含一个 helm chart，它支持向 Kubernetes 部署一个静态网站，并根据 Git 仓库中的最新变更，自动更新网站。

*在本地启动部署时，要求本地安装有 Git 和 Helm。*

### 用法

```sh
./deploy.sh --repo <git_repo_url> --branch <branch> [--settings <more_helm_chart_settings>]
```

### 直接用 Helm 来调用

```sh
REPO=https://git-location-of-your-static-site
BRANCH=master
REVISION=$(git ls-remote $REPO | grep refs/heads/$BRANCH | awk '{print $1}')

helm install <site-name> ./chart --set "autoUpdateCron=* * * * *,repo.location=$REPO,repo.branch=$BRANCH,repo.revision=$REVISION"
```

### 支持的 Helm 设置项

下表列出了这个 Helm Chart 所支持的各项设置及其默认值：

|          参数         |                             描述                  |       默认值     |      是否必填     |
| -------------------- | ------------------------------------------------- | --------------- | ----------------- |
| `repo.location`      | 存储静态网站源代码的 Git 仓库地址的 HTTP(s) 地址        |                 |  是                |
| `repo.revision`      | 网站最新版源代码的 Git 提交版本号                      |                 |  是                |
| `repo.branch`        | 要部署的分支名称                                     |  `master`       | 否                 |
| `repo.credential.username`  | Git 仓库的用户名                             |                 |  否                |
| `repo.credential.password`  | Git 仓库的密码                               |                 |  否                |
| `site.enableDirectoryListing` | 是否启用目录浏览功能                         | `false`         |  否                |
| `replicas`           | 部署时，要生成的副本数目                              | `2`             |  否                |
| `autoUpdateCron`     | 用以设定检测自动更新频率的 CRON 表达式 | `* * * * *`, 即每分钟检查 |  否                |



