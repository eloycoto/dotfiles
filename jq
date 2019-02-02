# Cilium related things
def cep_status13:
    (["Endpoint ID", "Identity ID", "PolicyEnforcement", "IPv4", "IPv6"]), (
    .items[]|[.status.id, .status.status.identity.id,
    .status.status.policy.realized."policy-enabled",
    .status.status.networking.addressing[0].ipv4,
    .status.status.networking.addressing[0].ipv6])|@tsv;

def cep_by_id($i): .items[] | select(.status.id==$i);
def cep_by_identity($i): .items[] | select(.status.status.identity.id==$i);

def cep_status:
    (["Name", "EpID","IdID", "Ingress", "Egress", "IPv4", "IPv6"]), (
    .items[]|[.metadata.name, .status.id, .status.identity.id,
    .status.policy.ingress.enforcing,
    .status.policy.egress.enforcing,
    .status.networking.addressing[0].ipv4,
    .status.networking.addressing[0].ipv6]) | @tsv;

def pod_status:
    (["PodName", "Containers", "Status", "PodIp", "NodeName"]), (.items[] | [
        (.metadata.namespace+":"+.metadata.name),
        (.spec.containers | length),
        ([.status.containerStatuses[].ready]|all),
        .status.podIP,
        .spec.nodeName]
    ) | @tsv;

def pod_container_status($i):
        (["Container", "ImageID", "Status"]), (.items[]|select(.metadata.name==$i)|.status.containerStatuses[]|[
            .containerID, .imageID, .ready])|  @tsv;
