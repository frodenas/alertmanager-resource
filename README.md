# Alertmanager Resource [![Build Status](https://travis-ci.org/frodenas/alertmanager-resource.png)](https://travis-ci.org/frodenas/alertmanager-resource)

A [Concourse](http://concourse.ci/) resource to interact with [Prometheus Alertmanager](https://prometheus.io/docs/alerting/alertmanager/), allowing you to `silence` certain alerts and to `expire` silences.

## Source Configuration

| Field  | Required | Type   | Description
|:-------|:--------:|:------:|:-----------
| url    | Y        | String | Alertmanager URL. If alertmanager is protected by an username and password, specify them at the URL (ie http://user:pwd@alertmanager.com).

*Note*: Self signed SSL certificates are not yet supported, in this case, use the `http` schema.

## Behavior

### `check`: Does nothing.

### `in`: Fetch a silence.

Places the following file in the destination directory:

* `silence`: Contains the `id` of the `silence` created by an `out` step.

### `out`: Silence an alert or expire a silence.

Performs one of the following actions:

#### Parameters

| Field     | Required | Type   | Description
|:----------|:--------:|:------:|:-----------
| operation | Y        | String | Operation to perform: `silence` or `expire`

##### Silence parameters

| Field    | Required | Type   | Description
|:---------|:--------:|:------:|:-----------
| matchers | Y        | String | The `matcher` groups to silence *[1]*
| creator  | N        | String | The email of the silence creator
| comments | N        | String | A comment to help describe the silence (defaults to the `CI pipeline URL`)
| expires  | N        | String | Duration of the silence (defaults to `1h`)

*[1]* The following examples will attempt to show the `matcher` behaviour in action:

| Matcher | Behaviour
|:--------|:----------
| `service=cf` | will add a `silence` that matches alerts with the `service=cf` label value pair set
| `alertname=CFCellUnhealthy service=cf` | will add a `silence` for the `CFCellUnhealthy` alert and matches the `service=cf` label value pair set
| `alertname=~CF.*` | the `=~` syntax (similar to prometheus) is used to represent a regex match (regex matching can be used in combination with a direct match)

##### Expire parameters

| Field   | Required | Type   | Description
|:--------|:--------:|:------:|:-----------
| silence | Y        | String | The path of the silence to expire (a directory containing the `silence` file)

## Example Configuration

### Resource Type

```yaml
resource_types:
  - name: alertmanager-resource
    type: docker-image
    source:
      repository: frodenas/alertmanager-resource
```

### Resource

``` yaml
resources:
  - name: alertmanager
    type: alertmanager-resource
    source:
      url: <ALERTMANAGER URL>
```

### Plan

The below example manages multiple silences at the same plan. The `silence` parameter for `expire` operations is the name of the step who created the silence. Normally this is just the same as the name of the resource, but if you have custom names for put (for example if you need to silence multiple alerts), you would put that name instead. For example:

``` yaml
jobs:
  - name: backups
    plan:
      - put: silence-cf-alerts
        resource: alertmanager
        params:
          operation: silence
          matchers: "service=cf"
          expires: 30m

      - put: silence-mysql-alerts
        resource: alertmanager
        params:
          operation: silence
          matchers: "service=mysql severity=warning"
          expires: 30m

      ... do my stuff ...

      - put: expire-cf-silence
        resource: alertmanager
        params:
          operation: expire
          silence: silence-cf-alerts

      - put: expire-mysql-silence
        resource: alertmanager
        params:
          operation: expire
          silence: silence-mysql-alerts
```

## Contributing

Refer to the [contributing guidelines](CONTRIBUTING.md).

## License

Apache License 2.0, see [LICENSE](LICENSE).
