
## 在 Kubernetes 上部署的可自动更新的静态网站

此项目包含一个 helm chart，它支持向 Kubernetes 部署一个静态网站，并根据 Git 仓库中的最新变更，自动更新网站。

*在本地启动部署时，要求本地安装有 Git 和 Helm。*

### 用法

```sh
./deploy.sh <git_repo_url> <branch>
```

### 直接用 Helm 来调用

```sh
REPO=https://git-location-of-your-static-site
BRANCH=master
REVISION=$(git ls-remote $REPO | grep refs/heads/$BRANCH | awk '{print $1}')

helm install <site-name> ./chart --set "autoUpdateCron=* * * * *,repo.location=$REPO,repo.branch=$BRANCH,repo.revision=$REVISION"
```



