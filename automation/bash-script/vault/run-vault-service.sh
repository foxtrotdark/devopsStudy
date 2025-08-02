#!/bin/bash

VAULT_CONFIG=/etc/vault.d
VAULT_BINARY=$(which vault)

sudo tee /lib/systemd/system/vault.service <<EOF
[Unit]
Description="HashiCorp Vault"
Documentation="https://developer.hashicorp.com/vault/docs"
ConditionFileNotEmpty="${VAULT_CONFIG}/vault.hcl"

[Service]
User=vault
Group=vault
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=${VAULT_BINARY} server -config=${VAULT_CONFIG}/vault.hcl
ExecReload=/bin/kill --signal HUP
KillMode=process
KillSignal=SIGINT

[Install]
WantedBy=multi-user.target
EOF

sudo chmod 644 /lib/systemd/system/vault.service

sudo systemctl daemon-reload

sudo systemctl start vault.service

sudo systemctl status vault.service

ip addr

