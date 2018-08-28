#!/usr/bin/env python3
import base64
import os
import subprocess
import sys

import yaml
from pathlib import Path


EDITOR = os.environ.get('EDITOR', 'vi')


class NoDatesSafeLoader(yaml.SafeLoader):
    @classmethod
    def remove_implicit_resolver(cls, tag_to_remove):
        """
        Remove implicit resolvers for a particular tag

        Takes care not to modify resolvers in super classes.

        We want to load datetimes as strings, not dates, because we
        go on to serialise as json which doesn't have the advanced types
        of yaml, and leads to incompatibilities down the track.
        """
        if 'yaml_implicit_resolvers' not in cls.__dict__:
            cls.yaml_implicit_resolvers = cls.yaml_implicit_resolvers.copy()

        for first_letter, mappings in cls.yaml_implicit_resolvers.items():
            cls.yaml_implicit_resolvers[first_letter] = [
                (tag, regexp)
                for tag, regexp in mappings
                if tag != tag_to_remove
            ]


def repr_str(dumper, data):
    if '\n' in data:
        return dumper.represent_scalar(
            u'tag:yaml.org,2002:str', data, style='|')
    return dumper.orig_represent_str(data)


def get_vals():
    path = Path.home() / ".ksecretvals"
    if not path.exists():
        print("No %s found" % path)
        raise SystemExit(1)
    with path.open() as fid:
        vals = yaml.load(fid, Loader=NoDatesSafeLoader)
    return vals


def edit(fname, vals):
    with open(fname, 'r') as fid:
        secret = yaml.load(fid, Loader=NoDatesSafeLoader)

    if 'data' in secret:
        secret['data'] = {
            k: base64.b64encode(vals[k].encode()) if k in vals else v
            for k, v in secret['data'].items()
        }

    with open(fname, 'w') as fid:
        fid.write(yaml.safe_dump(secret, default_flow_style=False))


def main():
    NoDatesSafeLoader.remove_implicit_resolver('tag:yaml.org,2002:timestamp')
    yaml.SafeDumper.orig_represent_str = yaml.SafeDumper.represent_str
    yaml.add_representer(str, repr_str, Dumper=yaml.SafeDumper)
    fname = sys.argv[1]

    vals = get_vals()
    edit(fname, vals)


if __name__ == '__main__':
    main()
