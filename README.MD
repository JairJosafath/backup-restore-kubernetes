# Postgres StatefulSet Backup and Restore in Minikube

This guide provides step-by-step instructions for setting up a Postgres StatefulSet in Minikube, performing backups using Kubernetes CronJobs, and restoring the backups from VolumeSnapshots.

## Prerequisites

1. Ensure that you have Minikube and kubectl installed.
2. Start Minikube and ensure it is running.

## Steps

### 1. Enable Required Minikube Addons

First, enable the necessary Minikube addons for snapshots and CSI host path driver:

```bash
minikube addons enable volumesnapshots
minikube addons enable csi-hostpath-driver
```

### 2. Create the Postgres StatefulSet

Deploy the Postgres StatefulSet using the following command:

```bash
kubectl apply -f postgres.sts.yaml
```

### 3. Access the Postgres Pod and Execute SQL Scripts

Once the StatefulSet is running, you can execute scripts inside the Postgres pod:

```bash
kubectl exec -it postgres-sts-0 -- psql -U postgres
```

You can now run any SQL scripts inside the Postgres shell.

### 4. Create Roles for the Backup CronJob

To allow the CronJob pod to interact with the database, apply the roles defined in the `roles.yaml` file:

```bash
kubectl apply -f roles.yaml
```

### 5. Create the Backup CronJob

Now, create the CronJob that will perform the backups:

```bash
kubectl apply -f cronjob.yaml
```

### 6. Manually Run the CronJob (Optional)

You can manually trigger a backup CronJob either through the Kubernetes dashboard:

```bash
minikube dashboard
```

Or from the command line:

```bash
kubectl create job --from=cronjob/backuper postgres-backup-manual
```

### 7. Check the Backup Job Logs

Once the CronJob has run, you can check the logs to verify if it succeeded:

```bash
kubectl logs job.batch/postgres-backup-manual
```

### 8. List the VolumeSnapshots

To verify that the backup created a snapshot, list the available VolumeSnapshots:

```bash
kubectl get volumesnapshot
```

### 9. Delete All Resources

If you wish to delete the CronJob, roles, and StatefulSet, run the following commands:

```bash
kubectl delete -f cronjob.yaml
kubectl delete -f roles.yaml
kubectl delete -f postgres.sts.yaml
```

### 10. Restore from a Snapshot

To restore from a previously created snapshot:

1. Modify the `restored.yaml` file to reference the correct snapshot name (retrieved from the `kubectl get volumesnapshot` command).
2. Apply the `restored.yaml` file:

```bash
kubectl apply -f restored.yaml
```

### 11. Verify the Restored Data

Once the restoration process completes, you can access the restored Postgres pod and verify the data:

```bash
kubectl exec -it restored-db-0 -- psql -U postgres
```

### 12. Cleanup

To remove the restored pod and other associated resources, run:

```bash
kubectl delete -f restored.yaml
```

Additionally, you can delete all jobs using:

```bash
kubectl delete job --all
```

---

This guide should help you set up, back up, restore, and clean up Postgres StatefulSets and VolumeSnapshots in Minikube.
