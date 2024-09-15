from django.core.management import call_command
from django.db.utils import OperationalError
from unittest.mock import patch
from django.test import TestCase

class CommandTests(TestCase):

    @patch('django.db.backends.base.base.BaseDatabaseWrapper.cursor')
    def test_wait_for_db_ready(self, patched_cursor):
        patched_cursor.return_value = True

        call_command('wait_for_db')

        patched_cursor.assert_called_once()

    '''
    @patch('time.sleep', return_value=None)
    @patch('django.db.backends.base.base.BaseDatabaseWrapper.cursor')
    def test_wait_for_db_delay(self, patched_cursor, patched_sleep):
        patched_cursor.side_effect = [OperationalError] * 5 + [True]
        
        call_command('wait_for_db')

        self.assertEqual(patched_cursor.call_count, 6)
    '''