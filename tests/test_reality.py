import unittest
import xmlrunner

class RealityTest(unittest.TestCase):

    def test_math_still_works(self):
        self.assertEqual(1+1, 2)

    def test_physics_still_works(self):
        self.assertTrue('Up' == 'Up')
        self.assertFalse('Up' == 'Down')

if __name__ == '__main__':
    unittest.main(testRunner=xmlrunner.XMLTestRunner(output='test-reports'))