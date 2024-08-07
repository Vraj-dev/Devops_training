#!/usr/bin/env python

import boto3
import json

def get_instances():
    ec2 = boto3.client('ec2')
    response = ec2.describe_instances(
        Filters=[
            {
                'Name': 'tag:Role',
                'Values': ['webserver']
            },
            {
                'Name': 'instance-state-name',
                'Values': ['running']
            }
        ]
    )

    instances = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instances.append(instance['PublicIpAddress'])

    return instances

if __name__ == "__main__":
    inventory = {
        'webserver': {
            'hosts': get_instances()
        },
        '_meta': {
            'hostvars': {}
        }
    }

    print(json.dumps(inventory))
