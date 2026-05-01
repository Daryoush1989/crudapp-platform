import json
import sys
from pathlib import Path


def main() -> None:
    if len(sys.argv) != 5:
        raise SystemExit(
            "Usage: render-ecs-task-definition.py "
            "<input-task-definition.json> <output-task-definition.json> "
            "<container-name> <image-uri>"
        )

    input_path = Path(sys.argv[1])
    output_path = Path(sys.argv[2])
    container_name = sys.argv[3]
    image_uri = sys.argv[4]

    task_definition = json.loads(input_path.read_text(encoding="utf-8"))

    allowed_keys = [
        "family",
        "taskRoleArn",
        "executionRoleArn",
        "networkMode",
        "containerDefinitions",
        "volumes",
        "placementConstraints",
        "requiresCompatibilities",
        "cpu",
        "memory",
        "runtimePlatform",
        "ephemeralStorage",
        "proxyConfiguration",
        "inferenceAccelerators",
        "pidMode",
        "ipcMode",
    ]

    rendered = {
        key: task_definition[key]
        for key in allowed_keys
        if key in task_definition
    }

    found_container = False

    for container in rendered["containerDefinitions"]:
        if container["name"] == container_name:
            container["image"] = image_uri
            found_container = True

    if not found_container:
        raise SystemExit(f"Container '{container_name}' not found in task definition.")

    output_path.write_text(
        json.dumps(rendered, indent=2, sort_keys=True),
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()