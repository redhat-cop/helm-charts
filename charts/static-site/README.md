
[查看中文说明文档](README-zh.md)

## Static Site Deployment with Automatic Updating on Kubernetes

This is a helm chart supporting deploying a static website onto Kubernetes and enable auto-polling to its Git repository.

### Usage

```sh
helm install my-cool-site ./ --set "repo.location=https://git-location-of-your-static-site"
```

### Supported Helm Settings

The following table lists the settings of the chart and their default values.

|      Parameter       |                             Description                    |     Default     |      Required     |
| -------------------- | ---------------------------------------------------------- | --------------- | ----------------- |
| `repo.location`      | HTTP(s) based URL of your git repository that stores source of the site |    |  Y                |
| `repo.branch`        | Name of git branch you want to deploy                      | `master`        |  N                |
| `repo.credential.username`  | Username to of the git repository                   |                 |  N                |
| `repo.credential.password`  | Password to of the git repository                   |                 |  N                |
| `site.enableDirectoryListing` | Whether enable directory listing for the site     | `false`         |  N                |
| `replicas`           | Number of replicas of the deployment                       | `2`             |  N                |
| `autoUpdateCron`     | The CRON expression scheduling the auto update polling job | `* * * * *`, which means every minute |  N                |
