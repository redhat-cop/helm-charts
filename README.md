
[查看中文说明文档](https://github.com/jijiechen/static-site-on-k8s/blob/master/README-zh.md)

## Static Site Deployment with Automatic Updating on Kubernetes

This is a helm chart supporting deploying a static website onto Kubernetes and enable auto-polling to its Git repository.

*It depends on Git and Helm to be installed when triggering the deployment from your local environment.*

### Using via the deploy.sh

```sh
./deploy.sh --repo <git_repo_url> --branch <branch> [--settings <more_helm_chart_settings>]
```

### Using directly with Helm

```sh
REPO=https://git-location-of-your-static-site
BRANCH=master
REVISION=$(git ls-remote $REPO | grep refs/heads/$BRANCH | awk '{print $1}')

helm install <site-name> ./chart --set "autoUpdateCron=* * * * *,repo.location=$REPO,repo.branch=$BRANCH,repo.revision=$REVISION"
```

### Supported Helm Settings

The following table lists the settings of the chart and their default values.

|      Parameter       |                             Description                    |     Default     |      Required     |
| -------------------- | ---------------------------------------------------------- | --------------- | ----------------- |
| `repo.location`      | HTTP(s) based URL of your git repository that stores source of the site |    |  Y                |
| `repo.revision`      | Full git revision of the latest version of your site       |                 |  Y                |
| `repo.branch`        | Name of git branch you want to deploy                      | `master`        |  N                |
| `repo.credential.username`  | Username to of the git repository                   |                 |  N                |
| `repo.credential.password`  | Password to of the git repository                   |                 |  N                |
| `site.enableDirectoryListing` | Whether enable directory listing for the site     | `false`         |  N                |
| `replicas`           | Number of replicas of the deployment                       | `2`             |  N                |
| `autoUpdateCron`     | The CRON expression scheduling the auto update polling job | `* * * * *`, which means every minute |  N                |


