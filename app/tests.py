
from django.test import SimpleTestCase

from app import calc

class CalcTests(SimpleTestCase):

    def test_add_numbers(self):
        """Test that two numbers are added together"""
        self.assertEqual(calc.add(3, 8), 11)

        res = calc.add(3, 11)
        self.assertEqual(res, 14)

    def test_subtract_numbers(self):
        res = calc.subtract(5, 11)

        self.assertEqual(res, 6)

        