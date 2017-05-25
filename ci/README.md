# Alertmanager Resource Concourse Pipeline

In order to run the Alertmanager Resource Concourse Pipeline you must have an existing [Concourse](http://concourse.ci) environment.

* Target your Concourse CI environment:

```
fly -t <CONCOURSE TARGET NAME> login -c <YOUR CONCOURSE URL>
```

* Create a `credentials.yml` (use the [credentials-example.yml](https://github.com/frodenas/alertmanager-resource/blob/master/ci/credentials-example.yml) file as an example).

* Set the Alertmanager Resource Concourse Pipeline:

```
fly -t <CONCOURSE TARGET NAME> set-pipeline -p alertmanager-resource -c ci/pipeline.yml -l ci/credentials.yml
```

* Unpause the Alermanager Resource Concourse Pipeline:

```
fly -t <CONCOURSE TARGET NAME> unpause-pipeline -p alertmanager-resource
```
