import argparse
import yaml


def get_args():
    parser = argparse.ArgumentParser()

    # Model Params
    parser.add_argument("--max_cycle_length", type=int, default=99)
    parser.add_argument("--default_cycle_length", type=int, default=28)
    parser.add_argument("--average_min", type=int, default=21)
    parser.add_argument("--average_max", type=int, default=39)
    parser.add_argument("--end_of_cycle_alert_days", type=int, default=3)
    parser.add_argument("--regular_cycle_range_min", type=int, default=26)
    parser.add_argument("--regular_cycle_range_max", type=int, default=32)
    parser.add_argument("--fertile_window_start", type=int, default=8)
    parser.add_argument("--fertile_window_end", type=int, default=19)
    parser.add_argument("--beep_alert_on", type=int, default=8)
    parser.add_argument("--beep_alert_off", type=int, default=20)
    parser.add_argument("--average_window", type=int, default=3)

    # Config file
    config_parser = argparse.ArgumentParser(description='Algorithm Config', add_help=False)
    config_parser.add_argument('-c',
                               '--config',
                               default=None,
                               type=str,
                               help='YAML config file')

    args_config, remaining = config_parser.parse_known_args()
    assert args_config.config is not None, 'Config file must be specified'

    with open(args_config.config, 'r') as f:
        cfg = yaml.safe_load(f)
        parser.set_defaults(**cfg)

    args = parser.parse_args(remaining)

    return args


if __name__ == '__main__':
    args = get_args()
    print(args)