import yaml
import os.path
import sys


def parse(target, template: str, template_key: str, block_key: str, block_number: int, config: dict, parent_key: str):
    params = {
        f"{template_key}_number": block_number,
        f"{template_key}_name": block_key if parent_key == '' else f"{parent_key}.{block_key}",
        f"{template_key}": block_key,
    }
    for key, value in config.items():
        if type(value) is dict:
            for subkey, sub_value in value.items():
                params[f"{template_key}.{key}.{subkey}"] = sub_value
        else:
            params[f"{template_key}.{key}"] = value

    for key, value in params.items():
        raw_string = repr(f"{value}")[1:-1]
        template = template.replace(f"${{{key}}}", raw_string)
        # print(f"{key}: {raw_string}")

    target.write(f"\n\n{template}")


def parse_blocks(target, template: str, template_key: str, blocks: list, parent_key: str = ''):
    counter = 0
    for block in blocks:
        parse_block(target, template, template_key, counter, block, parent_key)
        counter = counter + 1


def parse_block(target, template: str, template_key: str, block_number: int, block: dict, parent_key: str):
    for key, value in block.items():
        if type(value) is list:
            full_key = key if parent_key == '' else f"{parent_key}.{key}"
            parse_blocks(target, template, template_key, value, full_key)
        else:
            parse(target, template, template_key, key, block_number, value, parent_key)


def repos_to_config(repos_file: str, config_file: str, templates_dir: str = "/"):
    repos = {}
    with open(repos_file, encoding='utf8') as data:
        try:
            repos = yaml.safe_load(data)
        except yaml.YAMLError as exc:
            print(exc)

    manager = repos.get('manager', {})
    with open(config_file, 'a', encoding='utf8') as config_data:
        for key, blocks in manager.items():
            template_key = key[:-1]
            template_file = f'{os.path.join(templates_dir, template_key)}.tpl'
            if os.path.isfile(template_file):
                with open(template_file, encoding='utf8') as stream:
                    template = stream.read()
                parse_blocks(config_data, template, template_key, blocks)


if __name__ == "__main__":
    repos_to_config(sys.argv[1], sys.argv[2], sys.argv[3])
    # repos_to_config('../repos.yml', 'registry.reg', '../bi/distr')
