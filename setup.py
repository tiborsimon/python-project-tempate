from setuptools import find_packages, setup

import mytool

setup(
    name='mytool',
    version=mytool.__version__,
    description='My python command line tool.',
    long_description="",
    author='Your Name',
    author_email='you@email.org',
    url='https://github.com/yourname/mytool',
    license='MIT',
    test_suite='test',
    keywords='regular expression regex tool power',
    packages=find_packages(exclude=['docs', 'test']),
    install_requires=['termcolor'],
    include_package_data=True,
    zip_safe=False,
    classifiers=[
          'Development Status :: 2 - Pre-Alpha',
          'Intended Audience :: Developers',
          'Topic :: Utilities',
          'Environment :: Console',
          'Natural Language :: English',
          'Operating System :: MacOS :: MacOS X',
          'Operating System :: Unix',
          'License :: OSI Approved :: MIT License',
          'Programming Language :: Python',
    ],
    entry_points = {
        'console_scripts': [
            'mytool=mytool.cli:main',
        ],
    },
)
