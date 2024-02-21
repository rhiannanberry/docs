## Hosted agents pipeline migration

To migrate an existing pipeline to use a hosted agents queue, you must first ensure:

- Your pipeline is in the same cluster as all the hosted agent queues you wish to target.
- Each step in the pipeline targets the required compute queue.
- Source control settings have been updated to allow code access.

There are different pipeline repository settings required for public and private repositories, see below for the relevant instructions.

### Private repository

Before completing the following steps ensure you have followed the instructions in [Private Repository Access](/docs/buildkite-compute/source-control#compute-code-access-private-repositories).

- Set your pipeline to use the GitHub (with code access) service you authorized in the step above.
- Navigate to your pipeline settings.
- Select GitHub from the left menu.  
- Remove the existing repository, or select the _Choose another repository or URL_ link
- Select the GitHub account including ...(with code access).
- Select the repository.
- Select _Save Repository_.

## Public repository

When accessing a public repository from a Buildkite compute agent, you must ensure the services is using `HTTPS` for checkout.

- Navigate to your pipeline settings.
- Select GitHub from the left menu.  
- Change the _Checkout using_ to `HTTPS`.