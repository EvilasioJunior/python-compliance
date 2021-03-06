#!/usr/bin/python

import os
import sys
import subprocess
import shutil

import re
import linecache


# This is where the Makefile lives:
FRONTEND_DIR = os.path.join(os.getcwd(), '..', 'pycomply')

# This is what the Makefile builds:
FRONTEND_EXE = os.path.join(FRONTEND_DIR, 'run')

# I need to record errors for each processed file:
ERROR_LOG = os.path.join(os.getcwd(), 'error.log')

# The versions of Python we have front-ends for:
SERIES2 = ['2.0', '2.2', '2.3', '2.4', '2.4.3', '2.5', '2.6', '2.7', '2.7.2']
SERIES3 = ['3.0', '3.1', '3.2', '3.3.0', '3.5.0', '3.6.0']

# The versions we're using for the ESEM paper:
FOR_ESEM = ['2.5', '2.6', '2.7', '3.0', '3.1', '3.2', '3.3.0', '3.5.0']

# Where are the suites that you want to analyse?
TEST_ROOTS = {
    'qualitas' : '/media/passport/bigApps/corpus-python/qualitas',
    'getpython3' : '/media/passport/bigApps/corpus-python/getpython3',
    'anaconda3' : '/media/passport/bigApps/anaconda3/pkgs',
    'top20-github' : '/media/passport/bigApps/corpus-python/top20-github',
    'linchen' : '/media/passport/bigApps/corpus-python/linchen',
    'destefanis' : '/media/passport/bigApps/corpus-python/destefanis',
}

# Need to fix 'print' to be version-agnostic, even for early 2.x
def safe_print(msg, pfile=sys.stdout, pflush=False, pend='\n'):
    pfile.write(msg+pend)
    if pflush:
        pfile.flush()


        
class TestHarness:

    def __init__(self, version, verbose=False):
        self.noPassed = 0
        self.noFailed = 0
        self.verbose = verbose
        self.make_executable(version)

    @staticmethod
    def copy_file(srcFolder, srcFile, dstFile):
        srcPath = os.path.join(FRONTEND_DIR, srcFolder, srcFile)
        assert os.path.isfile(srcPath), 'File %s not found' % srcPath
        dstPath = os.path.join(FRONTEND_DIR, dstFile)
        shutil.copyfile(srcPath, dstPath)

    @staticmethod
    def shell_run(cmd):
        return subprocess.call(cmd, cwd=FRONTEND_DIR, shell=True)
    
    def make_executable(self, ver, forceMake=False):
        '''Run make if you can't find the executable'''
        self.ver_front_end = os.path.join(FRONTEND_DIR, 'pycomply-%s' % ver)
        if forceMake or not os.path.isfile(self.ver_front_end):
            safe_print('--- Building front-end for v%s' % ver, sys.stderr)
            TestHarness.copy_file('scanners', ver+'.l', 'scan.l')
            TestHarness.copy_file('parsers', ver+'.y', 'parse.y')
            retcode = TestHarness.shell_run('make')
            assert retcode == 0, '\t*** FAILED to make the parser'
            os.rename(FRONTEND_EXE, self.ver_front_end)

    def init_counters(self):
        self.noPassed = 0
        self.noFailed = 0

    def set_verbose(self):
        self.verbose = True

    @staticmethod
    def count_tests(testpath):
        '''Just count the number of .py file in a directory and its subdirs'''
        assert os.path.isdir(testpath), testpath + 'must be a directory'
        count = 0
        for _, _, files in os.walk(testpath):
            pyFiles = [filename for filename in files
                       if filename.endswith('.py')]
            count += len(pyFiles)
        return count

    @staticmethod
    def print_context(filename, line_no):
        '''Print a few lines from filename surrounding a syntax error'''
        for d in [line_no-1, line_no, line_no+1]:
            safe_print('%d:%s' % (d, linecache.getline(filename, d)),
                       sys.stderr, True, '')
        safe_print('')

    def check_return_code(self, retcode, testcase):
        '''Check if there were errors, print some context, increment counters'''
        if retcode > 0:  # Syntax errors
            if self.verbose:
                safe_print('\n* ' + testcase+ ' failed.', sys.stderr)
                try:  # Print some context for the syntax error:
                    with open(ERROR_LOG, 'r') as tmp_fh:
                        error_msg = tmp_fh.read()
                        safe_print(error_msg, sys.stderr, True, '')
                        match = re.match('^(\d+)', error_msg)
                        if match:
                            line_no = int(match.group(1))
                            self.print_context(testcase, line_no)
                except (UnicodeDecodeError) as err:
                    safe_print('Exception %s' % err, sys.stderr)
            self.noFailed += 1
        else: # No errors
            self.noPassed += 1

    def test_one_file(self, root, filename):
        '''Run the front-end, test the return code'''
        testcase = os.path.join(root, filename)
        toExec = 'sed -e \'$a\\\' "%s" | %s > %s 2>&1' \
                 % (testcase, self.ver_front_end, ERROR_LOG)
        retcode = TestHarness.shell_run(toExec)
        self.check_return_code(retcode, testcase)

    def test_directory(self, testpath, reinit=False):
        '''Test all .py files in a directory and all its subdirs'''
        assert os.path.isdir(testpath), testpath + 'must be a directory'
        if reinit:
            self.init_counters()
        for root, dirs, files in os.walk(testpath):
            for filename in files:
                if filename.endswith('.py'):
                    self.test_one_file(root, filename)

    def get_total(self):
        '''How many files were tested in total'''
        return (self.noPassed + self.noFailed)

    def percent_passed(self):
        if self.get_total() == 0:
            return 0
        return self.noPassed * 100.0 / self.get_total()

    def __str__(self):
        return '%d Passed, %d Failed (%5.2f%% passed)' \
                % (self.noPassed, self.noFailed, self.percentPassed())


