
## Static Site with Automatic Updating on Kubernetes

This is a helm chart supporting deploying a static website onto Kubernetes and enable auto-polling to its Git repository.

*It depends on Git and Helm to be installed when triggering the deployment from your local environment.*

### Usage

```sh
./deploy.sh <git_repo_url> <branch>
```

### Usage with Helm

```sh
REPO=https://git-location-of-your-static-site
BRANCH=master
REVISION=$(git ls-remote $REPO | grep refs/heads/$BRANCH | awk '{print $1}')

helm install <site-name> ./chart --set "autoUpdateCron=* * * * *,repo.location=$REPO,repo.branch=$BRANCH,repo.revision=$REVISION"
```



