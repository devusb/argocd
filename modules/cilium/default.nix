{ charts, ... }:
{
  applications.cilium = {
    namespace = "kube-system";

    helm.releases.cilium = {
      chart = charts.cilium.cilium;

      values = {
        operator.replicas = 1;
        ipam.mode = "kubernetes";
        kubeProxyReplacement = true;
        securityContext = {
          capabilities = {
            ciliumAgent = [
              "CHOWN"
              "KILL"
              "NET_ADMIN"
              "NET_RAW"
              "IPC_LOCK"
              "SYS_ADMIN"
              "SYS_RESOURCE"
              "DAC_OVERRIDE"
              "FOWNER"
              "SETGID"
              "SETUID"
            ];
            cleanCiliumState = [
              "NET_ADMIN"
              "SYS_ADMIN"
              "SYS_RESOURCE"
            ];
          };
        };
        cgroup = {
          autoMount.enabled = false;
          hostRoot = "/sys/fs/cgroup";
        };
        k8sServiceHost = "localhost";
        k8sServicePort = 7445;
        gatewayAPI = {
          enabled = true;
          enableAlpn = true;
          enableAppProtocol = true;
        };
        socketLB.hostNamespaceOnly = true;
        bpf.lbExternalClusterIP = true;
      };
    };
  };
}
