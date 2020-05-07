# Create a deployment(with name nginx) and pod(image->nginx, name->auto generated). This is deprecated


# Imperative cmds
kubectl run name --image=imagename ## this will create the deployment
kubectl run name --image=imagename --restart=Never ## this will create the POD
kubectl run name --image=imagename --restart=OnFailure ## this will create the Job
kubectl run name --image=imagename --restart=OnFailure --schudle= "*****" ## this will create the Cron-Job

kubectl run --image=nginx nginx  --generator=run-pod/v1 --labels="app=redis","env=dev" # Create only pod(name->nginx, image->nginx, )
kubectl expose pod podname --port=5787 --name=servicename # expose a new service
kubectl run --image=kodekloud/webapp-color webapp --replicas=3 # Create deployment. This is deplrecated
kubectl create deployment webapp --image=kodekloud/webapp-color # Create a new deployment. this is the latest one
kubectl expose deployment webapp --type=NodePort --port=8080 --name=webapp-service --dry-run -o yaml > webapp-service.yaml  # generate the yaml with out creating the object
kubectl create configmap webapp-config-map --from-literal=APP_COLOR=darkblue --from-literal=name=praga # Create Config-maps
kubectl create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB-User=root # Create secrets, Incase of yaml file, literal values need to set as base 64 encode. IN imprative cmds it is not required
kubectl create serviceaccount <serviceaccountn-ame>
kubectl set image deployment/deployment-name currentImageName=newImageName (nginx=nginx:1.9.1)

# Create k8 object from file
kubectl create -f filename
kubectl delete -f filename
kubectl apply -f filename

# not applicable for all the values. applicable only for imagename, replicasets,
# https://www.udemy.com/course/certified-kubernetes-application-developer/learn/lecture/14937910#announcements
kubectl edit objectType objectname

# Describe-> kubectl describe objectType objectname
# Describe covers status, containers,
kubectl describe pod podname

# Output
kubectl get objectType objectname -o wide yaml > filename
kubectl get pods
kubectl get replicasets
kubeectl get pods --selector key=value

# Delete
kubectl delete objectType objectname
kubectl delete pod podname # if the pods created based on replica set, even after delete pod will recreate. replicaset will makesure always configurable number of pods run

# Scale
kubectl scale replicaset.apps/replicaset-1 --replicas=5
kubectl scale replicaset replicaset-1 --replicas=2

# Running generic cmds
kubectl exec <objectname> whoami

# taints
kubectl taint nodes <node-name> key=value:effect
kubectl taint nodes node01 spray=mortein:NoSchedule # apply taint to node
kubectl taint nodes node01 spray:NoSchedule- # remove taint from nodes

# logs
kubectl logs e-com-1123 -n e-commerce > /opt/outputs/e-com-1123.logs
kubectl logs -f e-com-1123 -n e-commerce
kubectl logs -f pod-name container-name # incase pod has multiple container

# set namespace name in currrent context
kubectl config set-context --current --namespace=<insert-namespace-name-here>


# rollout
# first version will be created at the time of deployment. when change the properties like container image, label new version will be create
kubectl rollout status deployment/deployment-name # to see the status of the rollout at the time of revision deployment
kubectl rollout history deployment/deployment-name # to see all the version
kubectl rollout undo deployment/deployment-name # revert to previous version

# kubectl rolling-update my-nginx  ## deprecated
# kubectl rolling-update my-nginx --rollback ## deprecated


############short cuts################
source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
# echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.

kubectl config set-context --current --namespace=<insert-namespace-name-here>

--dry-run

alias  k=kubectl

kubectl explain objectType  --recursive
po=pods
svc=service
pv
pvc



# Restart policy - default value is Always
###################  Service Account  ######################################################################################################################
kubectl create serviceaccount name
1. each name space has one default serviceaccount
2. serviceaccount has the token to authnticate the k8s api
3. when ever we create a new pod, default serviceaccount will be mounted automatically
4. to allow the api authentication from third part system serviceaccount is required
5. if the third part runs on same cluster and try to user the k8s API, no need of create a new serviceaccount. default serviceaccount account can be mounted

