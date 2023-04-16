import sys, json, argparse



def test_for_sys(ins):
    print(json.load(sys.stdin)[ins])
parser = argparse.ArgumentParser(description='Test for argparse')
parser.add_argument('--ins', '-i', help='ins 属性，必要参数', required=True)
args = parser.parse_args()


if __name__ == '__main__':
    try:
        test_for_sys(args.ins)
    except Exception as e:
        print(e)