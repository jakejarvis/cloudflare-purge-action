# GitHub Action to Purge Cloudflare Cache  🗑️ 

> **⚠️ Note:** To use this action, you must have access to the [GitHub Actions](https://github.com/features/actions) feature. GitHub Actions are currently only available in public beta. You can [apply for the GitHub Actions beta here](https://github.com/features/actions/signup/).

This simple action calls the [Cloudflare API](https://api.cloudflare.com/#zone-purge-all-files) to purge the cache of your website, which can be a helpful last step after deploying a new version of your website.

As of now, this action will purge your *entire* zone — in the near future, you'll be able to only purge specific files or tags.


## Usage

### `workflow.yml` Example

Place in a `.yml` file such as this one in your `.github/workflows` folder. [Refer to the documentation on workflow YAML syntax here.](https://help.github.com/en/articles/workflow-syntax-for-github-actions)

```yaml
name: Deploy my website
on: push

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:

    # Put steps here to build your site, deploy it to a service, etc.

    - name: Purge cache
      uses: jakejarvis/cloudflare-purge-action@master
      env:
        CLOUDFLARE_ZONE: ${{ secrets.CLOUDFLARE_ZONE }}
        CLOUDFLARE_EMAIL: ${{ secrets.CLOUDFLARE_EMAIL }}
        CLOUDFLARE_KEY: ${{ secrets.CLOUDFLARE_KEY }}
```

If successful, you'll see the following message returned in your action's logs:

```
{"result":{"id":"***"},"success":true,"errors":[],"messages":[]}
```


### Required Secret Variables

All variables should be added as "secrets" in the action's configuration.

| Key | Value | Type | Required |
| ------------- | ------------- | ------------- | ------------- |
| `CLOUDFLARE_ZONE` | The Zone ID of your domain, which can be found in the right sidebar of your domain's overview page on the Cloudflare dashboard. For example, `xyz321xyz321xyz321xyz321xyz321xy`. | `secret` | **Yes** |
| `CLOUDFLARE_EMAIL` | The email address you registered your Cloudflare account with. For example, `me@example.com`. | `secret` | **Yes** |
| `CLOUDFLARE_KEY` | Your Cloudflare API key, which can be generated using [these instructions](https://support.cloudflare.com/hc/en-us/articles/200167836-Where-do-I-find-my-Cloudflare-API-key-). For example, `abc123abc123abc123abc123abc123abc123abc123abc`. | `secret` | **Yes** |


## To-Do

In the next few days...

- Purge individual files by URL ([docs](https://api.cloudflare.com/#zone-purge-files-by-url))
- Purge individual files by cache tag/host ([docs](https://api.cloudflare.com/#zone-purge-files-by-cache-tags-or-host)) [Enterprise only]
- Return a success/failed status message for the full CI experience


## License

This project is distributed under the [MIT license](LICENSE.md).
