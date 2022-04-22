# Github Action to Build a Deb Package

This is a [GitHub Action](https://github.com/features/actions) that will
build a [Debian package](https://en.wikipedia.org/wiki/Deb_%28file_format%29)
(`.deb` file) for Debian or Ubuntu.

The Debian or Ubuntu distribution is specified using the action
tag/version. For example, `focal-v1` and `bionic-v` will build
a package for Ubuntu Focal (21.04) and Ubuntu Bionic (18.04)
respectively.

## Usage

```yaml
on:
  push:
    branches:
      - master

jobs:
  build-deb:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - uses: kanaka/build-dpkg@focal-v1
        id: build
        with:
          args: --unsigned-source --unsigned-changes

      - name: Release
        uses: softprops/action-gh-release@v1
        with:
          files: |
            mypkg_*
            mypkg-*

```

This Action wraps the [`dpkg-buildpackage`](https://manpages.debian.org/buster/dpkg-dev/dpkg-buildpackage.1.en.html)
command. To use it, you must have a `debian` directory at the top of
your repository, with all the files that `dpkg-buildpackage` expects.

This Action does the following things inside a Docker container:

1. Call [`mk-build-deps`](http://manpages.ubuntu.com/manpages/buster/man1/mk-build-deps.1.html)
   to ensure that the build dependencies defined the `debian/control` file
   are installed in the Docker image.
2. Call [`dpkg-buildpackage`](https://manpages.debian.org/buster/dpkg-dev/dpkg-buildpackage.1.en.html)
   with whatever arguments are passed to the
   [`args` input](https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstepswithargs) in the step definition.
3. Move the resulting `*.deb` files into the `artifacts/` directory in
   your repository, so that other GitHub Actions steps can process
   them futher.

