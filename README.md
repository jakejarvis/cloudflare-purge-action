# GitHub Action to Purge Cloudflare Cache  🗑️ 

> **⚠️ Note:** To use this action, you must have access to the [GitHub Actions](https://github.com/features/actions) feature. GitHub Actions are currently only available in public beta. You can [apply for the GitHub Actions beta here](https://github.com/features/actions/signup/).

This simple action calls the [Cloudflare API](https://api.cloudflare.com/#zone-purge-all-files) to purge the cache of your website, which can be a helpful last step after deploying a new version.


## Usage

### Configuration

All sensitive variables should be [set as encrypted secrets](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables) in the action's configuration.

| Key | Value | Suggested Type | Required |
| ------------- | ------------- | ------------- | ------------- |
| `cloudflareZone` | The Zone ID of your domain, which can be found in the right sidebar of your domain's overview page on the Cloudflare dashboard. For example, `xyz321xyz321xyz321xyz321xyz321xy`. | `secret` | **Yes** |
| `cloudflareEmail` | The email address you registered your Cloudflare account with. For example, `me@example.com`. | `secret` | **Yes** |
| `cloudflareKey` | Your Cloudflare API key, which can be generated using [these instructions](https://support.cloudflare.com/hc/en-us/articles/200167836-Where-do-I-find-my-Cloudflare-API-key-). For example, `abc123abc123abc123abc123abc123abc123abc123abc`. | `secret` | **Yes** |
| `purgeURLs` | **Optional.** An array of **fully qualified URLs** to purge. For example: `'["https://jarv.is/style.css", "https://jarv.is/favicon.ico"]'`. If unset, the action will purge everything (which is [suggested](#purging-specific-files)). | `option` | No |

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
      with:
        cloudflareZone: ${{ secrets.CLOUDFLARE_ZONE }}
        cloudflareEmail: ${{ secrets.CLOUDFLARE_EMAIL }}
        cloudflareKey: ${{ secrets.CLOUDFLARE_KEY }}
```

### Purging specific files

To purge only specific files, you can pass an array of **fully qualified URLs** via a fourth environment variable named `PURGE_URLS`. Unfortunately, Cloudflare doesn't support wildcards (unless you're on the insanely expensive Enterprise plan) so in order to purge a folder, you'd need to list every file in that folder. It's probably safer to leave this out and purge everything, but in case you want really to, the syntax is as follows:

```yaml
purgeURLs: '["https://jarv.is/style.css", "https://jarv.is/favicon.ico"]'
```


## License

This project is distributed under the [MIT license](LICENSE.md).
