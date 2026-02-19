# West Resource for Concourse

A Concourse resource for fetching Zephyr RTOS sources using the West meta-tool.

## Building the Resource

```bash
docker build -t west-resource .
```

## Source Configuration

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `manifest_url` | No | `https://github.com/zephyrproject-rtos/zephyr` | URL of the west manifest repository |
| `manifest_revision` | No | `main` | Branch/tag of the manifest repository |
| `manifest_path` | No | `west.yml` | Path to the west manifest file |
| `zephyr_path` | No | `zephyr` | Path to the Zephyr repository within the west workspace (for external modules use a different path) |

## Example Pipeline Usage

```yaml
resource_types:
- name: west-resource
  type: docker-image
  source:
    repository: west-resource

resources:
- name: zephyr-source
  type: west-resource
  source:
    manifest_url: https://github.com/zephyrproject-rtos/zephyr
    manifest_revision: main

jobs:
- name: build-zephyr
  plan:
  - get: zephyr-source
    trigger: true
  - task: build
    config:
      platform: linux
      image_resource:
        type: docker-image
        source:
          repository: zephyrprojectrtos/ci
      inputs:
      - name: zephyr-source
      run:
        path: bash
        args:
        - -c
        - |
          cd zephyr-source
          west build -b qemu_x86 samples/hello_world
```

## Behavior

### `check`: Check for new commits

Returns new versions when the manifest repository has new commits on the specified revision.

### `in`: Fetch the source

Initializes a west workspace and fetches all repositories defined in the manifest.

### `out`: No-op

This is a read-only resource, so `out` returns the input version unchanged.