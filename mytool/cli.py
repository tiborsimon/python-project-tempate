from termcolor import colored
from pkg_resources import get_distribution

yellow = lambda x: colored(x, 'yellow', attrs=['bold'])

def entry():
    version = get_distribution('mytool').version
    print(yellow('mytool {}'.format(version)) + ' command line python interface entry point.')

def main():
    entry()


if __name__ == '__main__':
    main()

