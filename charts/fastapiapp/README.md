### How to create helm chart from manifests
To create helm chart run following command and edit values, chart files and files in templates directory based on your k8s manifests:

```
$ helm create fastapiapp
```

Now move to the fastapiapp directory and run tree command you should see:

```
$ tree
.
├── charts
├── Chart.yaml
├── README.md
├── templates
│   ├── deployment.yaml
│   ├── _helpers.tpl
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── NOTES.txt
│   ├── serviceaccount.yaml
│   ├── service.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml
```

Now you can edit Chart.yaml and modify appVersion and chart version. You can edit values.yaml and provide image registry, name and tag and whatever you want.