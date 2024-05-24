import numpy as np
import datetime
import os.path as osp
import os


def datetime_to_str(input):
    return input.strftime('%Y/%m/%d')


def str_to_datetime(input: str):
    details = input.split('/')
    return datetime.date(int(details[0]), int(details[1]), int(details[2]))


def save_data(data, save_dir: str, file_name: str):

    _, tail = osp.split(save_dir)
    if tail == file_name:
        path = save_dir
    else:
        path = osp.join(save_dir, file_name)

    with open(path, 'a') as file:
        file.write(data + '\n')


def get_past_data(save_dir: str, file_name: str):

    _, tail = osp.split(save_dir)
    if tail == file_name:
        path = save_dir
    else:
        path = osp.join(save_dir, file_name)

    assert osp.exists(path), 'Past data file does not exist'
    
    with open(path, 'r') as file:
        data = file.read()

    if len(data) == 0:
        return {'past_cycle_lengths': [], 'past_event_dates': []}

    data = data.split('\n')
    if data[-1] == '':
        data = data[:-1]

    durations = []
    dates = []
    for entry in data:
        durations.append(int(entry.split(' ')[0]))
        dates.append(entry.split(' ')[1])
    
    return {'past_cycle_lengths': durations, 'past_event_dates': dates}


def reset(save_dir: str, file_name: str):

    _, tail = osp.split(save_dir)
    if tail == file_name:
        path = save_dir
    else:
        path = osp.join(save_dir, file_name)

    assert osp.exists(path), 'Past data file does not exist'

    with open(path, 'w') as file:
        file.truncate(0)