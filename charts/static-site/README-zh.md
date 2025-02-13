
## 在 Kubernetes 上部署的可自动更新的静态网站

此项目包含一个 helm chart，它支持向 Kubernetes 部署一个静态网站，并根据 Git 仓库中的最新变更，自动更新网站。

### 用法

```sh
helm install my-cool-site ./ --set "repo.location=https://git-location-of-your-static-site"
```

### 支持的 Helm 设置项

下表列出了这个 Helm Chart 所支持的各项设置及其默认值：

|          参数         |                             描述                  |       默认值     |      是否必填     |
| -------------------- | ------------------------------------------------- | --------------- | ----------------- |
| `repo.location`      | 存储静态网站源代码的 Git 仓库地址的 HTTP(s) 地址        |                 |  是                |
| `repo.branch`        | 要部署的分支名称                                     |  `master`       | 否                 |
| `repo.credential.username`  | Git 仓库的用户名                             |                 |  否                |
| `repo.credential.password`  | Git 仓库的密码                               |                 |  否                |
| `site.enableDirectoryListing` | 是否启用目录浏览功能                         | `false`         |  否                |
| `replicas`           | 部署时，要生成的副本数目                              | `2`             |  否                |
| `autoUpdateCron`     | 用以设定检测自动更新频率的 CRON 表达式 | `* * * * *`, 即每分钟检查 |  否                |
