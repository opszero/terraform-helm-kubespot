global:
  enabled: true
  imagePullSecrets: []
  tlsDisable: true

injector:
  enabled: true
  replicas: 1
  port: 8080
  leaderElector:
    enabled: true
  metrics:
    enabled: false
  externalVaultAddr: ""
  image:
    repository: "hashicorp/vault-k8s"
    tag: "0.14.2"
    pullPolicy: IfNotPresent
  agentImage:
    repository: "hashicorp/vault"
    tag: "1.9.2" 
  agentDefaults:
    cpuLimit: "500m"
    cpuRequest: "250m"
    memLimit: "128Mi"
    memRequest: "64Mi"
    template: "map" 
    templateConfig:
      exitOnRetryFailure: true
      staticSecretRenderInterval: "" 
  authPath: "auth/kubernetes" 
  logLevel: "info" 
  logFormat: "standard" 
  revokeOnShutdown: false
  namespaceSelector: {}
  objectSelector: {}
  failurePolicy: Ignore
  webhookAnnotations: {}
  certs:
    secretName: null
    caBundle: ""
    certName: tls.crt
    keyName: tls.key
  resources: {}
  extraEnvironmentVars: {}
      
  affinity: |
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchLabels:
              app.kubernetes.io/name: {{ template "vault.name" . }}-agent-injector
              app.kubernetes.io/instance: "{{ .Release.Name }}"
              component: webhook
          topologyKey: kubernetes.io/hostname 
  tolerations: []
  nodeSelector: {}
  priorityClassName: ""
  annotations: {}
  extraLabels: {} 
  hostNetwork: false 
  service:  
    annotations: {}
  podDisruptionBudget: {}
  strategy: {}

server:
  enabled: true  
  
  enterpriseLicense:
    secretName: ""
    secretKey: "license"
  image:
    repository: "hashicorp/vault"
    tag: "1.9.2"
    
    pullPolicy: IfNotPresent
  updateStrategyType: "OnDelete"  
  logLevel: ""  
  logFormat: ""

  authDelegator:
    enabled: true 
  extraInitContainers: null  
  extraContainers: null  
  shareProcessNamespace: false  
  extraArgs: ""  
  readinessProbe:
    enabled: true
    failureThreshold: 2 
    initialDelaySeconds: 5
    periodSeconds: 5  
    successThreshold: 1    
    timeoutSeconds: 3  
  livenessProbe:
    enabled: false
    path: "/v1/sys/health?standbyok=true"    
    failureThreshold: 2    
    initialDelaySeconds: 60    
    periodSeconds: 5    
    successThreshold: 1    
    timeoutSeconds: 3
  
  terminationGracePeriodSeconds: 10 
  preStopSleepSeconds: 5
  postStart: []
  extraEnvironmentVars: {}  
  extraSecretEnvironmentVars: []  
  extraVolumes: []  
  volumes: null 
  volumeMounts: null  
  affinity: |
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchLabels:
              app.kubernetes.io/name: {{ template "vault.name" . }}
              app.kubernetes.io/instance: "{{ .Release.Name }}"
              component: server
          topologyKey: kubernetes.io/hostname 
  tolerations: [] 
  nodeSelector: {} 
  networkPolicy:
    enabled: false
    egress: [] 
  priorityClassName: "" 
  extraLabels: {} 
  annotations: {} 
  service:
    enabled: true
    externalTrafficPolicy: Cluster
    port: 8200
    targetPort: 8200
    annotations: {}
  dataStorage:
    enabled: true
    size: 10Gi    
    mountPath: "/vault/data"    
    storageClass: null    
    accessMode: ReadWriteOnce    
    annotations: {}

  auditStorage:
    enabled: false    
    size: 10Gi    
    mountPath: "/vault/audit" 
    storageClass: null    
    accessMode: ReadWriteOnce    
    annotations: {}

  standalone:
    enabled: "-"
    config: |
      ui = true

      listener "tcp" {
        tls_disable = 1
        address = "[::]:8200"
        cluster_address = "[::]:8201"
      }
      storage "s3" {
        bucket = "${bucket_name}"
        region = "${bucket_region}"
        kms_key_id = "${kms_key_id}"
      }
  
  ha:
    enabled: false

  serviceAccount:   
    create: true  
    name: "" 
    annotations: {
      eks.amazonaws.com/role-arn: ${vault_role_arn}
    }
