import json
import sys
from pathlib import Path


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit(
            "Usage: write-ecs-network-config.py "
            "<service-network.json> <ecs-network-config.json>"
        )

    input_path = Path(sys.argv[1])
    output_path = Path(sys.argv[2])

    service_network = json.loads(input_path.read_text(encoding="utf-8"))

    awsvpc = service_network.get("awsvpcConfiguration", service_network)

    subnets = awsvpc.get("subnets", [])
    security_groups = awsvpc.get("securityGroups", [])
    assign_public_ip = awsvpc.get("assignPublicIp", "DISABLED")

    if not subnets:
        raise SystemExit("No subnets found in ECS service network configuration.")

    if not security_groups:
        raise SystemExit("No security groups found in ECS service network configuration.")

    network_config = {
        "awsvpcConfiguration": {
            "subnets": list(subnets),
            "securityGroups": list(security_groups),
            "assignPublicIp": assign_public_ip,
        }
    }

    output_path.write_text(
        json.dumps(network_config, indent=2, sort_keys=True),
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()