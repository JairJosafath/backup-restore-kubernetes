#################################

# DO NOT RUN THIS FILE, IT IS A COLLECTION OF COMMANDS USED IN THE DEMO

#################################

# enable volumesnapshot and csi-hostpath-snapshot addons
minikube addons enable volumesnapshots
minikube addons enable csi-hostpath-driver

# create the sts
kubectl apply -f postgres.sts.yaml

# exec into the postgres pod and run some scripts defined in postgres.scripts.sql
kubectl exec -it postgres-sts-0 -- psql -U postgres

# after adding some users to the database create the roles for the cronjob pod
kubectl apply -f .\roles.yaml   

# create the cronjob
kubectl apply -f .\cronjob.yaml

# manually run a cronjob, you can do this easily via the k8s dashboard
minikube dashboard

# or run the job via the command line
kubectl create job --from=cronjob/backuper postgres-backup-manual

# get logs for job
kubectl logs job.batch/postgres-backup-manual

# if it failed there will be an error message in the logs
# if it succeeded lets list the snapshots
kubectl get volumesnapshot

# delete all resources previously made
kubectl delete -f .\cronjob.yaml
kubectl delete -f .\roles.yaml
kubectl delete -f .\postgres.sts.yaml

# modify the restored.yaml file and change the snapshot name to the one you want to restore (remember, these can be found by running kubectl get volumesnapshot)
# apply the restored.yaml file to restore the snapshot 
kubectl apply -f .\restored.yaml

# exec into the restored pod and run an sql script to retrieve the data
kubectl exec -it restored-db-0 -- psql -U postgres

# cleanup
kubectl delete -f .\restored.yaml

# cleanup jobs
kubectl delete job --all