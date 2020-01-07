#!/usr/bin/env python3

import unittest
from testpack_helper_library.unittests.dockertests import Test1and1Common
import time


class Test1and1Image(Test1and1Common):
    dbname = 'unittestdb'
    dbuser = 'user123'
    dbpasswd = 'user123passw'

    @classmethod
    def setUpClass(cls):
        environment = {
            'MYSQL_DATABASE': Test1and1Image.dbname,
            'MYSQL_ADMIN_USER': Test1and1Image.dbuser,
            'MYSQL_ADMIN_PASSWORD': Test1and1Image.dbpasswd
        }
        Test1and1Common.setUpClass(environment=environment)
        print("Waiting for database to be configured before starting tests...")
        time.sleep(10)

    # <tests to run>

    def test_docker_logs(self):
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
        self.assertTrue(
            self.exec("ps -ef").find('mysqld_safe') > -1,
            msg="mysqld_safe not running"
        )

    def test_login(self):
        driver = self.getChromeDriver()
        driver.get(Test1and1Image.endpoint)
        self.assertEqual('phpMyAdmin', driver.title)
        driver.find_element_by_id("input_username").send_keys(Test1and1Image.dbuser)
        driver.find_element_by_id("input_password").send_keys(Test1and1Image.dbpasswd)
        driver.find_element_by_id("input_go").click()
        self.assertIsNotNone(driver.find_element_by_id("pma_navigation_tree_content"))

    # </tests to run>

if __name__ == '__main__':
    unittest.main(verbosity=1)
