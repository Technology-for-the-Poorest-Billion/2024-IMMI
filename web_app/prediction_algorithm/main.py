import numpy as np
import datetime

from args import get_args
from utils import *


def predict_cycle_length(past_cycle_lengths: list, default: int, ma_window: int):

    # Moving average prediction
    if len(past_cycle_lengths) == 0:
        return default
    elif len(past_cycle_lengths) < ma_window:
        return int(np.average(past_cycle_lengths))
    else:
        return int(np.average(past_cycle_lengths[-ma_window:]))
    

def main(args):

    if args.reset:
        reset(args.save_path, args.save_file_name)
        return

    current_date = datetime.datetime.today().date()                 # Get current date
    memory = get_past_data(args.save_path, args.save_file_name)     # Get stored data

    last_cycle_start = None
    last_cycle_length = None
    if len(memory['past_event_dates']) != 0:
        last_cycle_start = memory['past_event_dates'][-1]
        last_cycle_length = memory['past_cycle_lengths'][-1]

    # First time use
    if last_cycle_length is None or last_cycle_start is None:
        # Display data and record event
        if args.record_new_cycle:
            this_cycle_start = (current_date + datetime.timedelta(days=-(args.day_of_cycle-1)))

            # Prediction
            pred_cycle_length = predict_cycle_length(memory['past_cycle_lengths'],
                                                    args.default_cycle_length,
                                                    args.average_window)
            pred_next_cycle_start = (this_cycle_start + datetime.timedelta(days=pred_cycle_length))
            this_cycle_start = datetime_to_str(this_cycle_start)
            pred_next_cycle_start = datetime_to_str(pred_next_cycle_start)

            # Data storing
            new_entry = str(pred_cycle_length) + ' ' + this_cycle_start
            save_data(new_entry, args.save_path, args.save_file_name)

        # Display data when there are NO past data
        else:
            this_cycle_start = None
            pred_cycle_length = predict_cycle_length(memory['past_cycle_lengths'],
                                                     args.default_cycle_length,
                                                     args.average_window)
            pred_next_cycle_start = None

    # With existing data
    else:
        if args.record_new_cycle:
            assert (current_date + datetime.timedelta(days=-args.day_of_cycle)) > str_to_datetime(last_cycle_start), \
                'Offset (day_of_cycle) too large'

            # Display data and record event when identical data is stored
            if datetime_to_str(current_date) == last_cycle_start:
                this_cycle_start = current_date
                pred_cycle_length = last_cycle_length
                pred_next_cycle_start = (this_cycle_start + datetime.timedelta(days=pred_cycle_length))
                this_cycle_start = datetime_to_str(this_cycle_start)
                pred_next_cycle_start = datetime_to_str(pred_next_cycle_start)

            # Display data and record event
            else:
                this_cycle_start = (current_date + datetime.timedelta(days=-(args.day_of_cycle-1)))
                last_cycle_length = (this_cycle_start - str_to_datetime(last_cycle_start)).days

                # Update last prediction
                update_entry = str(last_cycle_length) + ' ' + last_cycle_start
                update_data(update_entry, args.save_path, args.save_file_name)

                # Prediction
                pred_cycle_length = predict_cycle_length(memory['past_cycle_lengths'],
                                                        args.default_cycle_length,
                                                        args.average_window)
                pred_next_cycle_start = (this_cycle_start + datetime.timedelta(days=pred_cycle_length))
                this_cycle_start = datetime_to_str(this_cycle_start)
                pred_next_cycle_start = datetime_to_str(pred_next_cycle_start)

                # Data storing
                new_entry = str(pred_cycle_length) + ' ' + this_cycle_start
                save_data(new_entry, args.save_path, args.save_file_name)

        else:
            # Display data when there are data stored
            this_cycle_start = last_cycle_start
            pred_cycle_length = last_cycle_length
            pred_next_cycle_start = str_to_datetime(last_cycle_start) + datetime.timedelta(days=pred_cycle_length)
            pred_next_cycle_start = datetime_to_str(pred_next_cycle_start)

    # Format and display data
    output = {'this cycle length': pred_cycle_length,
              'this cycle start date': this_cycle_start,
              'next cycle start date': pred_next_cycle_start}
              # pred_fertile_start
    display_output(output)

    return


if __name__ == '__main__':
    args = get_args()
    main(args=args)