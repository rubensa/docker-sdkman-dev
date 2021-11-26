| ⚠ **WARNING**: This image is obsolete as [rubensa/ubuntu-tini-dev](https://github.com/rubensa/docker-ubuntu-tini-dev) now includes [SDKMan](https://sdkman.io/). |
| --- |

# SDKMan image for local development

This image provides a SDKMan environment useful for local development purposes.
This image is based on [rubensa/ubuntu-dev](https://github.com/rubensa/docker-ubuntu-dev) so you can set internal user (developer) UID and internal group (developers) GUID to your current UID and GUID by providing that info means of "-u" docker running option.

## Running

You can interactively run the container by mapping current user UID:GUID and working directory.

```
docker run --rm -it \
	--name "sdkman-dev" \
	-v $(pwd):/home/developer/work \
	-w /home/developer/work \
	-u $(id -u $USERNAME):$(id -g $USERNAME) \
	--group-add sdkman \
	rubensa/sdkman-dev
```

This way, any file created in the container initial working directory is written and owned by current host user:group launching the container (and the internal "sdkman" group is added to keep access to shared "/opt/sdkman" folder where sdkman is installed).
