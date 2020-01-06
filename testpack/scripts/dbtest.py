#!/usr/bin/env python3

import unittest
from testpack_helper_library.unittests.dockertests import Test1and1Common
import time


class Test1and1Image(Test1and1Common):
    # <tests to run>

    def test_docker_logs(self):
        time.sleep(10)
        expected_log_lines = [
            "Executing hook /hooks/supervisord-pre.d/21_cleanup_log_files",
            "Executing hook /hooks/supervisord-pre.d/40_phpmyadmin_config_secret",
            "Executing hook /hooks/supervisord-pre.d/52_mysql_general_log",
            "Executing hook /hooks/supervisord-pre.d/90_mysql_time_zone"
        ]
        container_logs = self.logs()
        for expected_log_line in expected_log_lines:
            self.assertTrue(
                container_logs.find(expected_log_line) > -1,
                msg="Docker log line missing: %s from (%s)" % (expected_log_line, container_logs)
            )

    def test_mysql_running(self):
        time.sleep(10)
        self.assertTrue(
            self.exec("ps -ef").find('mysqld_safe') > -1,
            msg="mysqld_safe not running"
        )


    # </tests to run>

if __name__ == '__main__':
    unittest.main(verbosity=1)
