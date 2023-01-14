# tektoncd-resources chart

The chart holds tekton pipeline resources, define your pipeline in folders under the **templates** directory.

```
├── horizon                             --- horizon default pipeline
│   ├── ...                             --- horizon default pipeline resources
│   └── ...
├── trigger-clusterrole.yaml
├── trigger-clusterrolebinding.yaml
├── trigger-role.yaml
├── trigger-rolebinding.yaml
└── trigger-sa.yaml
```

When defining a `tekton-trigger`, you need add serviceAccount into EventListener and the serviceAccount `templates\trigger-sa` is available.