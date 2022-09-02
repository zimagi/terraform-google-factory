# Cluster Access with IAP Bastion Host

This end to end example aims to showcase access patterns to a hardened GKE Private Cluster, through a bastion host utilizing [Identity Awareness Proxy](https://cloud.google.com/iap/) without an external ip address. Access to this cluster's control plane is restricted to the bastion host's internal IP using [authorized networks](https://cloud.google.com/kubernetes-engine/docs/how-to/authorized-networks#overview).

Additionally we deploy a [tinyproxy](https://tinyproxy.github.io/) daemon which allows `kubectl` commands to be piped through the bastion host allowing ease of development from a local machine with the security of GKE Private Clusters.

## Setup

To deploy this example:

1. Run `terraform init`.

2. Create a `terraform.tfvars` to provide values for `project_id`, `network`, `subnet`, `prefix`, `bastion_members`. Optionally override any variables if necessary.

3. Run `terraform apply`.

4. After apply is complete, generate kubeconfig for the private cluster. _The command with the right parameters will displayed as the Terraform output `get_credentials_command`._

   ```sh
   gcloud container clusters get-credentials --project $PROJECT_ID --zone $ZONE --internal-ip $CLUSTER_NAME
   ```

5. SSH to the Bastion Host while port forwarding to the bastion host through an IAP tunnel. _The command with the right parameters will displayed by running `terraform output bastion_ssh_command`._

   ```sh
   gcloud beta compute ssh $BASTION_VM_NAME --tunnel-through-iap --project $PROJECT_ID --zone $ZONE -- -L8888:127.0.0.1:8888
   ```

6. You can now run `kubectl` commands though the proxy. _An example command will displayed as the Terraform output `bastion_kubectl_command`._

   ```sh
   HTTPS_PROXY=localhost:8888 kubectl get pods --all-namespaces
   ```