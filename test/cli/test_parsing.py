from unittest import TestCase

from regx.cli.parser import parse_args


class PatternParsing(TestCase):
    def test__single_pattern(self):
        data = ['-p', 'pattern1']
        expected = {
            'p1': 'pattern1'
        }
        result = parse_args(data)
        result = result['patterns']
        self.assertEquals(expected, result)

    def test__multiple_patterns(self):
        data = ['-p', 'pattern1', '-p', 'pattern2', '-p', 'pattern3']
        expected = {
            'p1': 'pattern1',
            'p2': 'pattern2',
            'p3': 'pattern3'
        }
        result = parse_args(data)
        result = result['patterns']
        self.assertEquals(expected, result)


class ActionParsing(TestCase):
    def test__single_action(self):
        data = ['-a', 'pattern1']
        expected = {
            'p1': 'pattern1'
        }
        result = parse_args(data)
        result = result['patterns']
        self.assertEquals(expected, result)

    def test__multiple_patterns(self):
        data = ['-p', 'pattern1', '-p', 'pattern2', '-p', 'pattern3']
        expected = {
            'p1': 'pattern1',
            'p2': 'pattern2',
            'p3': 'pattern3'
        }
        result = parse_args(data)
        result = result['patterns']
        self.assertEquals(expected, result)


