# Fetch existing VPC
data "aws_vpc" "existing" {
  id = var.vpc_id # Provide the existing VPC ID
}

# Fetch existing subnet
data "aws_subnet" "existing" {
  id = var.subnet_id # Provide the existing Subnet ID
}

# # Fetch or define a security group
data "aws_security_group" "web_sg" {
  id = var.security_group_id
}
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_cloudwatch_instance_profile.name

  subnet_id = data.aws_subnet.existing.id
  vpc_security_group_ids      = ["${data.aws_security_group.web_sg.id}"]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y amazon-cloudwatch-agent
              cat <<'EOL' > /opt/aws/amazon-cloudwatch-agent/bin/cloudwatch-agent-config.json
              {
                "agent": {
                  "metrics_collection_interval": 60,
                  "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
                },
                "metrics": {
                  "metrics_collected": {
                    "cpu": {
                      "measurement": [
                        {"name": "cpu_usage_idle", "rename": "CPU_USAGE_IDLE", "unit": "Percent"},
                        {"name": "cpu_usage_iowait", "rename": "CPU_USAGE_IOWAIT", "unit": "Percent"},
                        {"name": "cpu_usage_user", "rename": "CPU_USAGE_USER", "unit": "Percent"},
                        {"name": "cpu_usage_system", "rename": "CPU_USAGE_SYSTEM", "unit": "Percent"},
                        {"name": "cpu_usage_nice", "rename": "CPU_USAGE_NICE", "unit": "Percent"},
                        {"name": "cpu_usage_guest", "rename": "CPU_USAGE_GUEST", "unit": "Percent"},
                        {"name": "cpu_usage_steal", "rename": "CPU_USAGE_STEAL", "unit": "Percent"}
                      ],
                      "totalcpu": true,
                      "resources": [
                        "*"
                      ],
                      "append_dimensions": {
                        "InstanceId": "$INSTANCE_ID"
                      }
                    },
                    "mem": {
                      "measurement": [
                        {"name": "mem_used_percent", "rename": "MEM_USED_PERCENT", "unit": "Percent"}
                      ],
                      "resources": [
                        "*"
                      ],
                      "append_dimensions": {
                        "InstanceId": "$INSTANCE_ID"
                      }
                    },
                    "disk": {
                      "measurement": [
                        {"name": "disk_used_percent", "rename": "DISK_USED_PERCENT", "unit": "Percent"}
                      ],
                      "resources": [
                        "*"
                      ],
                      "append_dimensions": {
                        "InstanceId": "$INSTANCE_ID"
                      }
                    }
                  }
                },
                "logs": {
                  "logs_collected": {
                    "files": {
                      "collect_list": [
                        {
                          "file_path": "/var/log/messages",
                          "log_group_name": "var-log-messages",
                          "log_stream_name": "{instance_id}"
                        }
                      ]
                    }
                  }
                }
              }
              EOL
              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/cloudwatch-agent-config.json -s
              EOF
}
