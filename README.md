# kind-cluster

Terraform launches a Spot EC2 instance and, after SSH is up, installs Kind, Docker CE, kubectl, and k9s, then creates a Kind cluster.

| Setting | Value |
| --- | --- |
| Instance type | `m6a.xlarge` |
| Market | Spot, `max_price` omitted (AWS default cap is the On-Demand price) |
| AMI | `ami-0eec78ea4cbaaf5bd` |
| Security group | `sg-00e79a3a2a694b395` |
| SSH | `ec2-user` / `DevOps321` via `null_resource` + `remote-exec` |

The AMI does not accept password SSH until boot. `user_data` sets the `ec2-user` password and turns on `PasswordAuthentication`. The `null_resource` then connects with that password and runs `scripts/bootstrap.sh`.

## Before apply

- AWS credentials that can run a Spot instance in the AMI region.
- `aws_region` must be the region that owns this AMI and security group.
- The security group must allow inbound TCP 22 from the machine running Terraform.
- The subnet must be in that security group's VPC and must have a route to an internet gateway. Leave `subnet_id` unset to pick the first subnet with `map-public-ip-on-launch`. `m6a.xlarge` is not offered in every AZ; set `subnet_id` if the chosen subnet's AZ has no capacity.

```bash
cp terraform.tfvars.example terraform.tfvars
# edit aws_region (and subnet_id if needed)
terraform init
terraform apply
```

Apply waits while Docker images for the Kind node are pulled. When it finishes:

```bash
ssh ec2-user@$(terraform output -raw public_ip)
# password: DevOps321
kubectl get nodes
k9s
```

Spot capacity can be reclaimed. The Kind cluster lives on this instance's disk and is gone if the instance is interrupted.