#############  Resource requiremnts and limits ###############################################################################################################################
Rewuirements:
  1. schudler will place the pod, if only we have "requested" number of resource available in node.
     otherwise it will move to other pod. if not pod found with requested space, pod will be in failed state.
  2. this can be mentioned with pod\deployment yaml files

limits:
 1. limit the resourorce and memory consumtion in while pod running at the run time
 2. if cpu requirement cross the limit, schudler will try to threshoild the cpu usage
 3. if memory requirement cross the limit, schudler allow it for some time. if same happens again and again , pod will be terminated
 4. these limits can be mentioned in pod\deployment yaml file

################# Taints and tolerance ############################################################################################################
1. controlls which pod can run on the particular node.
2. Taints set on nodes and tollerance set on pods
3. Toleration set on the pod defination file
4. This will not controll a pod to deploy on specific node. it just controll the node to accept they pod
5. using this Master node controlled by not deploying any pods

# setting the taint on node
kubectl taint nodes node-name key=value:tainet-effect
    taint-effect possible values: NoSchedule, PreferNoSchedule(try to avoid. no guarantee), NoExecute(Will check the already running pods also. if found anythin, kill those pods)
Ex: kubectl taint nodes node1 env=test:NoSchedule

################# node selector ############################################################################################################
1. control the pod to deploy on specific node. This is achieved by labeling the node and pass the label in pod defination file.
   This approach has the limitaion to deploy the pod to single node. we cant configure like to deploy on group of nodes

2. Use below cmd to label the node
   kubectl label node node-name key=value
   kubectl label node node-a size=large
3. node label name passed like below in pod defination file
   spec:
     containers:
       - name: aaa
         image: asdfa
     nodeSelector:
          key(size): value(large) # Node labels

################# node affienity ############################################################################################################
1. Same like node selector. But allows to configure like to deploy on group of pods.
2. achieved by giving the node affienity property in pod.yaml
3. has the controll to decide what is the action if some one change the node label name later.
   requiredDuringSchedulingIgnoreDuringExecution
   preferredDuringSchedulingIgnoreDuringExecution
   requiredDuringSchedulingRequiredDuringExecution(future release)
4. supports multiple operator like =, in, not, exist to compare the node label

# setting the affinity on pod.yaml
  ....
  spec:
    containers:
       - image: nginx
         name: nginx image
    tolerations:
        - key: "same as taint defination at node. ie. enf"
          value: "same as taint defination at node. ie ="
          operator: "same as taint defination at node. ie test"
          effect: "same as taint defination at node. ie NoSchedule"


######## Moniter ###################
1. needs third party application to get the montier
2. Metric-server is the one off the supported project by kubernetes for montier
3. To install the metric-server
    in minikube:  minikube addons enable metrics-server
    other: git clone https://metric server github url
           kubectl create -f /folder of above clone/
4. to view the metrics
  kubectl top nodes
  kubectl top pods

############# Readiness Probe #########################
1. Test is the pod is ready
2. After containers initalized, kubernetes will check this block, if success then move the pod state to ready
3. Can define this by adding readinessprobe in pod.yaml
   spec:
      containers:
         ....
      readinessprobe:
         httpGet: # this can be httpGet, tcpSocker, command
           path: /apipath/id
           port: 8080
         initialDelaySeconds: 10 # do probe test after this time
         periodSeconds: 5 # delay between next probe test incase prior one failed
         failureThreshold: 10 # if these many number of attempts fail, pod will be failed, Default count 3

##### Liveness Probes ########################
1. same like readinessprobe. Instead of readines, this test if application inside the containers is healty after start running.
   instead of readinessprobe, livenessProbe key will be used in pod.yaml.  other properties same like readinessprobe


##### Jobs & Crown jobs ######
1. Created using job defination yaml file.
2. POD defination should have the restartPolicy as Never.
3. "completion" will tells how many number of pods need to be created success.
  Incase any Pod fails, Pod will be recreated till "completion" number of success pods achieved.
  Pods willl be craeted sequential.
4. "parallelism" is the property which tell how many pods need to be created in parallel


#### Multi container ###
1. Side car
2. Adaptor
3. Ambassador

###############################
1. set the shortcuts
2. cron-job properties in normal linux
3. Book mark for cron job