def mk_harness(runver, verbose=False):
    ''' Making this a function allows us to parameterise test_all '''
    return TestHarness(runver, verbose)

def test_all(pyVersions, testroot, testapps, build_harness=mk_harness):
    '''Test all .py files in testapps directories, for each given pyversion.
       We assemble the data column-by-column (one column per Python version).
       Return a list of the percentage pass rates, one 'row' per testapp.
    '''
    percs =  [[] for t in testapps]  # one row per testcase
    for runver in pyVersions:
        harness = build_harness(runver)
        safe_print("Running front-end for v%s on %d apps:"
              % (runver, len(testapps)),
              sys.stderr, True, '')
        for i,testdir in enumerate(testapps):
            safe_print(" %s," % testdir, sys.stderr, True, '')
            harness.test_directory(os.path.join(testroot,testdir), True)
            percs[i].append(harness.percent_passed())
        safe_print(' done.', sys.stderr)
    return percs



##### Print routines and other scaffolding #####

def print_csv_table(pyVersions, testroot, testapps, percs):
    SEP = ','
    # First column of table should be the application names:
    row_data =  [[t] for t in testapps]
    # Data columns are the percentages for each version:
    for i, plist in enumerate(percs):
        row_data[i].extend(['%.2f' % p for p in plist])
    # Last column should be totals for each application:
    for i,testdir in enumerate(testapps):
        testpath = os.path.join(testroot,testdir)
        row_data[i].append('%d' % TestHarness.count_tests(testpath))
    # Now print the table, row-by-row:
    header = ['#Application'] + [p for p in pyVersions] + ['Files']
    for row in [header] + row_data:
        safe_print(SEP.join(row))


def get_dirnames(root):
    ''' Return a list of all subdirectories of a directory '''
    dirs = [d for d in os.listdir(root)
            if os.path.isdir(os.path.join(root,d))]
    return sorted(dirs, key=lambda s: s.lower()) # Case insensitive sort


def get_pyvers_testapps(args):
    ''' Use the (command-line) args to specify front-end(s), corpus or app(s) '''
    test_root = TEST_ROOTS['qualitas']  # Default to Qualitas corpus
    full_suite = get_dirnames(test_root)
    testapps = [ ]
    versions = [ ]
    for arg in args:  
        if arg in SERIES2+SERIES3: # Specify a Python version
            versions.append(arg)
        elif arg in full_suite:  # Specify an application
            testapps.append(arg)
        elif arg in TEST_ROOTS.keys(): # Specify corpus
            test_root = TEST_ROOTS[arg]
            full_suite = get_dirnames(test_root)            
        else:
            safe_print('Unknown argument "%s"' % arg, sys.stderr)
            exit(1)
    if versions == []: # None specified, so use *all* the Python front-ends
        versions = FOR_ESEM # or SERIES2+SERIES3 
    if testapps == []: # None specified, so test all the applications
        testapps = full_suite
    return (versions, test_root, testapps)


if __name__ == '__main__':
    versions, test_root, testapps = get_pyvers_testapps(sys.argv[1:])
    percs = test_all(versions, test_root, testapps, mk_harness)
    print_csv_table(versions, test_root, testapps, percs)
