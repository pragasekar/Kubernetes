## Reference https://www.youtube.com/watch?v=3GPpm2nZb2s
# Folder structure
  - chart-name
     - Chart.yaml
     - templates
        - deployment.yaml


helm create app-name # to create the directory struct

helm install name chart-directory # deploy a chart
helm list # list the deployments
helm upgrade nginx2 . # upgrade the exissting deployment, For better practise change the version in Charts.yaml
helm rollback nginx2 1 # helm rollback helm-chart-name target-version

helm install nginx . --set replicaCountValue=2 # override the value in values.yaml
helm install nginx . --values "path to values.yaml" # pass the values.yaml as property

