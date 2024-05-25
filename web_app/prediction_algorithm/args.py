import argparse
import yaml


def get_args():
    parser = argparse.ArgumentParser()

    # User Actions
    parser.add_argument("--record_new_cycle", type=int, default=0)
    parser.add_argument("--day_of_cycle", type=int, default=1)
    parser.add_argument("--reset", type=int, default=0)

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

    # Save Data
    parser.add_argument("--save_path", type=str)
    parser.add_argument("--save_file_name", type=str)

    # Config File
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
    assert args.save_path and args.save_file_name is not None, 'Past data directory and file name must be specified'
    assert args.record_new_cycle in [0, 1], 'record_new_cycle can only take value 0 or 1 for boolean conversion'
    assert args.reset in [0, 1], 'reset can only take value 0 or 1 for boolean conversion'
    args.record_new_cycle = bool(args.record_new_cycle)
    args.reset = bool(args.reset)
    assert args.day_of_cycle >= 1 and args.day_of_cycle <= args.max_cycle_length, 'Check day_of_cycle input'

    return args


if __name__ == '__main__':
    args = get_args()
    print(args)